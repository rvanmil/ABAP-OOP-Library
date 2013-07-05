class ZCL_XMLPARSER definition
  public
  inheriting from ZCL_OBJECT
  final
  create public .

public section.
*"* public components of class zCL_XMLPARSER
*"* do not include other source files here!!!
  type-pools ABAP .

  constants ERROR_DELEGATEABORTEDPARSE type I value 1. "#EC NOTEXT
  constants ERROR_UNSUPPORTEDNODETYPE type I value 2. "#EC NOTEXT
  constants ERROR_EMPTYDOCUMENT type I value 3. "#EC NOTEXT

  methods INIT_WITH_STRING
    importing
      !XMLSTRING type STRING
    raising
      ZCX_INVALID_XML .
  methods SET_DELEGATE
    importing
      !DELEGATE type ref to ZIF_XMLPARSER_DELEGATE .
  methods PARSE
    returning
      value(RETURNING) type ABAP_BOOL .
  methods ABORT_PARSING .
protected section.
*"* protected components of class zCL_XMLPARSER
*"* do not include other source files here!!!
private section.

*"* private components of class zCL_XMLPARSER
*"* do not include other source files here!!!
  data DELEGATE type ref to ZIF_XMLPARSER_DELEGATE .
  data IXML_DOCUMENT type ref to IF_IXML_DOCUMENT .
  data ABORTED_BY_DELEGATE type ABAP_BOOL value ABAP_FALSE. "#EC NOTEXT .  . " .

  methods PROCESS_NODE
    importing
      !NODE type ref to IF_IXML_NODE
    returning
      value(RETURNING) type ABAP_BOOL .
  methods DID_START_DOCUMENT .
  methods DID_END_DOCUMENT .
  methods DID_START_ELEMENT
    importing
      !ELEMENT type ref to IF_IXML_NODE .
  methods DID_END_ELEMENT
    importing
      !ELEMENT type ref to IF_IXML_NODE .
  methods FOUND_CHARACTERS
    importing
      !ELEMENT type ref to IF_IXML_NODE .
  methods FOUND_COMMENT
    importing
      !ELEMENT type ref to IF_IXML_NODE .
  methods ERROR_OCCURRED
    importing
      !ERROR type I .
ENDCLASS.



CLASS ZCL_XMLPARSER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_XMLPARSER->ABORT_PARSING
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method abort_parsing.
    me->aborted_by_delegate = abap_true.
  endmethod.                    "abort_parsing


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_XMLPARSER->DID_END_DOCUMENT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method did_end_document.
    if me->delegate is bound and me->aborted_by_delegate = abap_false.
      me->delegate->parser_did_end_document( parser = me ).
    endif.
  endmethod.                    "did_end_document


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_XMLPARSER->DID_END_ELEMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] ELEMENT                        TYPE REF TO IF_IXML_NODE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method did_end_element.
    if me->delegate is bound and me->aborted_by_delegate = abap_false.
      data elementname type string.
      elementname = element->get_name( ).
      me->delegate->parser_did_end_element( parser = me elementname = elementname ).
    endif.
  endmethod.                    "did_end_element


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_XMLPARSER->DID_START_DOCUMENT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method did_start_document.
    if me->delegate is bound and me->aborted_by_delegate = abap_false.
      me->delegate->parser_did_start_document( parser = me ).
    endif.
  endmethod.                    "did_start_document


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_XMLPARSER->DID_START_ELEMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] ELEMENT                        TYPE REF TO IF_IXML_NODE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method did_start_element.
    if me->delegate is bound and me->aborted_by_delegate = abap_false.
      data elementname type string.
      elementname = element->get_name( ).
      me->delegate->parser_did_start_element( parser = me elementname = elementname ).
    endif.
  endmethod.                    "did_start_element


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_XMLPARSER->ERROR_OCCURRED
* +-------------------------------------------------------------------------------------------------+
* | [--->] ERROR                          TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method error_occurred.
    if me->delegate is bound and me->aborted_by_delegate = abap_false.
      me->delegate->parser_error_occurred( parser = me error = error ).
    endif.
  endmethod.                    "error_occurred


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_XMLPARSER->FOUND_CHARACTERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] ELEMENT                        TYPE REF TO IF_IXML_NODE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method found_characters.
    if me->delegate is bound and me->aborted_by_delegate = abap_false.
      data characters type string.
      characters = element->get_value( ).
      me->delegate->parser_found_characters( parser = me characters = characters ).
    endif.
  endmethod.                    "found_characters


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_XMLPARSER->FOUND_COMMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] ELEMENT                        TYPE REF TO IF_IXML_NODE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method found_comment.
    if me->delegate is bound and me->aborted_by_delegate = abap_false.
      data comment type string.
      comment = element->get_value( ).
      me->delegate->parser_found_comment( parser = me comment = comment ).
    endif.
  endmethod.                    "found_comment


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_XMLPARSER->INIT_WITH_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] XMLSTRING                      TYPE        STRING
* | [!CX!] ZCX_INVALID_XML
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method init_with_string.
    data ixml type ref to if_ixml.
    ixml = cl_ixml=>create( ).
    data streamfactory type ref to if_ixml_stream_factory.
    streamfactory = ixml->create_stream_factory( ).
    data istream type ref to if_ixml_istream.
    istream = streamfactory->create_istream_string( xmlstring ).
    data parser type ref to if_ixml_parser.
    me->ixml_document = ixml->create_document( ).
    parser = ixml->create_parser( stream_factory = streamfactory istream = istream document = me->ixml_document ).
    if parser->parse( ) <> 0.
      istream->close( ).
      raise exception type zcx_invalid_xml.
    endif.
    istream->close( ).
  endmethod.                    "init_with_string


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_XMLPARSER->PARSE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method parse.
    if me->ixml_document is bound.
      me->process_node( node = me->ixml_document ).
    else.
      " Nothing to parse
      me->error_occurred( error = error_emptydocument ).
      returning = abap_false.
      return.
    endif.
  endmethod.                    "parse


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_XMLPARSER->PROCESS_NODE
* +-------------------------------------------------------------------------------------------------+
* | [--->] NODE                           TYPE REF TO IF_IXML_NODE
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method process_node.
    if me->aborted_by_delegate = abap_false.
      " The node type tells us if we're at a new element, or inside an element
      data node_type type i.
      node_type = node->get_type( ).
      case node_type.
        when if_ixml_node=>co_node_document or if_ixml_node=>co_node_element. " New document or element
          " Start of document/element
          if node_type = if_ixml_node=>co_node_document.
            me->did_start_document( ).
          else.
            me->did_start_element( element = node ).
          endif.
          " Recursively process all child nodes
          data children type ref to if_ixml_node_list.
          children = node->get_children( ).
          data it_children type ref to if_ixml_node_iterator.
          it_children = children->create_iterator( ).
          do.
            data childnode type ref to if_ixml_node.
            childnode = it_children->get_next( ).
            if childnode is not bound.
              exit. " All child nodes processed
            endif.
            me->process_node( node = childnode ).
          enddo.
          " End of document/element
          if node_type = if_ixml_node=>co_node_document.
            me->did_end_document( ).
          else.
            me->did_end_element( element = node ).
          endif.
          " Parse finished successfully
          returning = abap_true.
          return.
        when if_ixml_node=>co_node_text. " Characters inside an element
          me->found_characters( element = node ).
          " Parse finished successfully
          returning = abap_true.
          return.
        when if_ixml_node=>co_node_comment. " Comment
          me->found_comment( element = node ).
          " Parse finished successfully
          returning = abap_true.
          return.
        when others. " Unsupported node type
          me->error_occurred( error = error_unsupportednodetype ).
          " Parse finished with errors
          returning = abap_false.
          return.
      endcase.
    else.
      " Parse aborted
      returning = abap_false.
    endif.
  endmethod.                    "process_node


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_XMLPARSER->SET_DELEGATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] DELEGATE                       TYPE REF TO ZIF_XMLPARSER_DELEGATE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method set_delegate.
    me->delegate = delegate.
  endmethod.                    "set_delegate
ENDCLASS.
