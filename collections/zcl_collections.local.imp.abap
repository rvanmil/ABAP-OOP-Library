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
    interfaces zif_collection.
    interfaces if_serializable_object.
    aliases add for zif_collection~add .
    aliases addall for zif_collection~addall .
    aliases clear for zif_collection~clear .
    aliases contains for zif_collection~contains .
    aliases containsall for zif_collection~containsall .
    aliases isempty for zif_collection~isempty .
    aliases iterator for zif_collection~iterator .
    aliases remove for zif_collection~remove .
    aliases removeall for zif_collection~removeall .
    aliases retainall for zif_collection~retainall .
    aliases size for zif_collection~size .
    aliases toarray for zif_collection~toarray .
    methods constructor importing collection type ref to zif_collection.
  private section.
    data collection type ref to zif_collection.
endclass.                    "lcl_UnmodifiableCollection DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_unmodifiablelist DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmodifiablelist definition inheriting from lcl_unmodifiablecollection final.
  public section.
    interfaces zif_list.
    aliases addallat for zif_list~addallat.
    aliases addat for zif_list~addat.
    aliases get for zif_list~get.
    aliases indexof for zif_list~indexof.
    aliases lastindexof for zif_list~lastindexof.
    aliases listiterator for zif_list~listiterator.
    aliases listiteratorat for zif_list~listiteratorat.
    aliases removeat for zif_list~removeat.
    aliases set for zif_list~set.
    methods constructor importing list type ref to zif_list.
  private section.
    data list type ref to zif_list.
endclass.                    "lcl_unmodifiablelist DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_unmod_collection_iterator DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmod_coll_iterator definition final.
  public section.
    interfaces zif_iterator.
    methods constructor importing iterator type ref to zif_iterator.
  private section.
    data iterator type ref to zif_iterator.
endclass.                    "lcl_unmod_collection_iterator DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_unmod_coll_listiterator DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_unmod_coll_listiterator definition final.
  public section.
    interfaces zif_listiterator.
    methods constructor importing listiterator type ref to zif_listiterator.
  private section.
    data listiterator type ref to zif_listiterator.
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
  method zif_collection~add.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_collection~add
  method zif_collection~addall.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_collection~addall
  method zif_collection~clear.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_collection~clear
  method zif_collection~contains.
    returning = me->collection->contains( object ).
  endmethod.                    "zif_collection~contains
  method zif_collection~containsall.
    returning = me->collection->containsall( collection ).
  endmethod.                    "zif_collection~containsall
  method zif_collection~isempty.
    returning = me->collection->isempty( ).
  endmethod.                    "zif_collection~isempty
  method zif_collection~iterator.
    data iterator type ref to zif_iterator.
    iterator ?= me->collection->iterator( ).
    data unmod_coll_iterator type ref to lcl_unmod_coll_iterator.
    create object unmod_coll_iterator
      exporting
        iterator = iterator.
    returning = unmod_coll_iterator.
  endmethod.                    "zif_collection~iterator
  method zif_collection~remove.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_collection~remove
  method zif_collection~removeall.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_collection~removeall
  method zif_collection~retainall.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_collection~retainall
  method zif_collection~size.
    returning = me->collection->size( ).
  endmethod.                    "zif_collection~size
  method zif_collection~toarray.
    returning = me->collection->toarray( ).
  endmethod.                    "zif_collection~toarray
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
  method zif_list~addallat.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_list~addallat
  method zif_list~addat.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_list~addat
  method zif_list~get.
    returning = me->list->get( index ).
  endmethod.                    "zif_list~get
  method zif_list~indexof.
    returning = me->list->indexof( object ).
  endmethod.                    "zif_list~indexof
  method zif_list~lastindexof.
    returning = me->list->lastindexof( object ).
  endmethod.                    "zif_list~lastindexof
  method zif_list~listiterator.
    returning = me->listiteratorat( 0 ).
  endmethod.                    "zif_list~listiterator
  method zif_list~listiteratorat.
    data listiterator type ref to zif_listiterator.
    listiterator ?= me->list->listiteratorat( index ).
    data unmod_coll_listiterator type ref to lcl_unmod_coll_listiterator.
    create object unmod_coll_listiterator
      exporting
        listiterator = listiterator.
    returning = unmod_coll_listiterator.
  endmethod.                    "zif_list~listiteratorat
  method zif_list~removeat.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_list~removeat
  method zif_list~set.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_list~set
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
  method zif_iterator~hasnext.
    returning = me->iterator->hasnext( ).
  endmethod.                    "zif_iterator~HASNEXT
  method zif_iterator~next.
    returning = me->iterator->next( ).
  endmethod.                    "zif_iterator~NEXT
  method zif_iterator~remove.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_iterator~REMOVE
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
  method zif_iterator~hasnext.
    returning = me->listiterator->hasnext( ).
  endmethod.                    "zif_iterator~HASNEXT
  method zif_iterator~next.
    returning = me->listiterator->next( ).
  endmethod.                    "zif_iterator~NEXT
  method zif_iterator~remove.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_iterator~REMOVE
  method zif_listiterator~add.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_listiterator~ADD
  method zif_listiterator~hasprevious.
    returning = me->listiterator->hasprevious( ).
  endmethod.                    "zif_listiterator~HASPREVIOUS
  method zif_listiterator~nextindex.
    returning = me->listiterator->nextindex( ).
  endmethod.                    "zif_listiterator~NEXTINDEX
  method zif_listiterator~previous.
    returning = me->listiterator->previous( ).
  endmethod.                    "zif_listiterator~PREVIOUS
  method zif_listiterator~previousindex.
    returning = me->listiterator->previousindex( ).
  endmethod.                    "zif_listiterator~PREVIOUSINDEX
  method zif_listiterator~set.
    raise exception type zcx_unsupportedoperation.
  endmethod.                    "zif_listiterator~SET
endclass.                    "lcl_unmod_coll_listiterator IMPLEMENTATION
