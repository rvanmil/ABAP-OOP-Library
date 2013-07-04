interface IF_REQUEST
  public .


  methods GET_BODY_BINARY
    returning
      value(RETURNING) type XSTRING .
  methods GET_BODY_TEXT
    returning
      value(RETURNING) type STRING .
  methods GET_CONTENT_TYPE
    returning
      value(RETURNING) type STRING .
  methods GET_HEADER
    importing
      !NAME type STRING
    returning
      value(RETURNING) type STRING .
  methods GET_METHOD
    returning
      value(RETURNING) type STRING .
  methods GET_PARAMETER
    importing
      !NAME type STRING
    returning
      value(RETURNING) type STRING .
  methods GET_RAW_MESSAGE
    returning
      value(RETURNING) type XSTRING .
  methods GET_REQUESTURI
    returning
      value(RETURNING) type STRING .
  methods LIST_HEADERS
    returning
      value(RETURNING) type TIHTTPNVP .
  methods LIST_PARAMETERS
    returning
      value(RETURNING) type TIHTTPNVP .
endinterface.
