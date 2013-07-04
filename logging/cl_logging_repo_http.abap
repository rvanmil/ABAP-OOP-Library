class CL_LOGGING_REPO_HTTP definition
  public
  inheriting from CL_OBJECT
  final
  create private

  global friends CL_LOGGER
                 CL_LOGGER_FACTORY .

public section.

*"* public components of class CL_LOGGING_REPO_HTTP
*"* do not include other source files here!!!
  interfaces IF_LOGGING_REPOSITORY .

  aliases CREATE
    for IF_LOGGING_REPOSITORY~CREATE .
  aliases FIND_BY_ID
    for IF_LOGGING_REPOSITORY~FIND_BY_ID .
  aliases UPDATE
    for IF_LOGGING_REPOSITORY~UPDATE .
protected section.
*"* protected components of class CL_LOGGING_REPO_HTTP
*"* do not include other source files here!!!
private section.

*"* private components of class CL_LOGGING_REPO_HTTP
*"* do not include other source files here!!!
  methods GET_CLIENT
    returning
      value(RETURNING) type ref to IF_HTTP_CLIENT .
  methods SEND_REQUEST
    importing
      !CLIENT type ref to IF_HTTP_CLIENT .
  methods CLOSE_REQUEST
    importing
      !CLIENT type ref to IF_HTTP_CLIENT .
ENDCLASS.



CLASS CL_LOGGING_REPO_HTTP IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_LOGGING_REPO_HTTP->IF_LOGGING_REPOSITORY~CREATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOG_OBJECT                     TYPE        BALOBJ_D
* | [--->] LOG_SUBOBJECT                  TYPE        BALSUBOBJ
* | [<-()] RETURNING                      TYPE        BALOGNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_logging_repository~create.
  " Create client
  data client type ref to if_http_client.
  client = me->get_client( ).
  " Construct request
  " - URI
  data uri type string.
  uri = '/log/'.
  client->request->set_header_field( name = '~request_uri' value = uri ).
  client->request->set_header_field( name = '~request_method' value = cl_http_methods=>post ).
  " - Body
  data tp_log_object type string.
  data tp_log_subobject type string.
  tp_log_object = log_object.
  tp_log_subobject = log_subobject.
  client->request->set_form_field( name = 'logobject' value = tp_log_object ). "#EC NOTEXT
  client->request->set_form_field( name = 'logsubobject' value = tp_log_subobject ). "#EC NOTEXT
  client->request->set_formfield_encoding( if_http_entity=>co_formfield_encoding_encoded ).
  " Send request
  me->send_request( client ).
  " Keep log number returned by response
  data tp_location type string.
  tp_location = client->response->if_http_entity~get_header_field( cl_http_header_fields=>location ).
  if tp_location is initial.
    raise exception type cx_logging_error.
  endif.
  " Close request
  me->close_request( client ).
  "  Return location (log number)
  returning = tp_location.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_LOGGING_REPO_HTTP->IF_LOGGING_REPOSITORY~FIND_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOG_NUMBER                     TYPE        BALOGNR
* | [<-()] RETURNING                      TYPE REF TO CL_LOGGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_logging_repository~find_by_id.
  " Create client
  data client type ref to if_http_client.
  client = me->get_client( ).
  " Construct request
  " - URI
  data uri type string.
  concatenate '/log/' log_number into uri.
  client->request->set_header_field( name = '~request_uri' value = uri ).
  client->request->set_header_field( name = '~request_method' value = cl_http_methods=>get ).
  " Send request
  me->send_request( client ).
  " Retrieve log details returned by response
  data log_as_string type string.
  log_as_string = client->response->get_cdata( ).
  if log_as_string is initial.
    raise exception type cx_logging_error.
  endif.
  data log_as_json type ref to cl_json_object.
  data json_parser type ref to cl_json_parser.
  create object json_parser.
  try.
      log_as_json ?= json_parser->deserialize( log_as_string ).
    catch cx_json_parse_error.
      raise exception type cx_logging_error.
  endtry.
  data log_object_json type ref to cl_json_pair.
  data log_subobject_json type ref to cl_json_pair.
  log_object_json = log_as_json->get( 0 ).
  log_subobject_json = log_as_json->get( 1 ).
  data log_object_json_string type ref to cl_json_string.
  data log_subobject_json_string type ref to cl_json_string.
  log_object_json_string ?= log_object_json->value.
  log_subobject_json_string ?= log_subobject_json->value.
  data log_object type balobj_d.
  data log_subobject type balsubobj.
  log_object = log_object_json_string->value.
  log_subobject = log_subobject_json_string->value.
  data logger type ref to cl_logger.
  create object logger
    exporting
      log_object    = log_object
      log_subobject = log_subobject
      log_number    = log_number.
  " Close request
  me->close_request( client ).
  " Return logger
  returning = logger.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_LOGGING_REPO_HTTP->IF_LOGGING_REPOSITORY~UPDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOG_NUMBER                     TYPE        BALOGNR
* | [--->] LOG_MESSAGE                    TYPE        STRING
* | [--->] LOG_MESSAGE_TYPE               TYPE        SYMSGTY
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_logging_repository~update.
  " Create client
  data client type ref to if_http_client.
  client = me->get_client( ).
  " Construct request
  " - URI
  data uri type string.
  concatenate '/log/' log_number into uri.
  client->request->set_header_field( name = '~request_uri' value = uri ).
  client->request->set_header_field( name = '~request_method' value = cl_http_methods=>put ).
  " - Body
  data tp_message type string.
  data tp_message_type type string.
  tp_message = log_message.
  tp_message_type = log_message_type.
  client->request->set_form_field( name = 'message' value = tp_message ). "#EC NOTEXT
  client->request->set_form_field( name = 'messagetype' value = tp_message_type ). "#EC NOTEXT
  client->request->set_formfield_encoding( if_http_entity=>co_formfield_encoding_encoded ).
  " Send request
  me->send_request( client ).
  " Close request
  me->close_request( client ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_LOGGING_REPO_HTTP->CLOSE_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO IF_HTTP_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method close_request.
  " Close connection
  call method client->close
    exceptions
      http_invalid_state = 1
      others             = 2.
  if sy-subrc <> 0.
    raise exception type cx_logging_error.
  endif.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_LOGGING_REPO_HTTP->GET_CLIENT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO IF_HTTP_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_client.
  " Create client
  data client type ref to if_http_client.
  call method cl_http_client=>create_by_destination
    exporting
      destination              = 'LOG_LOCALHOST'
    importing
      client                   = client
    exceptions
      argument_not_found       = 1
      destination_not_found    = 2
      destination_no_authority = 3
      plugin_not_active        = 4
      internal_error           = 5
      others                   = 6.
  if sy-subrc <> 0.
    raise exception type cx_logging_error.
  endif.
  returning = client.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_LOGGING_REPO_HTTP->SEND_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO IF_HTTP_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method send_request.
  " Send request
  call method client->send
    exceptions
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      http_invalid_timeout       = 4
      others                     = 5.
  if sy-subrc <> 0.
    me->close_request( client ).
    raise exception type cx_logging_error.
  endif.
  " Receive response
  call method client->receive
    exceptions
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      others                     = 4.
  if sy-subrc <> 0.
    me->close_request( client ).
    raise exception type cx_logging_error.
  endif.
  " Read response
  data tp_status_code type i.
  client->response->get_status( importing code = tp_status_code ).
  if tp_status_code <> cl_http_status_codes=>ok and tp_status_code <> cl_http_status_codes=>created.
    me->close_request( client ).
    raise exception type cx_logging_error.
  endif.
endmethod.
ENDCLASS.
