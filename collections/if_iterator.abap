interface IF_ITERATOR
  public .


  type-pools ABAP .
  methods HASNEXT
    returning
      value(RETURNING) type ABAP_BOOL .
  methods NEXT
    returning
      value(RETURNING) type ref to CL_OBJECT .
  methods REMOVE .
endinterface.
