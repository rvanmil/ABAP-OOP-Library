interface ZIF_LIST
  public .


  interfaces ZIF_COLLECTION .

  methods ADDAT
    importing
      !INDEX type I
      !ELEMENT type ref to ZCL_OBJECT .
  type-pools ABAP .
  methods ADDALLAT
    importing
      !INDEX type I
      !COLLECTION type ref to ZIF_COLLECTION
    returning
      value(RETURNING) type ABAP_BOOL .
  methods GET
    importing
      !INDEX type I
    returning
      value(RETURNING) type ref to ZCL_OBJECT .
  methods INDEXOF
    importing
      !OBJECT type ref to ZCL_OBJECT
    returning
      value(RETURNING) type I .
  methods LASTINDEXOF
    importing
      !OBJECT type ref to ZCL_OBJECT
    returning
      value(RETURNING) type I .
  methods LISTITERATOR
    returning
      value(RETURNING) type ref to ZIF_LISTITERATOR .
  methods LISTITERATORAT
    importing
      !INDEX type I
    returning
      value(RETURNING) type ref to ZIF_LISTITERATOR .
  methods REMOVEAT
    importing
      !INDEX type I
    returning
      value(RETURNING) type ref to ZCL_OBJECT .
  methods SET
    importing
      !INDEX type I
      !ELEMENT type ref to ZCL_OBJECT
    returning
      value(RETURNING) type ref to ZCL_OBJECT .
endinterface.
