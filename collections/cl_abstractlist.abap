class CL_ABSTRACTLIST definition
  public
  inheriting from CL_ABSTRACTCOLLECTION
  abstract
  create public .

public section.

*"* public components of class CL_ABSTRACTLIST
*"* do not include other source files here!!!
  interfaces IF_LIST
      abstract methods GET .

  aliases ADDALLAT
    for IF_LIST~ADDALLAT .
  aliases ADDAT
    for IF_LIST~ADDAT .
  aliases GET
    for IF_LIST~GET .
  aliases INDEXOF
    for IF_LIST~INDEXOF .
  aliases LASTINDEXOF
    for IF_LIST~LASTINDEXOF .
  aliases LISTITERATOR
    for IF_LIST~LISTITERATOR .
  aliases LISTITERATORAT
    for IF_LIST~LISTITERATORAT .
  aliases REMOVEAT
    for IF_LIST~REMOVEAT .
  aliases SET
    for IF_LIST~SET .

  methods IF_COLLECTION~ADD
    redefinition .
  methods IF_COLLECTION~CLEAR
    redefinition .
  methods IF_COLLECTION~ITERATOR
    redefinition .
  methods EQUALS
    redefinition .
protected section.

*"* protected components of class CL_ABSTRACTLIST
*"* do not include other source files here!!!
  data MODCOUNT type I value 0. "#EC NOTEXT . " .

  methods REMOVERANGE
    importing
      !FROMINDEX type I
      !TOINDEX type I .
private section.
*"* private components of class CL_ABSTRACTLIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_ABSTRACTLIST IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->IF_COLLECTION~ADD
* +-------------------------------------------------------------------------------------------------+
* | [--->] ELEMENT                        TYPE REF TO CL_OBJECT
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_collection~add.
  data index type i.
  index = me->size( ).
  me->addat( index = index element = element ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->IF_COLLECTION~CLEAR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_collection~clear.
  data size type i.
  size = me->size( ).
  me->removerange( fromindex = 0 toindex = size ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->IF_COLLECTION~ITERATOR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO IF_ITERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_collection~iterator.
  data iterator type ref to lcl_iterator.
  create object iterator
    exporting
      enclosinglist = me.
  returning = iterator.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->IF_LIST~ADDALLAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [--->] COLLECTION                     TYPE REF TO IF_COLLECTION
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_list~addallat.
  data newindex type i.
  newindex = index.
  data modified type abap_bool.
  modified = abap_false.
  data iterator type ref to if_iterator.
  iterator = collection->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data next type ref to cl_object.
    next = iterator->next( ).
    me->addat( index = newindex element = next ).
    newindex = newindex + 1.
    modified = abap_true.
  endwhile.
  returning = modified.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->IF_LIST~ADDAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [--->] ELEMENT                        TYPE REF TO CL_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_list~addat.
  raise exception type cx_unsupportedoperation.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->IF_LIST~INDEXOF
* +-------------------------------------------------------------------------------------------------+
* | [--->] OBJECT                         TYPE REF TO CL_OBJECT
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_list~indexof.
  " Returns the index of the first match
  data listiterator type ref to if_listiterator.
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
      data obj type ref to cl_object.
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
* | Instance Public Method CL_ABSTRACTLIST->IF_LIST~LASTINDEXOF
* +-------------------------------------------------------------------------------------------------+
* | [--->] OBJECT                         TYPE REF TO CL_OBJECT
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_list~lastindexof.
  " Returns the index of the first match
  data index type i.
  index = me->size( ).
  data listiterator type ref to if_listiterator.
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
      data obj type ref to cl_object.
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
* | Instance Public Method CL_ABSTRACTLIST->IF_LIST~LISTITERATOR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO IF_LISTITERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_list~listiterator.
  returning = me->listiteratorat( 0 ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->IF_LIST~LISTITERATORAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [<-()] RETURNING                      TYPE REF TO IF_LISTITERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_list~listiteratorat.
  if index < 0 or index > me->size( ).
    raise exception type cx_indexoutofbounds.
  endif.
  data listiterator type ref to lcl_listiterator.
  create object listiterator
    exporting
      enclosinglist = me
      index         = index.
  returning = listiterator.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->IF_LIST~REMOVEAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [<-()] RETURNING                      TYPE REF TO CL_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_list~removeat.
  raise exception type cx_unsupportedoperation.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->IF_LIST~SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [--->] ELEMENT                        TYPE REF TO CL_OBJECT
* | [<-()] RETURNING                      TYPE REF TO CL_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_list~set.
  raise exception type cx_unsupportedoperation.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_ABSTRACTLIST->EQUALS
* +-------------------------------------------------------------------------------------------------+
* | [--->] OBJ                            TYPE REF TO CL_OBJECT
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method equals.
  if me = obj.
    returning = abap_true.
    return.
  endif.
  data otherlist type ref to if_list.
  try.
      otherlist ?= obj.
    catch cx_sy_move_cast_error.
      returning = abap_false.
      return.
  endtry.
  " Compare each element in both lists until one of the lists (or both) have no more elements
  data it_thislist type ref to if_listiterator.
  data it_otherlist type ref to if_listiterator.
  it_thislist = me->listiterator( ).
  it_otherlist = otherlist->listiterator( ).
  while ( it_thislist->hasnext( ) = abap_true ) and ( it_otherlist->hasnext( ) = abap_true ).
    data obj_thislist type ref to cl_object.
    data obj_otherlist type ref to cl_object.
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
* | Instance Protected Method CL_ABSTRACTLIST->REMOVERANGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] FROMINDEX                      TYPE        I
* | [--->] TOINDEX                        TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method removerange.
  data listiterator type ref to if_listiterator.
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
