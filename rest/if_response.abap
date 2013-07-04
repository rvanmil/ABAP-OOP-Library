interface IF_RESPONSE
  public .


  methods ADD_HEADER
    importing
      !NAME type STRING
      !VALUE type STRING .
  methods DISABLE_COMPRESSION .
  methods EXPIRES_AFTER
    importing
      !SECONDS type I .
  methods EXPIRES_AT
    importing
      !DATE type D
      !TIME type T .
  type-pools ABAP .
  methods IS_COMMITTED
    returning
      value(RETURNING) type ABAP_BOOL .
  methods REDIRECT
    importing
      !URL type STRING
      !PERMANENTLY type I default 0
      !EXPLANATION type STRING default ''
      !PROTOCOL_DEPENDENT type I default 0 .
  methods SEND_ACCEPTED
    importing
      !LOCATION type STRING optional .
  methods SEND_BAD_REQUEST
    importing
      !MESSAGE type STRING optional .
  methods SEND_BINARY
    importing
      !DATA type XSTRING
      !MIME_TYPE type STRING default 'application/octet-stream' "#EC NOTEXT
      !CODE type I default 200 .
  methods SEND_CREATED
    importing
      !LOCATION type STRING optional .
  methods SEND_ERROR
    importing
      !CODE type I
      !MESSAGE type STRING optional .
  methods SEND_INTERNAL_SERVER_ERROR
    importing
      !MESSAGE type STRING optional .
  methods SEND_NOT_FOUND
    importing
      !MESSAGE type STRING optional .
  methods SEND_OK .
  methods SEND_TEXT
    importing
      !DATA type STRING
      !MIME_TYPE type STRING default 'text/plain' "#EC NOTEXT
      !CODE type I default 200 .
  methods SEND_UNAUTHORIZED
    importing
      !MESSAGE type STRING optional .
endinterface.
