interface ZIF_LOGGING_REPOSITORY
  public .


  methods CREATE
    importing
      !LOG_OBJECT type BALOBJ_D
      !LOG_SUBOBJECT type BALSUBOBJ
    returning
      value(RETURNING) type BALOGNR .
  methods FIND_BY_ID
    importing
      !LOG_NUMBER type BALOGNR
    returning
      value(RETURNING) type ref to ZCL_LOGGER .
  type-pools ABAP .
  methods UPDATE
    importing
      !LOG_NUMBER type BALOGNR
      !LOG_MESSAGE type STRING
      !LOG_MESSAGE_TYPE type SYMSGTY
    returning
      value(RETURNING) type ABAP_BOOL .
endinterface.
