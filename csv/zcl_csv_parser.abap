class ZCL_CSV_PARSER definition
  public
  inheriting from ZCL_OBJECT
  final
  create public .

public section.
*"* public components of class zCL_CSV_PARSER
*"* do not include other source files here!!!
  type-pools ABAP .

  methods CONSTRUCTOR
    importing
      !DELEGATE type ref to ZIF_CSV_PARSER_DELEGATE
      !CSVSTRING type STRING
      !SEPARATOR type C
      !SKIP_FIRST_LINE type ABAP_BOOL .
  methods PARSE
    raising
      ZCX_CSV_PARSE_ERROR .
protected section.
*"* protected components of class zCL_CSV_PARSER
*"* do not include other source files here!!!
private section.

*"* private components of class zCL_CSV_PARSER
*"* do not include other source files here!!!
  constants _TEXTINDICATOR type C value '"'. "#EC NOTEXT
  data _DELEGATE type ref to ZIF_CSV_PARSER_DELEGATE .
  data _CSVSTRING type STRING .
  data _SEPARATOR type C .
  data _SKIP_FIRST_LINE type ABAP_BOOL .

  methods _LINES
    returning
      value(RETURNING) type STRINGTAB .
  methods _PARSE_LINE
    importing
      !LINE type STRING
    returning
      value(RETURNING) type STRINGTAB
    raising
      ZCX_CSV_PARSE_ERROR .
ENDCLASS.



CLASS ZCL_CSV_PARSER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CSV_PARSER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] DELEGATE                       TYPE REF TO ZIF_CSV_PARSER_DELEGATE
* | [--->] CSVSTRING                      TYPE        STRING
* | [--->] SEPARATOR                      TYPE        C
* | [--->] SKIP_FIRST_LINE                TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  _delegate = delegate.
  _csvstring = csvstring.
  _separator = separator.
  _skip_first_line = skip_first_line.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CSV_PARSER->PARSE
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_CSV_PARSE_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method parse.
  data msg type string.
  if _csvstring is initial.
    message e002(zcsv) into msg.
    raise exception type zcx_csv_parse_error
      exporting
        message = msg.
  endif.

  " Get the lines
  data is_first_line type abap_bool value abap_true.
  data lines type standard table of string.
  lines = _lines( ).
  field-symbols <line> type string.
  loop at lines assigning <line>.
    " Should we skip the first line?
    if _skip_first_line = abap_true and is_first_line = abap_true.
      is_first_line = abap_false.
      continue.
    endif.
    " Parse the line
    data values type standard table of string.
    values = _parse_line( <line> ).
    " Send values to delegate
    _delegate->values_found( values ).
  endloop.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_PARSER->_LINES
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRINGTAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _lines.
  split _csvstring at cl_abap_char_utilities=>cr_lf into table returning.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_PARSER->_PARSE_LINE
* +-------------------------------------------------------------------------------------------------+
* | [--->] LINE                           TYPE        STRING
* | [<-()] RETURNING                      TYPE        STRINGTAB
* | [!CX!] ZCX_CSV_PARSE_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _parse_line.
  data msg type string.

  data csvvalue type string.
  data csvvalues type standard table of string.

  data char type c.
  data pos type i value 0.
  data len type i.
  len = strlen( line ).
  while pos < len.
    char = line+pos(1).
    if char <> _separator.
      if char = _textindicator.
        data text_ended type abap_bool.
        text_ended = abap_false.
        while text_ended = abap_false.
          pos = pos + 1.
          if pos < len.
            char = line+pos(1).
            if char = _textindicator.
              text_ended = abap_true.
            else.
              if char is initial. " Space
                concatenate csvvalue ` ` into csvvalue.
              else.
                concatenate csvvalue char into csvvalue.
              endif.
            endif.
          else.
            " Reached the end of the line while inside a text value
            " This indicates an error in the CSV formatting
            text_ended = abap_true.
            message e003(zcsv) into msg.
            raise exception type zcx_csv_parse_error
              exporting
                message = msg.
          endif.
        endwhile.
        " Check if next character is a separator, otherwise the CSV formatting is incorrect
        data nextpos type i.
        nextpos = pos + 1.
        if nextpos < len and line+nextpos(1) <> _separator.
          message e003(zcsv) into msg.
          raise exception type zcx_csv_parse_error
            exporting
              message = msg.
        endif.
      else.
        if char is initial. " Space
          concatenate csvvalue ` ` into csvvalue.
        else.
          concatenate csvvalue char into csvvalue.
        endif.
      endif.
    else.
      append csvvalue to csvvalues.
      clear csvvalue.
    endif.
    pos = pos + 1.
  endwhile.
  append csvvalue to csvvalues. " Don't forget the last value

  returning = csvvalues.
endmethod.
ENDCLASS.
