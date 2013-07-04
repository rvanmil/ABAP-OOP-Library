interface IF_LISTITERATOR
  public .


  interfaces IF_ITERATOR .

  aliases HASNEXT
    for IF_ITERATOR~HASNEXT .
  aliases NEXT
    for IF_ITERATOR~NEXT .
  aliases REMOVE
    for IF_ITERATOR~REMOVE .

  methods ADD
    importing
      !ELEMENT type ref to CL_OBJECT .
  type-pools ABAP .
  methods HASPREVIOUS
    returning
      value(RETURNING) type ABAP_BOOL .
  methods NEXTINDEX
    returning
      value(RETURNING) type I .
  methods PREVIOUS
    returning
      value(RETURNING) type ref to CL_OBJECT .
  methods PREVIOUSINDEX
    returning
      value(RETURNING) type I .
  methods SET
    importing
      !ELEMENT type ref to CL_OBJECT .
endinterface.
