class /OOD/CL_LOG_VIEWER definition
  public
  inheriting from /OOD/CL_OBJECT
  final
  create public .

public section.
*"* public components of class /OOD/CL_LOG_VIEWER
*"* do not include other source files here!!!

  data DISPLAY_PROFILE type BAL_S_PROF .

  methods CONSTRUCTOR .
  methods DISPLAY
    importing
      !LOGGER type ref to /OOD/CL_LOGGER .
  methods DISPLAY_LIST
    importing
      !LOGGER_LIST type ref to /OOD/IF_LIST .
  methods SET_DISPLAY_PROFILE
    importing
      !DISPLAY_PROFILE type BAL_S_PROF .
  methods SET_DISPLAY_DEFAULT .
  methods SET_DISPLAY_POPUP .
  methods SET_DISPLAY_NO_TREE .
protected section.
*"* protected components of class /OOD/CL_LOG_VIEWER
*"* do not include other source files here!!!
private section.
*"* private components of class /OOD/CL_LOG_VIEWER
*"* do not include other source files here!!!

  methods _GET_HANDLES
    importing
      !LOGGER type ref to /OOD/CL_LOGGER
    returning
      value(RETURNING) type BAL_T_LOGH .
  methods _DISPLAY_WITH_HANDLES
    importing
      !HANDLES type BAL_T_LOGH .
ENDCLASS.



CLASS /OOD/CL_LOG_VIEWER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /OOD/CL_LOG_VIEWER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).

  " Init display profile
  set_display_default( ).

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /OOD/CL_LOG_VIEWER->DISPLAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOGGER                         TYPE REF TO /OOD/CL_LOGGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
method display.
  data: handles type bal_t_logh.

  handles = _get_handles( logger ).

  if handles is not initial.
    _display_with_handles( handles ).
  endif.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /OOD/CL_LOG_VIEWER->DISPLAY_LIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOGGER_LIST                    TYPE REF TO /OOD/IF_LIST
* +--------------------------------------------------------------------------------------</SIGNATURE>
method display_list.
  data: logger_list_iterator type ref to /ood/if_iterator,
        logger type ref to /ood/cl_logger,
        handles type bal_t_logh,
        handles_list type bal_t_logh.

  logger_list_iterator = logger_list->iterator( ).
  while logger_list_iterator->hasnext( ) = abap_true.
    logger ?= logger_list_iterator->next( ).
    handles = _get_handles( logger ).
    insert lines of handles into table handles_list.
  endwhile.

  if handles_list is not initial.
    _display_with_handles( handles_list ).
  endif.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /OOD/CL_LOG_VIEWER->SET_DISPLAY_DEFAULT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method set_display_default.
  call function 'BAL_DSP_PROFILE_STANDARD_GET'
    importing
      e_s_display_profile = me->display_profile.
  me->display_profile-exp_level = '2'.
  me->display_profile-show_all = 'X'.	  
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /OOD/CL_LOG_VIEWER->SET_DISPLAY_NO_TREE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method set_display_no_tree.
  call function 'BAL_DSP_PROFILE_NO_TREE_GET'
    importing
      e_s_display_profile = me->display_profile.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /OOD/CL_LOG_VIEWER->SET_DISPLAY_POPUP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method set_display_popup.
  call function 'BAL_DSP_PROFILE_POPUP_GET'
    importing
      e_s_display_profile = me->display_profile.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method /OOD/CL_LOG_VIEWER->SET_DISPLAY_PROFILE
* +-------------------------------------------------------------------------------------------------+
* | [--->] DISPLAY_PROFILE                TYPE        BAL_S_PROF
* +--------------------------------------------------------------------------------------</SIGNATURE>
method set_display_profile.
  if display_profile is not initial.
    me->display_profile = display_profile.
  endif.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method /OOD/CL_LOG_VIEWER->_DISPLAY_WITH_HANDLES
* +-------------------------------------------------------------------------------------------------+
* | [--->] HANDLES                        TYPE        BAL_T_LOGH
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _display_with_handles.
  data: handle type balloghndl.

  " Display log
  call function 'BAL_DSP_LOG_DISPLAY'
    exporting
      i_s_display_profile  = display_profile
      i_t_log_handle       = handles
    exceptions
      profile_inconsistent = 1
      internal_error       = 2
      no_data_available    = 3
      no_authority         = 4
      others               = 5.
  if sy-subrc <> 0.
    return.
  endif.

  " Clear memory after displaying
  loop at handles into handle.
    call function 'BAL_LOG_REFRESH'
      exporting
        i_log_handle  = handle
      exceptions
        log_not_found = 1
        others        = 2.
    if sy-subrc <> 0.
      continue.
    endif.
  endloop.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method /OOD/CL_LOG_VIEWER->_GET_HANDLES
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOGGER                         TYPE REF TO /OOD/CL_LOGGER
* | [<-()] RETURNING                      TYPE        BAL_T_LOGH
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _GET_HANDLES.
  data: log_number type balognr,
        i_t_lognumber type bal_t_logn,
        e_t_log_handle type bal_t_logh.

  log_number = logger->get_log_number( ).
  if log_number is not initial.
    insert log_number into table i_t_lognumber.
    call function 'BAL_DB_LOAD'
      exporting
        i_t_lognumber      = i_t_lognumber
      importing
        e_t_log_handle     = e_t_log_handle
      exceptions
        no_logs_specified  = 1
        log_not_found      = 2
        log_already_loaded = 3
        others             = 4.
    if sy-subrc <> 0.
      return.
    endif.
    returning = e_t_log_handle.
  endif.
endmethod.
ENDCLASS.