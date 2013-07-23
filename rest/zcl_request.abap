class ZCL_REQUEST definition
  public
  inheriting from ZCL_OBJECT
  final
  create public .

public section.

  data REQUEST type ref to IF_HTTP_REQUEST .

  methods CONSTRUCTOR
    importing
      !REQUEST type ref to IF_HTTP_REQUEST .
  methods GET_BODY_BINARY
    returning
      value(RETURNING) type XSTRING .
  methods GET_BODY_TEXT
    returning
      value(RETURNING) type STRING .
  methods GET_BODY_JSON
    returning
      value(RETURNING) type ref to ZIF_JSON_VALUE
    raising
      ZCX_JSON_PARSE_ERROR .
  methods GET_CONTENT_TYPE
    returning
      value(RETURNING) type STRING .
  methods GET_HEADER
    importing
      !NAME type STRING
    returning
      value(RETURNING) type STRING .
  methods GET_METHOD
    returning
      value(RETURNING) type STRING .
  methods GET_PARAMETER
    importing
      !NAME type STRING
    returning
      value(RETURNING) type STRING .
  methods GET_RAW_MESSAGE
    returning
      value(RETURNING) type XSTRING .
  methods GET_REQUESTURI
    returning
      value(RETURNING) type STRING .
  methods LIST_HEADERS
    returning
      value(RETURNING) type TIHTTPNVP .
  methods LIST_PARAMETERS
    returning
      value(RETURNING) type TIHTTPNVP .
protected section.
*"* protected components of class zCL_REQUEST
*"* do not include other source files here!!!
private section.
ENDCLASS.



CLASS ZCL_REQUEST IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO IF_HTTP_REQUEST
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  me->request = request.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->GET_BODY_BINARY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_body_binary.
*/**
* Retrieves the body of the request as binary data.
*/
  returning = me->request->get_data( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->GET_BODY_JSON
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO ZIF_JSON_VALUE
* | [!CX!] ZCX_JSON_PARSE_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_body_json.
*/**
* Retrieves the body of the request as a JSON value object.
*/
  data: json_parser type ref to zcl_json_parser,
        json_string type string.
  create object json_parser.
  json_string = me->request->get_cdata( ).
  returning = json_parser->deserialize( json_string ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->GET_BODY_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_body_text.
*/**
* Retrieves the body of the request as a string.
*/
  returning = me->request->get_cdata( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->GET_CONTENT_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_content_type.
*/**
* Returns the MIME type of the body of the request, or null if the type is not known.
*/
  returning = me->request->get_content_type( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->GET_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_header.
*/**
* Returns the value of the specified request header
* as a string. If the request did not include a header
* of the specified name, this method returns null.
*/
  returning = me->request->get_header_field( name ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->GET_METHOD
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_method.
*/**
* Returns the name of the HTTP method with which this request was made,
* for example, GET, POST, or PUT.
*/
  returning = me->request->if_http_entity~get_header_field( '~request_method' ).
  " returning = me->request->get_method( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->GET_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_parameter.
*/**
* Returns the value of a request parameter as a String,
* or null if the parameter does not exist.
* Request parameters are extra information sent with the request.
*/
  returning = me->request->get_form_field_cs( name ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->GET_RAW_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_raw_message.
  returning = me->request->get_raw_message( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->GET_REQUESTURI
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_requesturi.
*/**
* Returns the part of this request's URL from the protocol name up to the query string in the first line of the HTTP request.
* Examples:
* First line of HTTP request           Returned Value
* POST /some/path.html HTTP/1.1        /some/path.html
* GET http://foo.bar/a.html HTTP/1.0   /a.html
* HEAD /xyz?a=b HTTP/1.1               /xyz
*/
  returning = me->request->get_header_field( '~path_info' ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->LIST_HEADERS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        TIHTTPNVP
* +--------------------------------------------------------------------------------------</SIGNATURE>
method list_headers.
*/**
* Returns all request headers
*/
  me->request->get_header_fields( changing fields = returning ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REQUEST->LIST_PARAMETERS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        TIHTTPNVP
* +--------------------------------------------------------------------------------------</SIGNATURE>
method list_parameters.
*/**
* Returns all request parameters
*/
  me->request->get_form_fields_cs( changing fields = returning ).
endmethod.
ENDCLASS.
