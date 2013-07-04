class CL_RESPONSE definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_RESPONSE
*"* do not include other source files here!!!
  interfaces IF_RESPONSE .

  aliases ADD_HEADER
    for IF_RESPONSE~ADD_HEADER .
  aliases DISABLE_COMPRESSION
    for IF_RESPONSE~DISABLE_COMPRESSION .
  aliases EXPIRES_AFTER
    for IF_RESPONSE~EXPIRES_AFTER .
  aliases EXPIRES_AT
    for IF_RESPONSE~EXPIRES_AT .
  aliases IS_COMMITTED
    for IF_RESPONSE~IS_COMMITTED .
  aliases SEND_ACCEPTED
    for IF_RESPONSE~SEND_ACCEPTED .
  aliases SEND_BAD_REQUEST
    for IF_RESPONSE~SEND_BAD_REQUEST .
  aliases SEND_BINARY
    for IF_RESPONSE~SEND_BINARY .
  aliases SEND_CREATED
    for IF_RESPONSE~SEND_CREATED .
  aliases SEND_ERROR
    for IF_RESPONSE~SEND_ERROR .
  aliases SEND_INTERNAL_SERVER_ERROR
    for IF_RESPONSE~SEND_INTERNAL_SERVER_ERROR .
  aliases SEND_NOT_FOUND
    for IF_RESPONSE~SEND_NOT_FOUND .
  aliases SEND_OK
    for IF_RESPONSE~SEND_OK .
  aliases SEND_TEXT
    for IF_RESPONSE~SEND_TEXT .
  aliases SEND_UNAUTHORIZED
    for IF_RESPONSE~SEND_UNAUTHORIZED .

  methods CONSTRUCTOR
    importing
      !RESPONSE type ref to IF_HTTP_RESPONSE .
protected section.
*"* protected components of class CL_RESPONSE
*"* do not include other source files here!!!
private section.

*"* private components of class CL_RESPONSE
*"* do not include other source files here!!!
  data RESPONSE type ref to IF_HTTP_RESPONSE .
  type-pools ABAP .
  data COMMITTED type ABAP_BOOL value ABAP_FALSE. "#EC NOTEXT . " .

  methods COMMIT .
ENDCLASS.



CLASS CL_RESPONSE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~ADD_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~add_header.
*/**
* Add header parameter to the HTTP response
*/
  if me->is_committed( ) = abap_true.
    raise exception type cx_response_committed.
  endif.
  me->response->set_header_field( name = name value = value ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~DISABLE_COMPRESSION
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~disable_compression.
  me->response->set_compression( me->response->co_compress_none ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~EXPIRES_AFTER
* +-------------------------------------------------------------------------------------------------+
* | [--->] SECONDS                        TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~expires_after.
  me->response->server_cache_expire_rel( seconds ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~EXPIRES_AT
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [--->] TIME                           TYPE        T
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~expires_at.
  me->response->server_cache_expire_abs( expires_abs_date = date expires_abs_time = time ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~IS_COMMITTED
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~is_committed.
*/**
* Returns a boolean indicating if the response has been committed.
*/
  returning = me->committed.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~REDIRECT
* +-------------------------------------------------------------------------------------------------+
* | [--->] URL                            TYPE        STRING
* | [--->] PERMANENTLY                    TYPE        I (default =0)
* | [--->] EXPLANATION                    TYPE        STRING (default ='')
* | [--->] PROTOCOL_DEPENDENT             TYPE        I (default =0)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~redirect.
  if me->is_committed( ) = abap_true.
    raise exception type cx_response_committed.
  endif.
  me->response->redirect( url = url permanently = permanently explanation = explanation protocol_dependent = protocol_dependent ).
  me->commit( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_ACCEPTED
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOCATION                       TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_accepted.
*/**
* Send a response to the client with the ACCEPTED status code and the Location header
*/
  if me->is_committed( ) = abap_true.
    raise exception type cx_response_committed.
  endif.
  me->add_header( name = cl_http_header_fields=>location value = location ).
  me->response->set_status( code = cl_http_status_codes=>accepted reason = '' ).
  me->commit( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_BAD_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_bad_request.
*/**
* Send bad request response to the client
*/
  me->send_error( code = cl_http_status_codes=>bad_request message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_BINARY
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA                           TYPE        XSTRING
* | [--->] MIME_TYPE                      TYPE        STRING (default ='application/octet-stream')
* | [--->] CODE                           TYPE        I (default =200)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_binary.
*/**
* Send a response to the client with binary data in the HTTP body
*/
  if me->is_committed( ) = abap_true.
    raise exception type cx_response_committed.
  endif.
  me->response->set_content_type( mime_type ).
  me->response->set_data( data ).
  me->response->set_status( code = code reason = '' ).
  me->commit( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_CREATED
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOCATION                       TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_created.
*/**
* Send a response to the client with the CREATED status code and the Location header
*/
  if me->is_committed( ) = abap_true.
    raise exception type cx_response_committed.
  endif.
  me->add_header( name = cl_http_header_fields=>location value = location ).
  me->response->set_status( code = cl_http_status_codes=>created reason = '' ).
  me->commit( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] CODE                           TYPE        I
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_error.
*/**
* Send a response to the client with a specified status code and message
*/
  if me->is_committed( ) = abap_true.
    raise exception type cx_response_committed.
  endif.
  me->response->set_status( code = code reason = message ).
  me->commit( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_INTERNAL_SERVER_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_internal_server_error.
*/**
* Send internal server error response to the client
*/
  me->send_error( code = cl_http_status_codes=>internal_server_error message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_NOT_FOUND
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_not_found.
*/**
* Send not found response to the client
*/
  me->send_error( code = cl_http_status_codes=>not_found message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_OK
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_ok.
*/**
* Send HTTP status code OK to the client
*/
  if me->is_committed( ) = abap_true.
    raise exception type cx_response_committed.
  endif.
  me->response->set_status( code = cl_http_status_codes=>ok reason = '' ).
  me->commit( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA                           TYPE        STRING
* | [--->] MIME_TYPE                      TYPE        STRING (default ='text/plain')
* | [--->] CODE                           TYPE        I (default =200)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_text.
*/**
* Send a response to the client with a string as the HTTP body
* The string is converted to binary UTF-8 encoded data and eventually sent using the SEND_BINARY method
*/
  if me->is_committed( ) = abap_true.
    raise exception type cx_response_committed.
  endif.
  try.
      " Convert string to binary UTF8 data
      data utf8_converter type ref to cl_abap_conv_out_ce.
      data utf8_data type xstring.
      utf8_converter = cl_abap_conv_out_ce=>create( encoding = 'UTF-8' ).
      utf8_converter->write( data = data ).
      utf8_data = utf8_converter->get_buffer( ).
      " Add UTF8 charset to MIME type
      data utf8_mime_type type string.
      concatenate mime_type '; charset=utf-8' into utf8_mime_type. "#EC NOTEXT
      " Send
      me->send_binary( data = utf8_data mime_type = utf8_mime_type code = code ).
      me->commit( ).
    catch cx_sy_codepage_converter_init cx_sy_conversion_codepage cx_parameter_invalid_type cx_parameter_invalid_range.
      " Conversion error
      raise exception type cx_text_conversion_error.
  endtry.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->IF_RESPONSE~SEND_UNAUTHORIZED
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_response~send_unauthorized.
*/**
* Send unauthorized response to the client
*/
  me->send_error( code = cl_http_status_codes=>unauthorized message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_RESPONSE->COMMIT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method commit.
*/**
* Commits the response. This will prevent any further changes to the response object.
*/
  me->committed = abap_true.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_RESPONSE->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] RESPONSE                       TYPE REF TO IF_HTTP_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  me->response = response.
  " Enable full compression by default
  me->response->set_compression( me->response->co_compress_in_all_cases ).
endmethod.
ENDCLASS.
