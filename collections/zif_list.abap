interface ZIF_LIST
  public .


  interfaces ZIF_COLLECTION .

  aliases ADD
    for ZIF_COLLECTION~ADD .
  aliases ADDALL
    for ZIF_COLLECTION~ADDALL .
  aliases CLEAR
    for ZIF_COLLECTION~CLEAR .
  aliases CONTAINS
    for ZIF_COLLECTION~CONTAINS .
  aliases CONTAINSALL
    for ZIF_COLLECTION~CONTAINSALL .
  aliases ISEMPTY
    for ZIF_COLLECTION~ISEMPTY .
  aliases ITERATOR
    for ZIF_COLLECTION~ITERATOR .
  aliases REMOVE
    for ZIF_COLLECTION~REMOVE .
  aliases REMOVEALL
    for ZIF_COLLECTION~REMOVEALL .
  aliases RETAINALL
    for ZIF_COLLECTION~RETAINALL .
  aliases SIZE
    for ZIF_COLLECTION~SIZE .
  aliases TOARRAY
    for ZIF_COLLECTION~TOARRAY .

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