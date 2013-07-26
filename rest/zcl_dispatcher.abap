class ZCL_DISPATCHER definition
  public
  inheriting from ZCL_OBJECT
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
*"* protected components of class zCL_DISPATCHER
*"* do not include other source files here!!!
private section.

*"* private components of class zCL_DISPATCHER
*"* do not include other source files here!!!
  constants MAX_URI_LENGTH type I value 1000. "#EC NOTEXT

  methods _SERVICE
    importing
      !REQUEST type ref to ZCL_REQUEST
      !RESPONSE type ref to ZCL_RESPONSE
    raising
      ZCX_RESOURCE_EXCEPTION .
  methods _GET_MAPPED_RESOURCE
    importing
      !REQUEST type ref to ZCL_REQUEST
    returning
      value(RETURNING) type ref to ZCL_RESOURCE
    raising
      ZCX_URI_TOO_LONG .
  methods _LOG_REQUEST
    importing
      !RESOURCE type ref to ZCL_RESOURCE
      !REQUEST type ref to ZCL_REQUEST .
ENDCLASS.



CLASS ZCL_DISPATCHER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DISPATCHER->IF_HTTP_EXTENSION~HANDLE_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] SERVER                         TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_http_extension~handle_request.
*/**
* This method is called by the SAP ICF system on handler classes
* Wraps the SAP request and response objects and let's the SERVICE method handle them
*/

  " Wrap request and response
  data request type ref to zcl_request.
  data response type ref to zcl_response.
  create object request
    type
    zcl_request
    exporting
      request = server->request.
  create object response
    type
    zcl_response
    exporting
      response = server->response.

  " Handle request
  data e type ref to zcx_resource_exception.
  try.
      _service( request = request response = response ).
      return.
    catch zcx_resource_exception into e.
      response->send_internal_server_error( message = e->message ).
      return.
  endtry.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_DISPATCHER->_GET_MAPPED_RESOURCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO ZCL_REQUEST
* | [<-()] RETURNING                      TYPE REF TO ZCL_RESOURCE
* | [!CX!] ZCX_URI_TOO_LONG
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _get_mapped_resource.
*/**
* Finds the resource mapped to the request URI.
* A resource is linked to a resource path. This path is always the root path of the received request URI.
*
* Examples:
* - request URI:   /partners
* - resource path: /partners
*
* - request URI:   /partners/12
* - resource path: /partners
*
* - request URI:   /partners/12/address
* - resource path: /partners
*
* - request URI:   /partners/12/contactpersons?hasemailaddress=true
* - resource path: /partners
*
*/
  data uri type string.
  data uri_parts type standard table of string.
  data resource_path type string.
  data resource_id type string.
  data resource_record type zresources.
  data resource type ref to zcl_resource.

  " Get request URI
  uri = request->get_requesturi( ).
  if strlen( uri ) > max_uri_length. " Maximum supported URI length
    raise exception type zcx_uri_too_long.
  endif.
  " Get the path and resource id from the URI
  split uri at '/' into table uri_parts.
  read table uri_parts into resource_path index 2.
  read table uri_parts into resource_id index 3.
  " Resource paths are case insensitive, so they are stored in UPPER CASE
  translate resource_path to upper case.
  " Find the mapped resource
  select single * into resource_record from zresources where path = resource_path.
  if sy-subrc <> 0.
    return.
  endif.
  " Create the resource
  try.
      create object resource type (resource_record-class).
      resource->_name = resource_record-name.
      resource->_path = resource_record-path.
      resource->_id = resource_id.
    catch cx_sy_create_object_error.
      " Do nothing; this method returns null if no resource was found
      return.
  endtry.
  " Log the request, if required
  if resource_record-log_requests = abap_true.
    _log_request( resource = resource request = request ).
  endif.

  returning = resource.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_DISPATCHER->_LOG_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] RESOURCE                       TYPE REF TO ZCL_RESOURCE
* | [--->] REQUEST                        TYPE REF TO ZCL_REQUEST
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _log_request.
  data: raw type xstring,
        rawstr type string,
        utf8_converter type ref to cl_abap_conv_in_ce,
        restlog type zrestlog.

  raw = request->get_raw_message( ).
  utf8_converter = cl_abap_conv_in_ce=>create( encoding = 'UTF-8' ).
  call method utf8_converter->convert
    exporting
      input = raw
    importing
      data  = rawstr.

  get time.
  try.
      restlog-uuid = cl_system_uuid=>create_uuid_c32_static( ).
    catch cx_uuid_error.
      " Try to write without guid anyway
  endtry.
  restlog-requestdate = sy-datum.
  restlog-requesttime = sy-uzeit.
  restlog-requestuser = sy-uname.
  restlog-resourcepath = resource->path( ).
  restlog-resourcename = resource->name( ).
  restlog-resourceid = resource->id( ).
  restlog-request = rawstr.
  insert zrestlog from restlog.
  commit work.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_DISPATCHER->_SERVICE
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO ZCL_REQUEST
* | [--->] RESPONSE                       TYPE REF TO ZCL_RESPONSE
* | [!CX!] ZCX_RESOURCE_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _service.
*/**
* Dispatches the HTTP request to the corresponding resource.
* Returns the NOT_FOUND status code for unknown resources.
* Returns the NOT_IMPLEMENTED status code for methods which are not supported.
* Supported methods:
* - DELETE
* - GET
* - POST
* - PUT
* - HEAD
*/
  data message type string.
  data resource type ref to zcl_resource.
  data method type string.

  " Find the resource mapped to the request URI
  try.
      resource = _get_mapped_resource( request ).
    catch zcx_uri_too_long.
      " Too long URI
      message e004(zrest) into message.
      response->send_error( code = zcl_http_status_codes=>requesturi_too_large message = message ).
      return.
  endtry.
  if resource is not bound.
    " Unknown resource
    message e003(zrest) into message.
    response->send_not_found( message = message ).
    return.
  endif.
  " Dispatch request to the requested resource
  method = request->get_method( ).
  case method.
    when zcl_http_methods=>delete.
      resource->delete( request = request response = response ).
    when zcl_http_methods=>get.
      resource->read( request = request response = response ).
    when zcl_http_methods=>post.
      resource->create( request = request response = response ).
    when zcl_http_methods=>put.
      resource->update( request = request response = response ).
    when zcl_http_methods=>head.
      resource->head( request = request response = response ).
    when others.
      " Unsupported HTTP method
      message e002(zrest) into message.
      response->send_error( code = zcl_http_status_codes=>not_implemented message = message ).
      return.
  endcase.
endmethod.
ENDCLASS.
