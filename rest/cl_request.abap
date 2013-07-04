class CL_REQUEST definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_REQUEST
*"* do not include other source files here!!!
  interfaces IF_REQUEST .

  aliases GET_BODY_BINARY
    for IF_REQUEST~GET_BODY_BINARY .
  aliases GET_BODY_TEXT
    for IF_REQUEST~GET_BODY_TEXT .
  aliases GET_CONTENT_TYPE
    for IF_REQUEST~GET_CONTENT_TYPE .
  aliases GET_HEADER
    for IF_REQUEST~GET_HEADER .
  aliases GET_METHOD
    for IF_REQUEST~GET_METHOD .
  aliases GET_PARAMETER
    for IF_REQUEST~GET_PARAMETER .
  aliases GET_RAW_MESSAGE
    for IF_REQUEST~GET_RAW_MESSAGE .
  aliases GET_REQUESTURI
    for IF_REQUEST~GET_REQUESTURI .
  aliases LIST_HEADERS
    for IF_REQUEST~LIST_HEADERS .
  aliases LIST_PARAMETERS
    for IF_REQUEST~LIST_PARAMETERS .

  methods CONSTRUCTOR
    importing
      !REQUEST type ref to IF_HTTP_REQUEST .
protected section.
*"* protected components of class CL_REQUEST
*"* do not include other source files here!!!
private section.

*"* private components of class CL_REQUEST
*"* do not include other source files here!!!
  data REQUEST type ref to IF_HTTP_REQUEST .
ENDCLASS.



CLASS CL_REQUEST IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->IF_REQUEST~GET_BODY_BINARY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~get_body_binary.
*/**
* Retrieves the body of the request as binary data.
*/
  returning = me->request->get_data( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->IF_REQUEST~GET_BODY_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~get_body_text.
*/**
* Retrieves the body of the request as a string.
*/
  returning = me->request->get_cdata( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->IF_REQUEST~GET_CONTENT_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~get_content_type.
*/**
* Returns the MIME type of the body of the request, or null if the type is not known.
*/
  returning = me->request->get_content_type( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->IF_REQUEST~GET_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~get_header.
*/**
* Returns the value of the specified request header
* as a string. If the request did not include a header
* of the specified name, this method returns null.
*/
  returning = me->request->get_header_field( name ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->IF_REQUEST~GET_METHOD
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~get_method.
*/**
* Returns the name of the HTTP method with which this request was made,
* for example, GET, POST, or PUT.
*/
  returning = me->request->if_http_entity~get_header_field( '~request_method' ).
  " returning = me->request->get_method( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->IF_REQUEST~GET_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~get_parameter.
*/**
* Returns the value of a request parameter as a String,
* or null if the parameter does not exist.
* Request parameters are extra information sent with the request.
*/
  returning = me->request->get_form_field_cs( name ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->IF_REQUEST~GET_RAW_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~get_raw_message.
  returning = me->request->get_raw_message( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->IF_REQUEST~GET_REQUESTURI
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~get_requesturi.
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
* | Instance Public Method CL_REQUEST->IF_REQUEST~LIST_HEADERS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        TIHTTPNVP
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~list_headers.
*/**
* Returns all request headers
*/
  me->request->get_header_fields( changing fields = returning ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->IF_REQUEST~LIST_PARAMETERS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        TIHTTPNVP
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_request~list_parameters.
*/**
* Returns all request parameters
*/
  me->request->get_form_fields_cs( changing fields = returning ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_REQUEST->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO IF_HTTP_REQUEST
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  me->request = request.
endmethod.
ENDCLASS.
