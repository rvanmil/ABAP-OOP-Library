class ZCL_RESPONSE definition
  public
  inheriting from ZCL_OBJECT
  final
  create public .

public section.

  data RESPONSE type ref to IF_HTTP_RESPONSE .

  methods CONSTRUCTOR
    importing
      !RESPONSE type ref to IF_HTTP_RESPONSE .
  methods ADD_HEADER
    importing
      !NAME type STRING
      !VALUE type STRING .
  methods EXPIRES_AFTER
    importing
      !SECONDS type I .
  methods EXPIRES_AT
    importing
      !DATE type D
      !TIME type T .
  methods REDIRECT
    importing
      !URL type STRING
      !PERMANENTLY type I default 0
      !EXPLANATION type STRING default ''
      !PROTOCOL_DEPENDENT type I default 0 .
  methods SEND_ACCEPTED
    importing
      !LOCATION type STRING optional .
  methods SEND_BAD_REQUEST
    importing
      !MESSAGE type STRING optional .
  methods SEND_BINARY
    importing
      !DATA type XSTRING
      !MIME_TYPE type STRING default 'application/octet-stream' "#EC NOTEXT
      !CODE type I default 200 .
  methods SEND_CREATED
    importing
      !LOCATION type STRING optional .
  methods SEND_ERROR
    importing
      !CODE type I
      !MESSAGE type STRING optional .
  methods SEND_INTERNAL_SERVER_ERROR
    importing
      !MESSAGE type STRING optional .
  methods SEND_JSON
    importing
      !JSON_VALUE type ref to ZIF_JSON_VALUE .
  methods SEND_NOT_FOUND
    importing
      !MESSAGE type STRING optional .
  methods SEND_OK .
  methods SEND_TEXT
    importing
      !DATA type STRING
      !MIME_TYPE type STRING default 'text/plain' "#EC NOTEXT
      !CODE type I default 200 .
  methods SEND_UNAUTHORIZED
    importing
      !MESSAGE type STRING optional .
protected section.
*"* protected components of class zCL_RESPONSE
*"* do not include other source files here!!!
private section.
ENDCLASS.



CLASS ZCL_RESPONSE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->ADD_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method add_header.
*/**
* Add header parameter to the HTTP response
*/
  me->response->set_header_field( name = name value = value ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] RESPONSE                       TYPE REF TO IF_HTTP_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method CONSTRUCTOR.
  super->constructor( ).
  me->response = response.
  " Enable full compression by default
  me->response->set_compression( me->response->co_compress_in_all_cases ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->EXPIRES_AFTER
* +-------------------------------------------------------------------------------------------------+
* | [--->] SECONDS                        TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method expires_after.
  me->response->server_cache_expire_rel( seconds ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->EXPIRES_AT
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [--->] TIME                           TYPE        T
* +--------------------------------------------------------------------------------------</SIGNATURE>
method expires_at.
  me->response->server_cache_expire_abs( expires_abs_date = date expires_abs_time = time ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->REDIRECT
* +-------------------------------------------------------------------------------------------------+
* | [--->] URL                            TYPE        STRING
* | [--->] PERMANENTLY                    TYPE        I (default =0)
* | [--->] EXPLANATION                    TYPE        STRING (default ='')
* | [--->] PROTOCOL_DEPENDENT             TYPE        I (default =0)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method redirect.
  me->response->redirect( url = url permanently = permanently explanation = explanation protocol_dependent = protocol_dependent ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_ACCEPTED
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOCATION                       TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_accepted.
*/**
* Send a response to the client with the ACCEPTED status code and the Location header
*/
  me->add_header( name = zcl_http_header_fields=>location value = location ).
  me->response->set_status( code = zcl_http_status_codes=>accepted reason = '' ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_BAD_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_bad_request.
*/**
* Send bad request response to the client
*/
  me->send_error( code = zcl_http_status_codes=>bad_request message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_BINARY
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA                           TYPE        XSTRING
* | [--->] MIME_TYPE                      TYPE        STRING (default ='application/octet-stream')
* | [--->] CODE                           TYPE        I (default =200)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_binary.
*/**
* Send a response to the client with binary data in the HTTP body
*/
  me->response->set_content_type( mime_type ).
  me->response->set_data( data ).
  me->response->set_status( code = code reason = '' ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_CREATED
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOCATION                       TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_created.
*/**
* Send a response to the client with the CREATED status code and the Location header
*/
  me->add_header( name = zcl_http_header_fields=>location value = location ).
  me->response->set_status( code = zcl_http_status_codes=>created reason = '' ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] CODE                           TYPE        I
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_error.
*/**
* Send a response to the client with a specified status code and message
*/
  me->response->set_status( code = code reason = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_INTERNAL_SERVER_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_internal_server_error.
*/**
* Send internal server error response to the client
*/
  me->send_error( code = zcl_http_status_codes=>internal_server_error message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] JSON_VALUE                     TYPE REF TO ZIF_JSON_VALUE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_json.
*/**
* Send a response to the client with a JSON string as the HTTP body
*/
  data: json_parser type ref to zcl_json_parser,
        json_string type string.
  create object json_parser.
  json_string = json_parser->serialize( json_value ).
  me->send_text( data = json_string mime_type = zcl_http_mime_types=>application_json ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_NOT_FOUND
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_not_found.
*/**
* Send not found response to the client
*/
  me->send_error( code = zcl_http_status_codes=>not_found message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_OK
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_ok.
*/**
* Send HTTP status code OK to the client
*/
  me->response->set_status( code = zcl_http_status_codes=>ok reason = '' ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA                           TYPE        STRING
* | [--->] MIME_TYPE                      TYPE        STRING (default ='text/plain')
* | [--->] CODE                           TYPE        I (default =200)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_text.
*/**
* Send a response to the client with a string as the HTTP body
* The string is converted to binary UTF-8 encoded data and eventually sent using the SEND_BINARY method
*/
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
    catch cx_sy_codepage_converter_init cx_sy_conversion_codepage cx_parameter_invalid_type cx_parameter_invalid_range.
      " Conversion error
      raise exception type zcx_text_conversion_error.
  endtry.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESPONSE->SEND_UNAUTHORIZED
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_unauthorized.
*/**
* Send unauthorized response to the client
*/
  me->send_error( code = zcl_http_status_codes=>unauthorized message = message ).
endmethod.
ENDCLASS.
