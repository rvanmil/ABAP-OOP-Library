*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*----------------------------------------------------------------------*
*       CLASS lcl_unmodifiablecollection DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmodifiablecollection definition.
  public section.
    interfaces if_collection.
    interfaces if_serializable_object.
    aliases add for if_collection~add .
    aliases addall for if_collection~addall .
    aliases clear for if_collection~clear .
    aliases contains for if_collection~contains .
    aliases containsall for if_collection~containsall .
    aliases isempty for if_collection~isempty .
    aliases iterator for if_collection~iterator .
    aliases remove for if_collection~remove .
    aliases removeall for if_collection~removeall .
    aliases retainall for if_collection~retainall .
    aliases size for if_collection~size .
    aliases toarray for if_collection~toarray .
    methods constructor importing collection type ref to if_collection.
  private section.
    data collection type ref to if_collection.
endclass.                    "lcl_UnmodifiableCollection DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_unmodifiablelist DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmodifiablelist definition inheriting from lcl_unmodifiablecollection final.
  public section.
    interfaces if_list.
    aliases addallat for if_list~addallat.
    aliases addat for if_list~addat.
    aliases get for if_list~get.
    aliases indexof for if_list~indexof.
    aliases lastindexof for if_list~lastindexof.
    aliases listiterator for if_list~listiterator.
    aliases listiteratorat for if_list~listiteratorat.
    aliases removeat for if_list~removeat.
    aliases set for if_list~set.
    methods constructor importing list type ref to if_list.
  private section.
    data list type ref to if_list.
endclass.                    "lcl_unmodifiablelist DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_unmod_collection_iterator DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmod_coll_iterator definition final.
  public section.
    interfaces if_iterator.
    methods constructor importing iterator type ref to if_iterator.
  private section.
    data iterator type ref to if_iterator.
endclass.                    "lcl_unmod_collection_iterator DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_unmod_coll_listiterator DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmod_coll_listiterator definition final.
  public section.
    interfaces if_listiterator.
    methods constructor importing listiterator type ref to if_listiterator.
  private section.
    data listiterator type ref to if_listiterator.
endclass.                    "lcl_unmod_coll_listiterator DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_unmodifiablecollection IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmodifiablecollection implementation.
  method constructor.
    if collection is not bound.
      raise exception type cx_sy_ref_is_initial.
    endif.
    me->collection = collection.
  endmethod.                    "constructor
  method if_collection~add.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_collection~add
  method if_collection~addall.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_collection~addall
  method if_collection~clear.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_collection~clear
  method if_collection~contains.
    returning = me->collection->contains( object ).
  endmethod.                    "if_collection~contains
  method if_collection~containsall.
    returning = me->collection->containsall( collection ).
  endmethod.                    "if_collection~containsall
  method if_collection~isempty.
    returning = me->collection->isempty( ).
  endmethod.                    "if_collection~isempty
  method if_collection~iterator.
    data iterator type ref to if_iterator.
    iterator ?= me->collection->iterator( ).
    data unmod_coll_iterator type ref to lcl_unmod_coll_iterator.
    create object unmod_coll_iterator
      exporting
        iterator = iterator.
    returning = unmod_coll_iterator.
  endmethod.                    "if_collection~iterator
  method if_collection~remove.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_collection~remove
  method if_collection~removeall.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_collection~removeall
  method if_collection~retainall.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_collection~retainall
  method if_collection~size.
    returning = me->collection->size( ).
  endmethod.                    "if_collection~size
  method if_collection~toarray.
    returning = me->collection->toarray( ).
  endmethod.                    "if_collection~toarray
endclass.                    "lcl_unmodifiablecollection IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_unmodifiablelist IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmodifiablelist implementation.
  method constructor.
    super->constructor( list ).
    me->list = list.
  endmethod.                    "constructor
  method if_list~addallat.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_list~addallat
  method if_list~addat.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_list~addat
  method if_list~get.
    returning = me->list->get( index ).
  endmethod.                    "if_list~get
  method if_list~indexof.
    returning = me->list->indexof( object ).
  endmethod.                    "if_list~indexof
  method if_list~lastindexof.
    returning = me->list->lastindexof( object ).
  endmethod.                    "if_list~lastindexof
  method if_list~listiterator.
    returning = me->listiteratorat( 0 ).
  endmethod.                    "if_list~listiterator
  method if_list~listiteratorat.
    data listiterator type ref to if_listiterator.
    listiterator ?= me->list->listiteratorat( index ).
    data unmod_coll_listiterator type ref to lcl_unmod_coll_listiterator.
    create object unmod_coll_listiterator
      exporting
        listiterator = listiterator.
    returning = unmod_coll_listiterator.
  endmethod.                    "if_list~listiteratorat
  method if_list~removeat.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_list~removeat
  method if_list~set.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_list~set
endclass.                    "lcl_unmodifiablelist IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_unmod_collection_iterator IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmod_coll_iterator implementation.
  method constructor.
    me->iterator = iterator.
  endmethod.                    "constructor
  method if_iterator~hasnext.
    returning = me->iterator->hasnext( ).
  endmethod.                    "if_iterator~HASNEXT
  method if_iterator~next.
    returning = me->iterator->next( ).
  endmethod.                    "if_iterator~NEXT
  method if_iterator~remove.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_iterator~REMOVE
endclass.                    "lcl_unmod_collection_iterator IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_unmod_coll_listiterator IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmod_coll_listiterator implementation.
  method constructor.
    me->listiterator = listiterator.
  endmethod.                    "constructor
  method if_iterator~hasnext.
    returning = me->listiterator->hasnext( ).
  endmethod.                    "if_iterator~HASNEXT
  method if_iterator~next.
    returning = me->listiterator->next( ).
  endmethod.                    "if_iterator~NEXT
  method if_iterator~remove.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_iterator~REMOVE
  method if_listiterator~add.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_listiterator~ADD
  method if_listiterator~hasprevious.
    returning = me->listiterator->hasprevious( ).
  endmethod.                    "if_listiterator~HASPREVIOUS
  method if_listiterator~nextindex.
    returning = me->listiterator->nextindex( ).
  endmethod.                    "if_listiterator~NEXTINDEX
  method if_listiterator~previous.
    returning = me->listiterator->previous( ).
  endmethod.                    "if_listiterator~PREVIOUS
  method if_listiterator~previousindex.
    returning = me->listiterator->previousindex( ).
  endmethod.                    "if_listiterator~PREVIOUSINDEX
  method if_listiterator~set.
    raise exception type cx_unsupportedoperation.
  endmethod.                    "if_listiterator~SET
endclass.                    "lcl_unmod_coll_listiterator IMPLEMENTATION
