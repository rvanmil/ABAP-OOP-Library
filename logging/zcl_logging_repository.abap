class ZCL_LOGGING_REPOSITORY definition
  public
  inheriting from ZCL_OBJECT
  final
  create private

  global friends ZCL_LOGGING_RESOURCE .

public section.

*"* public components of class zCL_LOGGING_REPOSITORY
*"* do not include other source files here!!!
  interfaces ZIF_LOGGING_REPOSITORY .

  aliases CREATE
    for ZIF_LOGGING_REPOSITORY~CREATE .
  aliases FIND_BY_ID
    for ZIF_LOGGING_REPOSITORY~FIND_BY_ID .
  aliases UPDATE
    for ZIF_LOGGING_REPOSITORY~UPDATE .
protected section.
*"* protected components of class zCL_LOGGING_REPOSITORY
*"* do not include other source files here!!!
private section.
*"* private components of class zCL_LOGGING_REPOSITORY
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_LOGGING_REPOSITORY IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGING_REPOSITORY->ZIF_LOGGING_REPOSITORY~CREATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOG_OBJECT                     TYPE        BALOBJ_D
* | [--->] LOG_SUBOBJECT                  TYPE        BALSUBOBJ
* | [<-()] RETURNING                      TYPE        BALOGNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_logging_repository~create.

  " Create new application log entry
  data wa_log_header type bal_s_log.
  data tp_log_handle type balloghndl.
  wa_log_header-object = log_object.
  wa_log_header-subobject = log_subobject.
  wa_log_header-aldate_del = sy-datum + 60. " Expire after 2 months
  wa_log_header-del_before = abap_true.

  concatenate sy-uname '_' sy-datum '_' sy-uzeit into wa_log_header-extnumber.
  call function 'BAL_LOG_CREATE'
    exporting
      i_s_log                 = wa_log_header
    importing
      e_log_handle            = tp_log_handle
    exceptions
      log_header_inconsistent = 1
      others                  = 2.
  if sy-subrc <> 0.
    " Error creating new application log entry
    return.
  endif.

  " Save the application log entry
  data ta_log_numbers type bal_t_lgnm.
  data ta_log_handles type bal_t_logh.
  insert tp_log_handle into table ta_log_handles.
  call function 'BAL_DB_SAVE'
    exporting
      i_t_log_handle   = ta_log_handles
    importing
      e_new_lognumbers = ta_log_numbers
    exceptions
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      others           = 4.
  if sy-subrc <> 0.
    " Error saving new application log entry
    return.
  endif.

  " Get the log number (always one handle, always one number)
  data wa_log_number type bal_s_lgnm.
  data tp_log_number type balognr.
  read table ta_log_numbers into wa_log_number index 1.
  tp_log_number = wa_log_number-lognumber.
  if tp_log_number is initial.
    " No log number was created
    return.
  endif.
  returning = tp_log_number.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGING_REPOSITORY->ZIF_LOGGING_REPOSITORY~FIND_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOG_NUMBER                     TYPE        BALOGNR
* | [<-()] RETURNING                      TYPE REF TO ZCL_LOGGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_logging_repository~find_by_id.
  data log_object type balobj_d.
  data log_subobject  type balsubobj.
  select single object subobject from balhdr into (log_object, log_subobject) where lognumber = log_number.
  if sy-subrc = 0.
    data logger type ref to zcl_logger.
    create object logger
      exporting
        log_object    = log_object
        log_subobject = log_subobject
        log_number    = log_number.
    returning = logger.
    return.
  endif.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGING_REPOSITORY->ZIF_LOGGING_REPOSITORY~UPDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOG_NUMBER                     TYPE        BALOGNR
* | [--->] LOG_MESSAGE                    TYPE        STRING
* | [--->] LOG_MESSAGE_TYPE               TYPE        SYMSGTY
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_logging_repository~update.

  " Read the application log entry from the database
  data ta_e_t_log_handle type bal_t_logh.
  data ta_bal_t_logn type bal_t_logn.
  insert log_number into table ta_bal_t_logn.
  call function 'BAL_DB_LOAD'
    exporting
      i_t_lognumber      = ta_bal_t_logn
    importing
      e_t_log_handle     = ta_e_t_log_handle
    exceptions
      no_logs_specified  = 1
      log_not_found      = 2
      log_already_loaded = 3
      others             = 4.
  if sy-subrc <> 0.
    " Unknown log requested
    return.
  endif.

  " Get the log handle (always one number, always one handle)
  data tp_handle type balloghndl.
  read table ta_e_t_log_handle into tp_handle index 1.
  if tp_handle is initial.
    " No handle available
    return.
  endif.

  " Add the message to the application log entry
  data tp_log_text(200) type c.
  tp_log_text = log_message.
  call function 'BAL_LOG_MSG_ADD_FREE_TEXT'
    exporting
      i_log_handle     = tp_handle
      i_msgty          = log_message_type
      i_text           = tp_log_text
    exceptions
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      others           = 4.
  if sy-subrc <> 0.
    " Could not add message to application log entry
    return.
  endif.

  " Save the application  log entry
  data log_handles type bal_t_logh.
  insert tp_handle into table log_handles.
  call function 'BAL_DB_SAVE'
    exporting
      i_t_log_handle   = log_handles
    exceptions
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      others           = 4.
  if sy-subrc <> 0.
    " Error saving new application log entry
    return.
  endif.

  returning = abap_true.

endmethod.
ENDCLASS.
