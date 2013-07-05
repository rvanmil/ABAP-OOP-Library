class ZCL_ABSTRACTLIST definition
  public
  inheriting from ZCL_ABSTRACTCOLLECTION
  abstract
  create public .

public section.

*"* public components of class zCL_ABSTRACTLIST
*"* do not include other source files here!!!
  interfaces ZIF_LIST
      abstract methods GET .

  aliases ADDALLAT
    for ZIF_LIST~ADDALLAT .
  aliases ADDAT
    for ZIF_LIST~ADDAT .
  aliases GET
    for ZIF_LIST~GET .
  aliases INDEXOF
    for ZIF_LIST~INDEXOF .
  aliases LASTINDEXOF
    for ZIF_LIST~LASTINDEXOF .
  aliases LISTITERATOR
    for ZIF_LIST~LISTITERATOR .
  aliases LISTITERATORAT
    for ZIF_LIST~LISTITERATORAT .
  aliases REMOVEAT
    for ZIF_LIST~REMOVEAT .
  aliases SET
    for ZIF_LIST~SET .

  methods ZIF_COLLECTION~ADD
    redefinition .
  methods ZIF_COLLECTION~CLEAR
    redefinition .
  methods ZIF_COLLECTION~ITERATOR
    redefinition .
  methods EQUALS
    redefinition .
protected section.

*"* protected components of class zCL_ABSTRACTLIST
*"* do not include other source files here!!!
  data MODCOUNT type I value 0. "#EC NOTEXT . " .

  methods REMOVERANGE
    importing
      !FROMINDEX type I
      !TOINDEX type I .
private section.
*"* private components of class zCL_ABSTRACTLIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ABSTRACTLIST IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_COLLECTION~ADD
* +-------------------------------------------------------------------------------------------------+
* | [--->] ELEMENT                        TYPE REF TO ZCL_OBJECT
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~add.
  data index type i.
  index = me->size( ).
  me->addat( index = index element = element ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_COLLECTION~CLEAR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~clear.
  data size type i.
  size = me->size( ).
  me->removerange( fromindex = 0 toindex = size ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_COLLECTION~ITERATOR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO ZIF_ITERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~iterator.
  data iterator type ref to lcl_iterator.
  create object iterator
    exporting
      enclosinglist = me.
  returning = iterator.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_LIST~ADDALLAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [--->] COLLECTION                     TYPE REF TO ZIF_COLLECTION
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_list~addallat.
  data newindex type i.
  newindex = index.
  data modified type abap_bool.
  modified = abap_false.
  data iterator type ref to zif_iterator.
  iterator = collection->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data next type ref to zcl_object.
    next = iterator->next( ).
    me->addat( index = newindex element = next ).
    newindex = newindex + 1.
    modified = abap_true.
  endwhile.
  returning = modified.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_LIST~ADDAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [--->] ELEMENT                        TYPE REF TO ZCL_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_list~addat.
  raise exception type zcx_unsupportedoperation.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_LIST~INDEXOF
* +-------------------------------------------------------------------------------------------------+
* | [--->] OBJECT                         TYPE REF TO ZCL_OBJECT
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_list~indexof.
  " Returns the index of the first match
  data listiterator type ref to zif_listiterator.
  listiterator = me->listiterator( ).
  if object is not bound.
    while listiterator->hasnext( ) = abap_true.
      if object = listiterator->next( ).
        returning = listiterator->previousindex( ).
        return.
      endif.
    endwhile.
  else.
    while listiterator->hasnext( ) = abap_true.
      data obj type ref to zcl_object.
      obj = listiterator->next( ).
      if obj->equals( object ) = abap_true.
        returning = listiterator->previousindex( ).
        return.
      endif.
    endwhile.
  endif.
  " Return -1 if the object is not found
  returning = -1.
  return.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_LIST~LASTINDEXOF
* +-------------------------------------------------------------------------------------------------+
* | [--->] OBJECT                         TYPE REF TO ZCL_OBJECT
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_list~lastindexof.
  " Returns the index of the first match
  data index type i.
  index = me->size( ).
  data listiterator type ref to zif_listiterator.
  listiterator = me->listiteratorat( index ).
  if object is not bound.
    while listiterator->hasprevious( ) = abap_true.
      if object = listiterator->previous( ).
        returning = listiterator->nextindex( ).
        return.
      endif.
    endwhile.
  else.
    while listiterator->hasprevious( ) = abap_true.
      data obj type ref to zcl_object.
      obj = listiterator->previous( ).
      if obj->equals( object ) = abap_true.
        returning = listiterator->nextindex( ).
        return.
      endif.
    endwhile.
  endif.
  " Return -1 if the object is not found
  returning = -1.
  return.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_LIST~LISTITERATOR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO ZIF_LISTITERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_list~listiterator.
  returning = me->listiteratorat( 0 ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_LIST~LISTITERATORAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [<-()] RETURNING                      TYPE REF TO ZIF_LISTITERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_list~listiteratorat.
  if index < 0 or index > me->size( ).
    raise exception type zcx_indexoutofbounds.
  endif.
  data listiterator type ref to lcl_listiterator.
  create object listiterator
    exporting
      enclosinglist = me
      index         = index.
  returning = listiterator.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_LIST~REMOVEAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [<-()] RETURNING                      TYPE REF TO ZCL_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_list~removeat.
  raise exception type zcx_unsupportedoperation.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->ZIF_LIST~SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [--->] ELEMENT                        TYPE REF TO ZCL_OBJECT
* | [<-()] RETURNING                      TYPE REF TO ZCL_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_list~set.
  raise exception type zcx_unsupportedoperation.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTLIST->EQUALS
* +-------------------------------------------------------------------------------------------------+
* | [--->] OBJ                            TYPE REF TO ZCL_OBJECT
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method equals.
  if me = obj.
    returning = abap_true.
    return.
  endif.
  data otherlist type ref to zif_list.
  try.
      otherlist ?= obj.
    catch cx_sy_move_cast_error.
      returning = abap_false.
      return.
  endtry.
  " Compare each element in both lists until one of the lists (or both) have no more elements
  data it_thislist type ref to zif_listiterator.
  data it_otherlist type ref to zif_listiterator.
  it_thislist = me->listiterator( ).
  it_otherlist = otherlist->listiterator( ).
  while ( it_thislist->hasnext( ) = abap_true ) and ( it_otherlist->hasnext( ) = abap_true ).
    data obj_thislist type ref to zcl_object.
    data obj_otherlist type ref to zcl_object.
    obj_thislist = it_thislist->next( ).
    obj_otherlist = it_otherlist->next( ).
    if obj_thislist is not bound.
      if obj_otherlist is bound.
        " obj_thislist is null, but obj_otherlist is not null
        returning = abap_false.
        return.
      endif.
    else.
      if obj_otherlist is not bound.
        " obj_thislist is not null, but obj_otherlist is null
        returning = abap_false.
        return.
      endif.
      " both are not null, compare using equals method
      if obj_thislist->equals( obj_otherlist ) = abap_false.
        returning = abap_false.
        return.
      endif.
    endif.
  endwhile.
  " If one of the lists still has remaining elements at this point, then they are not equal
  if ( it_thislist->hasnext( ) = abap_true ) or ( it_otherlist->hasnext( ) = abap_true ).
    returning = abap_false.
    return.
  endif.
  " Lists are equal
  returning = abap_true.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ABSTRACTLIST->REMOVERANGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] FROMINDEX                      TYPE        I
* | [--->] TOINDEX                        TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method removerange.
  data listiterator type ref to zif_listiterator.
  listiterator = me->listiteratorat( fromindex ).
  data count type i.
  count = toindex - fromindex.
  if count > 0.
    do count times.
      listiterator->next( ).
      listiterator->remove( ).
    enddo.
  endif.
endmethod.
ENDCLASS.
