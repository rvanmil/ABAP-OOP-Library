class ZCL_RESOURCE definition
  public
  inheriting from ZCL_OBJECT
  abstract
  create public

  global friends ZCL_DISPATCHER .

public section.

*"* public components of class zCL_RESOURCE
*"* do not include other source files here!!!
  methods CREATE
    importing
      !REQUEST type ref to ZIF_REQUEST
      !RESPONSE type ref to ZIF_RESPONSE .
  methods READ
    importing
      !REQUEST type ref to ZIF_REQUEST
      !RESPONSE type ref to ZIF_RESPONSE .
  methods UPDATE
    importing
      !REQUEST type ref to ZIF_REQUEST
      !RESPONSE type ref to ZIF_RESPONSE .
  methods DELETE
    importing
      !REQUEST type ref to ZIF_REQUEST
      !RESPONSE type ref to ZIF_RESPONSE .
  methods HEAD
    importing
      !REQUEST type ref to ZIF_REQUEST
      !RESPONSE type ref to ZIF_RESPONSE .
  methods NAME
    returning
      value(RETURNING) type ZRESOURCENAME .
  methods PATH
    returning
      value(RETURNING) type ZRESOURCEPATH .
  methods ID
    returning
      value(RETURNING) type STRING .
protected section.
*"* protected components of class zCL_RESOURCE
*"* do not include other source files here!!!
private section.

  data _NAME type ZRESOURCENAME .
  data _PATH type ZRESOURCEPATH .
  data _ID type STRING .
ENDCLASS.



CLASS ZCL_RESOURCE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESOURCE->CREATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO ZIF_REQUEST
* | [--->] RESPONSE                       TYPE REF TO ZIF_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method create.
*/**
* Handle the POST method:
* - parses the HTTP body and instantiates a new resource
* - creates the new resource using the repository
*
* Method specification:
* - SAFE: no
* - IDEMPOTENT: no
*
* Common responses:
* - 200 with the created resource as HTTP body
* - 201 without HTTP body, with Location header referring to the created resource
* - 204 without HTTP body, same as 200 but the created resource is not returned
*/
  " Method not allowed unless overridden by subclass
  data message type string.
  message e005(rest) into message.
  response->send_error( code = zcl_http_status_codes=>method_not_allowed message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESOURCE->DELETE
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO ZIF_REQUEST
* | [--->] RESPONSE                       TYPE REF TO ZIF_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method delete.
*/**
* Handle the DELETE method:
* - deletes the referred resource
*
* Method specification:
* - SAFE: no
* - IDEMPOTENT: yes
*
* Common responses:
* - 200 with the deleted resource as HTTP body
* - 202 without HTTP body, used for asynchronous processing
* - 204 without HTTP body, same as 200 but the deleted resource is not returned
*/
  " Method not allowed unless overridden by subclass
  data message type string.
  message e005(rest) into message.
  response->send_error( code = zcl_http_status_codes=>method_not_allowed message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESOURCE->HEAD
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO ZIF_REQUEST
* | [--->] RESPONSE                       TYPE REF TO ZIF_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method head.
*/**
* Handle the HEAD method:
* - exactly the same as the GET method, but ONLY returns the headers
*
* Method specification:
* - SAFE: yes
* - IDEMPOTENT: yes
*
* Common responses:
* - 200 without HTTP body
* - 404 without HTTP body, if the requested resource was not found
*/
  " Method not allowed unless overridden by subclass
  data message type string.
  message e005(rest) into message.
  response->send_error( code = zcl_http_status_codes=>method_not_allowed message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESOURCE->ID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method id.
  returning = _id.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESOURCE->NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        ZRESOURCENAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
method name.
  returning = _name.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESOURCE->PATH
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        ZRESOURCEPATH
* +--------------------------------------------------------------------------------------</SIGNATURE>
method path.
  returning = _path.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESOURCE->READ
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO ZIF_REQUEST
* | [--->] RESPONSE                       TYPE REF TO ZIF_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method read.
*/**
* Handle the GET method:
* - retrieves the referred resource from the repository
* - formats the resource into the requested representation and
* - returns the representation as the HTTP body using either the SEND_BINARY or SEND_TEXT methods of the response
*
* Method specification:
* - SAFE: yes
* - IDEMPOTENT: yes
*
* Common responses:
* - 200 with the requested resource as HTTP body
* - 404 without HTTP body, if the requested resource was not found
*/
  " Method not allowed unless overridden by subclass
  data message type string.
  message e005(rest) into message.
  response->send_error( code = zcl_http_status_codes=>method_not_allowed message = message ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RESOURCE->UPDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO ZIF_REQUEST
* | [--->] RESPONSE                       TYPE REF TO ZIF_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method update.
*/**
* Handle the PUT method:
* - this method updates an existing resource, or creates a new resource if the referred resource does not exist yet
* - retrieves the referred resource from the repository
* - parses the HTTP body and instantiates a new resource
* - creates a new, or replaces the existing resource with the new resource
*
* Method specification:
* - SAFE: no
* - IDEMPOTENT: yes
*
* Common responses:
* - 200 with the updated resource as HTTP body
* - 201 without HTTP body, with Location header referring to the updated resource
* - 204 without HTTP body, same as 200 but the updated resource is not returned
*/
  " Method not allowed unless overridden by subclass
  data message type string.
  message e005(rest) into message.
  response->send_error( code = zcl_http_status_codes=>method_not_allowed message = message ).
endmethod.
ENDCLASS.
