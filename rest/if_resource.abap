interface IF_RESOURCE
  public .


  methods CREATE
    importing
      !REQUEST type ref to IF_REQUEST
      !RESPONSE type ref to IF_RESPONSE .
  methods READ
    importing
      !REQUEST type ref to IF_REQUEST
      !RESPONSE type ref to IF_RESPONSE .
  methods UPDATE
    importing
      !REQUEST type ref to IF_REQUEST
      !RESPONSE type ref to IF_RESPONSE .
  methods DELETE
    importing
      !REQUEST type ref to IF_REQUEST
      !RESPONSE type ref to IF_RESPONSE .
  methods HEAD
    importing
      !REQUEST type ref to IF_REQUEST
      !RESPONSE type ref to IF_RESPONSE .
  methods ID
    returning
      value(RETURNING) type RESOURCEID .
  methods URIPATTERN
    returning
      value(RETURNING) type URIPATTERN .
endinterface.
