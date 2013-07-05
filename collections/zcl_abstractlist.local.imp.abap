*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*----------------------------------------------------------------------*
*       CLASS lcl_iterator DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_iterator definition inheriting from zcl_object.
  public section.
    interfaces zif_iterator.
    methods constructor importing enclosinglist type ref to zcl_abstractlist.
  protected section.
    data enclosinglist type ref to zcl_abstractlist.
    data cursor type i value 0.
    data lastret type i value -1.
    data expectedmodcount type i.
    methods checkforcomodification final.
endclass.                    "lcl_iterator DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_listiterator DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_listiterator definition inheriting from lcl_iterator final.
  public section.
    interfaces zif_listiterator.
    methods constructor importing enclosinglist type ref to zcl_abstractlist
                                  index type i.
endclass.                    "lcl_listiterator DEFINITION

class zcl_abstractlist definition local friends lcl_iterator lcl_listiterator.

*----------------------------------------------------------------------*
*       CLASS lcl_iterator IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_iterator implementation.
  method constructor.
    super->constructor( ).
    me->enclosinglist = enclosinglist.
    me->expectedmodcount = enclosinglist->modcount.
  endmethod.                    "constructor
  method zif_iterator~hasnext.
    if me->cursor <> enclosinglist->size( ).
      returning = abap_true.
      return.
    else.
      returning = abap_false.
      return.
    endif.
  endmethod.                    "zif_iterator~HASNEXT
  method zif_iterator~next.
    me->checkforcomodification( ).
    try.
        data next type ref to zcl_object.
        next = enclosinglist->get( me->cursor ).
        me->lastret = me->cursor.
        me->cursor = me->cursor + 1.
        returning = next.
        return.
      catch zcx_indexoutofbounds.
        me->checkforcomodification( ). " Check if this exception is caused by a concurrent modification
        raise exception type zcx_nosuchelement. " Not a concurrent modification, element simply not found
    endtry.
  endmethod.                    "zif_iterator~NEXT
  method zif_iterator~remove.
    if lastret = -1.
      raise exception type zcx_illegalstate.
    endif.
    me->checkforcomodification( ).
    try.
        enclosinglist->removeat( index = me->lastret ).
        if me->lastret < me->cursor.
          me->cursor = me->cursor - 1.
        endif.
        me->lastret = -1.
        me->expectedmodcount = enclosinglist->modcount.
      catch zcx_indexoutofbounds.
        raise exception type zcx_concurrmodification.
    endtry.
  endmethod.                    "zif_iterator~REMOVE
  method checkforcomodification.
    if enclosinglist->modcount <> me->expectedmodcount.
      raise exception type zcx_concurrmodification.
    endif.
  endmethod.                    "checkforcomodification
endclass.                    "lcl_iterator IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_listiterator IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_listiterator implementation.
  method constructor.
    super->constructor( enclosinglist ).
    me->cursor = index.
  endmethod.                    "constructor
  method zif_listiterator~add.
    me->checkforcomodification( ).
    try.
        enclosinglist->addat( index = me->cursor element = element ).
        me->cursor = me->cursor + 1.
        me->lastret = -1.
        me->expectedmodcount = enclosinglist->modcount.
      catch zcx_indexoutofbounds.
        raise exception type zcx_concurrmodification.
    endtry.
  endmethod.                    "zif_listiterator~ADD
  method zif_listiterator~hasprevious.
    if me->cursor <> 0.
      returning = abap_true.
      return.
    else.
      returning = abap_false.
      return.
    endif.
  endmethod.                    "zif_listiterator~HASPREVIOUS
  method zif_listiterator~nextindex.
    returning = me->cursor.
    return.
  endmethod.                    "zif_listiterator~NEXTINDEX
  method zif_listiterator~previous.
    me->checkforcomodification( ).
    try.
        data previousindex type i.
        previousindex = me->cursor - 1.
        data previous type ref to zcl_object.
        previous = enclosinglist->get( previousindex ).
        me->lastret = previousindex.
        me->cursor = previousindex.
        returning = previous.
        return.
      catch zcx_indexoutofbounds.
        me->checkforcomodification( ). " Check if this exception is caused by a concurrent modification
        raise exception type zcx_nosuchelement. " Not a concurrent modification, element simply not found
    endtry.
  endmethod.                    "zif_listiterator~PREVIOUS
  method zif_listiterator~previousindex.
    returning = me->cursor - 1.
    return.
  endmethod.                    "zif_listiterator~PREVIOUSINDEX
  method zif_listiterator~set.
    if lastret = -1.
      raise exception type zcx_illegalstate.
    endif.
    me->checkforcomodification( ).
    try.
        enclosinglist->set( index = me->lastret element = element ).
        me->expectedmodcount = enclosinglist->modcount.
      catch zcx_indexoutofbounds.
        raise exception type zcx_concurrmodification.
    endtry.
  endmethod.                    "zif_listiterator~SET
endclass.                    "lcl_listiterator IMPLEMENTATION
