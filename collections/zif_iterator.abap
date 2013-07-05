interface ZIF_ITERATOR
  public .


  type-pools ABAP .
  methods HASNEXT
    returning
      value(RETURNING) type ABAP_BOOL .
  methods NEXT
    returning
      value(RETURNING) type ref to ZCL_OBJECT .
  methods REMOVE .
endinterface.
