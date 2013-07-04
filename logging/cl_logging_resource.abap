class CL_LOGGING_RESOURCE definition
  public
  inheriting from CL_RESOURCE
  final
  create public .

public section.

*"* public components of class CL_LOGGING_RESOURCE
*"* do not include other source files here!!!
  methods CONSTRUCTOR .

  methods IF_RESOURCE~CREATE
    redefinition .
  methods IF_RESOURCE~READ
    redefinition .
  methods IF_RESOURCE~UPDATE
    redefinition .
protected section.
*"* protected components of class CL_LOGGING_RESOURCE
*"* do not include other source files here!!!
private section.

*"* private components of class CL_LOGGING_RESOURCE
*"* do not include other source files here!!!
  data LOGGING_REPOSITORY type ref to CL_LOGGING_REPOSITORY .

  methods PARSE_URI
    importing
      !URI type STRING
    returning
      value(RETURNING) type BALOGNR .
ENDCLASS.



CLASS CL_LOGGING_RESOURCE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_LOGGING_RESOURCE->IF_RESOURCE~CREATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO IF_REQUEST
* | [--->] RESPONSE                       TYPE REF TO IF_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_resource~create.
*/**
*
* Creates a new application log entry and returns the log number
*
*/

  data msg type string.

  " Read application log object and subobject strings from HTTP request
  data tp_log_object type balobj_d.
  data tp_log_subobject type balsubobj.
  tp_log_object = request->get_parameter( 'logobject' ).    "#EC NOTEXT
  if tp_log_object is initial.
    " No log object specified
    message e004(log) into msg.
    response->send_error( code = cl_http_status_codes=>bad_request message = msg ).
    return.
  endif.
  tp_log_subobject = request->get_parameter( 'logsubobject' ). "#EC NOTEXT
  if tp_log_subobject is initial.
    " No log subobject specified
    message e005(log) into msg.
    response->send_error( code = cl_http_status_codes=>bad_request message = msg ).
    return.
  endif.
  " Create new application log entry
  data tp_log_number type balognr.
  tp_log_number = me->logging_repository->create( log_object = tp_log_object log_subobject = tp_log_subobject ).
  if tp_log_number is initial.
    " No log number was created
    message e008(log) into msg.
    response->send_error( code = cl_http_status_codes=>internal_server_error message = msg ).
    return.
  endif.
  " Return the created log number
  data tp_location type string.
  tp_location = tp_log_number.
  response->send_created( tp_location ).
  return.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_LOGGING_RESOURCE->IF_RESOURCE~READ
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO IF_REQUEST
* | [--->] RESPONSE                       TYPE REF TO IF_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_resource~read.
*/**
*
* Return the details of an existing application log entry
* Does not return any messages contained in the entry
*
*/

  data msg type string.

  " Retrieve log number from the URI
  data uri type string.
  data balognr type balognr.
  uri = request->get_requesturi( ).
  balognr = me->parse_uri( uri ).
  if balognr is initial.
    " No log number specified
    message e007(log) into msg.
    response->send_error( code = cl_http_status_codes=>bad_request message = msg ).
    return.
  endif.

  " Get the log entry
  data logger type ref to cl_logger.
  logger = me->logging_repository->find_by_id( balognr ).
  if logger is not bound.
    " Log entry not found
    message e002(log) into msg.
    response->send_error( code = cl_http_status_codes=>not_found message = msg ).
    return.
  endif.

  " Return log entry details in JSON format
  data log_object_str type string.
  data log_subobject_str type string.
  log_object_str = logger->get_object( ).
  log_subobject_str = logger->get_subobject( ).
  data log_object_json type ref to cl_json_pair.
  data log_subobject_json type ref to cl_json_pair.
  data log_as_json type ref to cl_json_object.
  log_object_json = cl_json_util=>new_pair_with_string( name = 'object' value = log_object_str ).
  log_subobject_json = cl_json_util=>new_pair_with_string( name = 'subobject' value = log_subobject_str ).
  create object log_as_json.
  log_as_json->add( log_object_json ).
  log_as_json->add( log_subobject_json ).
  data log_as_string type string.
  data json_parser type ref to cl_json_parser.
  create object json_parser.
  log_as_string = json_parser->serialize( log_as_json ).
  response->send_text( data = log_as_string mime_type = cl_http_mime_types=>text_plain code = cl_http_status_codes=>ok ).
  return.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_LOGGING_RESOURCE->IF_RESOURCE~UPDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] REQUEST                        TYPE REF TO IF_REQUEST
* | [--->] RESPONSE                       TYPE REF TO IF_RESPONSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_resource~update.
*/**
*
* Adds a message to an existing application log entry
*
*/

  data msg type string.

  " Retrieve log number from the URI
  data uri type string.
  data tp_balognr type balognr.
  uri = request->get_requesturi( ).
  tp_balognr = me->parse_uri( uri ).
  if tp_balognr is initial.
    " No log number specified
    message e007(log) into msg.
    response->send_error( code = cl_http_status_codes=>bad_request message = msg ).
    return.
  endif.

  " Read application log type and message from HTTP request
  data tp_message type string.
  data tp_message_type type symsgty.
  tp_message = request->get_parameter( 'message' ).         "#EC NOTEXT
  if tp_message is initial.
    " No message specified
    message e010(log) into msg.
    response->send_error( code = cl_http_status_codes=>bad_request message = msg ).
    return.
  endif.
  tp_message_type = request->get_parameter( 'messagetype' ). "#EC NOTEXT
  if tp_message_type is initial.
    " No message type specified
    message e011(log) into msg.
    response->send_error( code = cl_http_status_codes=>bad_request message = msg ).
    return.
  endif.
  " Add message
  data tp_ok type abap_bool.
  tp_ok = me->logging_repository->update( log_number = tp_balognr log_message = tp_message log_message_type = tp_message_type ).
  if tp_ok = abap_true.
    " Return OK
    response->send_ok( ).
    return.
  else.
    message e012(log) into msg.
    response->send_error( code = cl_http_status_codes=>bad_request message = msg ).
    return.
  endif.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_LOGGING_RESOURCE->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  create object me->logging_repository.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_LOGGING_RESOURCE->PARSE_URI
* +-------------------------------------------------------------------------------------------------+
* | [--->] URI                            TYPE        STRING
* | [<-()] RETURNING                      TYPE        BALOGNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method parse_uri.
*/**
* Parses the URI using a regular expression
* The URI is expected to have the following possible formats:
*
* /log
* /log/number
*
*/

  " In order to keep this compatible with older systems, the CL_ABAP_MATCHER class is no longer used here.
*  DATA matcher TYPE REF TO cl_abap_matcher.
*  matcher = cl_abap_matcher=>create( pattern = '^/log/(.{1,20})' text = uri ).
*  IF matcher IS BOUND.
*    IF matcher->match( ) = abap_true.
*      tp_balognr = matcher->get_submatch( 1 ).
*    ENDIF.
*  ENDIF.
  data ta_values type standard table of string.
  split uri at '/' into table ta_values.
  data tp_balognr type balognr.
  " In case the log number was specified, it will be at index position 3 (since the '/' will occur twice in this case)
  read table ta_values into tp_balognr index 3.
  returning = tp_balognr.
endmethod.
ENDCLASS.
