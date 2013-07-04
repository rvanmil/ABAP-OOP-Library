class CL_DISPATCHER definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_DISPATCHER
*"* do not include other source files here!!!
  interfaces IF_DISPATCHER .
  interfaces IF_HTTP_EXTENSION .
protected section.
*"* protected components of class CL_DISPATCHER
*"* do not include other source files here!!!
private section.

*"* private components of class CL_DISPATCHER
*"* do not include other source files here!!!
  constants MAX_URI_LENGTH type I value 1000. "#EC NOTEXT

  methods _SERVICE
    importing
      !REQUEST type ref to IF_REQUEST
      !RESPONSE type ref to IF_RESPONSE
    raising
      CX_RESOURCE_EXCEPTION .
  methods _GET_MAPPED_RESOURCE
    importing
      !REQUEST type ref to IF_REQUEST
    returning
      value(RETURNING) type ref to IF_RESOURCE
    raising
      CX_URI_TOO_LONG .
ENDCLASS.



CLASS CL_DISPATCHER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_DISPATCHER->IF_HTTP_EXTENSION~HANDLE_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] SERVER                         TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_http_extension~handle_request.
*/**
* This method is called by the SAP ICF system on handler classes
* Wraps the SAP request and response objects and let's the SERVICE method handle them
*/

  " Wrap request and response
  data request type ref to if_request.
  data response type ref to if_response.
  create object request
    type
    cl_request
    exporting
      request = server->request.
  create object response
    type
    cl_response
    exporting
      response = server->response.

  " Handle request
  data e type ref to cx_resource_exception.
  try.
      _service( request = request response = response ).
      return.
    catch cx_resource_exception into e.
      response->send_internal_server_error( message = e->message ).
      return.
  endtry.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_DISPATCHER->_GET_MAPPED_RESOURCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO IF_REQUEST
* | [<-()] RETURNING                      TYPE REF TO IF_RESOURCE
* | [!CX!] CX_URI_TOO_LONG
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _get_mapped_resource.
*/**
* Finds the resource mapped to the request URI.
* The resource is mapped using a URI pattern. When matching a request URI to a URI pattern, the following rules apply:
* 1. an exact path match is preferred over a wildcard path match
* 2. the longest pattern is preferred over shorter patterns
*
* Examples:
* - request URI: /partners/12/address
* - patterns:    /partners
*                /partners/*
*                /partners/*/address
* - result:      second and third match; the third pattern is chosen
*
* - request URI: /partners
* - patterns:    /partners
*                /partners/*
*                /partners/*/address
* - result:      all match; the first pattern is chosen
*/
  " Get request URI
  data uri type string.
  uri = request->get_requesturi( ).
  if strlen( uri ) > max_uri_length. " Maximum supported URI length
    raise exception type cx_uri_too_long.
  endif.
  translate uri to upper case.
  " Match URI to a URI pattern and its mapped resource
  " - Get all resources
  data th_resources type hashed table of resources with unique key resourceid.
  select * from resources into table th_resources.
  if sy-subrc <> 0.
    return.
  endif.
  " - Find matching resources
  data th_matching_resources type hashed table of resources with unique key resourceid.
  field-symbols <resource> type resources.
  loop at th_resources assigning <resource>.
    if <resource>-uripattern is not initial. " Ignore empty patterns
      if uri cp <resource>-uripattern.
        insert <resource> into table th_matching_resources.
      endif.
    endif.
  endloop.
  " - Choose the best pattern
  data selected_resource type resources.
  " -- Look for an exact match first
  field-symbols <matching_resource> type resources.
  loop at th_matching_resources assigning <matching_resource>.
    if uri = <matching_resource>-uripattern.
      selected_resource = <matching_resource>.
      exit.
    endif.
  endloop.
  if selected_resource is initial.
    " -- If no exact match was found, choose the longest matching pattern
    data matching_pattern_length type i.
    loop at th_matching_resources assigning <matching_resource>.
      if strlen( <matching_resource>-uripattern ) > matching_pattern_length.
        selected_resource = <matching_resource>.
      endif.
      matching_pattern_length = strlen( <matching_resource>-uripattern ).
    endloop.
  endif.

  " Get the resource mapped to the chosen pattern and return it
  if selected_resource is not initial.
    data resource type ref to cl_resource.
    try.
        create object resource type (selected_resource-resourceclass).
        resource->_id = selected_resource-resourceid.
        resource->_uripattern = selected_resource-uripattern.
      catch cx_sy_create_object_error.
        " Do nothing; this method returns null if no resource was found
        return.
    endtry.
  endif.
  returning = resource.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_DISPATCHER->_SERVICE
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO IF_REQUEST
* | [--->] RESPONSE                       TYPE REF TO IF_RESPONSE
* | [!CX!] CX_RESOURCE_EXCEPTION
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
  data message type string. " Used for error messages
  " Find the resource mapped to the request URI
  data resource type ref to if_resource.
  try.
      resource = _get_mapped_resource( request ).
    catch cx_uri_too_long.
      " Too long URI
      message e004(rest) into message.
      response->send_error( code = cl_http_status_codes=>requesturi_too_large message = message ).
      return.
  endtry.
  if resource is not bound.
    " Unknown resource
    message e003(rest) into message.
    response->send_not_found( message = message ).
    return.
  endif.
  " Dispatch request to the requested resource
  data method type string.
  method = request->get_method( ).
  case method.
    when cl_http_methods=>delete.
      resource->delete( request = request response = response ).
    when cl_http_methods=>get.
      resource->read( request = request response = response ).
    when cl_http_methods=>post.
      resource->create( request = request response = response ).
    when cl_http_methods=>put.
      resource->update( request = request response = response ).
    when cl_http_methods=>head.
      resource->head( request = request response = response ).
    when others.
      " Unsupported HTTP method
      message e002(rest) into message.
      response->send_error( code = cl_http_status_codes=>not_implemented message = message ).
      return.
  endcase.
endmethod.
ENDCLASS.
