class ZCL_ABSTRACTCOLLECTION definition
  public
  inheriting from ZCL_OBJECT
  abstract
  create public .

public section.

*"* public components of class zCL_ABSTRACTCOLLECTION
*"* do not include other source files here!!!
  interfaces ZIF_COLLECTION
      abstract methods ITERATOR
                       SIZE .

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
protected section.
*"* protected components of class zCL_ABSTRACTCOLLECTION
*"* do not include other source files here!!!
private section.
*"* private components of class zCL_ABSTRACTCOLLECTION
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ABSTRACTCOLLECTION IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~ADD
* +-------------------------------------------------------------------------------------------------+
* | [--->] ELEMENT                        TYPE REF TO ZCL_OBJECT
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~add.
  raise exception type zcx_unsupportedoperation.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~ADDALL
* +-------------------------------------------------------------------------------------------------+
* | [--->] COLLECTION                     TYPE REF TO ZIF_COLLECTION
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~addall.
  data modified type abap_bool.
  modified = abap_false.
  data iterator type ref to zif_iterator.
  iterator = collection->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data next type ref to zcl_object.
    next = iterator->next( ).
    if me->add( next ) = abap_true.
      modified = abap_true.
    endif.
  endwhile.
  returning = modified.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~CLEAR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~clear.
  data iterator type ref to zif_iterator.
  iterator = me->iterator( ).
  while iterator->hasnext( ) = abap_true.
    iterator->next( ).
    iterator->remove( ).
  endwhile.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~CONTAINS
* +-------------------------------------------------------------------------------------------------+
* | [--->] OBJECT                         TYPE REF TO ZCL_OBJECT
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~contains.
  data iterator type ref to zif_iterator.
  iterator = me->iterator( ).
  if object is not bound.
    while iterator->hasnext( ) = abap_true.
      if object = iterator->next( ).
        returning = abap_true.
        return.
      endif.
    endwhile.
  else.
    while iterator->hasnext( ) = abap_true.
      data obj type ref to zcl_object.
      obj = iterator->next( ).
      if obj->equals( object ) = abap_true.
        returning = abap_true.
        return.
      endif.
    endwhile.
  endif.
  " Return false if the object is not found
  returning = abap_false.
  return.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~CONTAINSALL
* +-------------------------------------------------------------------------------------------------+
* | [--->] COLLECTION                     TYPE REF TO ZIF_COLLECTION
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~containsall.
  data iterator type ref to zif_iterator.
  iterator = collection->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data next type ref to zcl_object.
    next = iterator->next( ).
    if me->contains( next ) = abap_false.
      returning = abap_false.
      return.
    endif.
  endwhile.
  returning = abap_true.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~ISEMPTY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~isempty.
  if me->size( ) = 0.
    returning = abap_true.
    return.
  endif.
  returning = abap_false.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~REMOVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] OBJECT                         TYPE REF TO ZCL_OBJECT
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~remove.
  data iterator type ref to zif_iterator.
  iterator = me->iterator( ).
  if object is not bound.
    while iterator->hasnext( ) = abap_true.
      if object = iterator->next( ).
        iterator->remove( ).
        returning = abap_true.
        return.
      endif.
    endwhile.
  else.
    while iterator->hasnext( ) = abap_true.
      data obj type ref to zcl_object.
      obj = iterator->next( ).
      if obj->equals( object ) = abap_true.
        iterator->remove( ).
        returning = abap_true.
        return.
      endif.
    endwhile.
  endif.
  " Return false if the object is not found
  returning = abap_false.
  return.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~REMOVEALL
* +-------------------------------------------------------------------------------------------------+
* | [--->] COLLECTION                     TYPE REF TO ZIF_COLLECTION
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~removeall.
  data modified type abap_bool.
  modified = abap_false.
  data iterator type ref to zif_iterator.
  iterator = me->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data next type ref to zcl_object.
    next = iterator->next( ).
    if collection->contains( next ) = abap_true.
      iterator->remove( ).
      modified = abap_true.
    endif.
  endwhile.
  returning = modified.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~RETAINALL
* +-------------------------------------------------------------------------------------------------+
* | [--->] COLLECTION                     TYPE REF TO ZIF_COLLECTION
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~retainall.
  data modified type abap_bool.
  modified = abap_false.
  data iterator type ref to zif_iterator.
  iterator = me->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data next type ref to zcl_object.
    next = iterator->next( ).
    if collection->contains( next ) = abap_false.
      iterator->remove( ).
      modified = abap_true.
    endif.
  endwhile.
  returning = modified.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABSTRACTCOLLECTION->ZIF_COLLECTION~TOARRAY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        ZARRAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_collection~toarray.
  data array type zarray.
  data iterator type ref to zif_iterator.
  iterator = me->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data next type ref to zcl_object.
    next = iterator->next( ).
    append next to array.
  endwhile.
  returning = array.
endmethod.
ENDCLASS.
