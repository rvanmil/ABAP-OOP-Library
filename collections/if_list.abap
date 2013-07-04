interface IF_LIST
  public .


  interfaces IF_COLLECTION .

  methods ADDAT
    importing
      !INDEX type I
      !ELEMENT type ref to CL_OBJECT .
  type-pools ABAP .
  methods ADDALLAT
    importing
      !INDEX type I
      !COLLECTION type ref to IF_COLLECTION
    returning
      value(RETURNING) type ABAP_BOOL .
  methods GET
    importing
      !INDEX type I
    returning
      value(RETURNING) type ref to CL_OBJECT .
  methods INDEXOF
    importing
      !OBJECT type ref to CL_OBJECT
    returning
      value(RETURNING) type I .
  methods LASTINDEXOF
    importing
      !OBJECT type ref to CL_OBJECT
    returning
      value(RETURNING) type I .
  methods LISTITERATOR
    returning
      value(RETURNING) type ref to IF_LISTITERATOR .
  methods LISTITERATORAT
    importing
      !INDEX type I
    returning
      value(RETURNING) type ref to IF_LISTITERATOR .
  methods REMOVEAT
    importing
      !INDEX type I
    returning
      value(RETURNING) type ref to CL_OBJECT .
  methods SET
    importing
      !INDEX type I
      !ELEMENT type ref to CL_OBJECT
    returning
      value(RETURNING) type ref to CL_OBJECT .
endinterface.
