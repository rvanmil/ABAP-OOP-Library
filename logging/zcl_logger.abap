class ZCL_LOGGER definition
  public
  inheriting from ZCL_OBJECT
  final
  create private

  global friends ZCL_LOGGER_FACTORY
                 ZIF_LOGGING_REPOSITORY .

public section.

  methods INFO
    importing
      !MESSAGE type STRING .
  methods WARNING
    importing
      !MESSAGE type STRING .
  methods ERROR
    importing
      !MESSAGE type STRING .
  methods SUCCESS
    importing
      !MESSAGE type STRING .
  methods FROM_BAPI_MESSAGE
    importing
      !BAPIRET type BAPIRET2 .
  methods FROM_BAPI_MESSAGE_TABLE
    importing
      !BAPIRETTAB type BAPIRET2_T .
  methods GET_OBJECT
    returning
      value(RETURNING) type BALOBJ_D .
  methods GET_SUBOBJECT
    returning
      value(RETURNING) type BALSUBOBJ .
  methods GET_LOG_NUMBER
    returning
      value(RETURNING) type BALOGNR .
protected section.
*"* protected components of class zCL_LOGGER
*"* do not include other source files here!!!
private section.

*"* private components of class zCL_LOGGER
*"* do not include other source files here!!!
  data LOG_OBJECT type BALOBJ_D .
  data LOG_SUBOBJECT type BALSUBOBJ .
  data LOG_NUMBER type BALOGNR .
  data LOGGING_REPOSITORY type ref to ZCL_LOGGING_REPO_HTTP .

  methods CONSTRUCTOR
    importing
      !LOG_OBJECT type BALOBJ_D
      !LOG_SUBOBJECT type BALSUBOBJ
      !LOG_NUMBER type BALOGNR optional .
  methods ADD_MESSAGE
    importing
      !LOG_MESSAGE type STRING
      !LOG_MESSAGE_TYPE type SYMSGTY .
ENDCLASS.



CLASS ZCL_LOGGER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_LOGGER->ADD_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOG_MESSAGE                    TYPE        STRING
* | [--->] LOG_MESSAGE_TYPE               TYPE        SYMSGTY
* +--------------------------------------------------------------------------------------</SIGNATURE>
method add_message.
  if me->log_number is initial.
    me->log_number = me->logging_repository->create( log_object = me->log_object log_subobject = me->log_subobject ).
  endif.
  me->logging_repository->update( log_number = me->log_number log_message = log_message log_message_type = log_message_type ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_LOGGER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] LOG_OBJECT                     TYPE        BALOBJ_D
* | [--->] LOG_SUBOBJECT                  TYPE        BALSUBOBJ
* | [--->] LOG_NUMBER                     TYPE        BALOGNR(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  if log_object is initial or log_subobject is initial.
    raise exception type zcx_logging_error.
  endif.
  " Set log objects
  me->log_object = log_object.
  me->log_subobject = log_subobject.
  me->log_number = log_number.
  " Init client
  create object me->logging_repository.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGER->ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method error.
  me->add_message( log_message = message log_message_type = 'E' ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGER->FROM_BAPI_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPIRET                        TYPE        BAPIRET2
* +--------------------------------------------------------------------------------------</SIGNATURE>
method from_bapi_message.
  data message type string.
  message = bapiret-message.
  me->add_message( log_message = message log_message_type = bapiret-type ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGER->FROM_BAPI_MESSAGE_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPIRETTAB                     TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
method from_bapi_message_table.
  data bapiret type bapiret2.
  loop at bapirettab into bapiret.
    me->from_bapi_message( bapiret ).
  endloop.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGER->GET_LOG_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        BALOGNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_log_number.
  returning = me->log_number.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGER->GET_OBJECT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        BALOBJ_D
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_object.
  returning = me->log_object.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGER->GET_SUBOBJECT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        BALSUBOBJ
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_subobject.
  returning = me->log_subobject.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGER->INFO
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method info.
  me->add_message( log_message = message log_message_type = 'I' ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGER->SUCCESS
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method success.
  me->add_message( log_message = message log_message_type = 'S' ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LOGGER->WARNING
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method warning.
  me->add_message( log_message = message log_message_type = 'W' ).
endmethod.
ENDCLASS.
