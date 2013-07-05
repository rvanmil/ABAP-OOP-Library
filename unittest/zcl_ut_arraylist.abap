class ZCL_UT_ARRAYLIST definition
  public
  abstract
  create public
  for testing
  duration short
  risk level harmless .

public section.
*"* public components of class zCL_UT_ARRAYLIST
*"* do not include other source files here!!!
protected section.

*"* protected components of class zCL_UT_ARRAYLIST
*"* do not include other source files here!!!
  data TESTED_ARRAYLIST type ref to ZCL_ARRAYLIST .
  data ELEMENT1 type ref to ZCL_OBJECT .
  data ELEMENT2 type ref to ZCL_OBJECT .
  data ELEMENT3 type ref to ZCL_OBJECT .

  methods ITERATOR
  for testing .
  methods ADD
  for testing .
  methods ADDALL
  for testing .
  methods CLEAR
  for testing .
  methods CONTAINS
  for testing .
  methods CONTAINSALL
  for testing .
  methods ISEMPTY
  for testing .
  methods REMOVE
  for testing .
  methods REMOVEALL
  for testing .
  methods RETAINALL
  for testing .
  methods SIZE
  for testing .
  methods TOARRAY
  for testing .
  methods ADDALLAT
  for testing .
  methods ADDAT
  for testing .
  methods GET
  for testing .
  methods INDEXOF
  for testing .
  methods LASTINDEXOF
  for testing .
  methods LISTITERATOR
  for testing .
  methods LISTITERATORAT
  for testing .
  methods REMOVEAT
  for testing .
  methods SET
  for testing .
private section.

*"* private components of class zCL_UT_ARRAYLIST
*"* do not include other source files here!!!
  methods SETUP .
ENDCLASS.



CLASS ZCL_UT_ARRAYLIST IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->ADD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method add.
  data size type i.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
  data element4 type ref to zcl_object.
  create object element4.
  tested_arraylist->add( element4 ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 4 ).
  data element type ref to zcl_object.
  element = tested_arraylist->get( 3 ).
  cl_aunit_assert=>assert_equals( act = element exp = element4 ).
endmethod.                    "add


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->ADDALL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method addall.
  data size type i.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
  data elements type ref to zcl_arraylist.
  data element4 type ref to zcl_object.
  data element5 type ref to zcl_object.
  data element6 type ref to zcl_object.
  create object elements.
  create object element4.
  create object element5.
  create object element6.
  elements->add( element4 ).
  elements->add( element5 ).
  elements->add( element6 ).
  tested_arraylist->addall( elements ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 6 ).
  data element type ref to zcl_object.
  element = tested_arraylist->get( 3 ).
  cl_aunit_assert=>assert_equals( act = element exp = element4 ).
  element = tested_arraylist->get( 4 ).
  cl_aunit_assert=>assert_equals( act = element exp = element5 ).
  element = tested_arraylist->get( 5 ).
  cl_aunit_assert=>assert_equals( act = element exp = element6 ).
endmethod.                    "addall


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->ADDALLAT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method addallat.
  data size type i.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
  data elements type ref to zcl_arraylist.
  data element4 type ref to zcl_object.
  data element5 type ref to zcl_object.
  data element6 type ref to zcl_object.
  create object elements.
  create object element4.
  create object element5.
  create object element6.
  elements->add( element4 ).
  elements->add( element5 ).
  elements->add( element6 ).
  tested_arraylist->addallat( index = 1 collection = elements ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 6 ).
  data element type ref to zcl_object.
  element = tested_arraylist->get( 1 ).
  cl_aunit_assert=>assert_equals( act = element exp = element4 ).
  element = tested_arraylist->get( 2 ).
  cl_aunit_assert=>assert_equals( act = element exp = element5 ).
  element = tested_arraylist->get( 3 ).
  cl_aunit_assert=>assert_equals( act = element exp = element6 ).
endmethod.                    "addallat


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->ADDAT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method addat.
  data size type i.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
  data element4 type ref to zcl_object.
  create object element4.
  tested_arraylist->addat( index = 1 element = element4 ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 4 ).
  data element type ref to zcl_object.
  element = tested_arraylist->get( 1 ).
  cl_aunit_assert=>assert_equals( act = element exp = element4 ).
endmethod.                    "addat


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->CLEAR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method clear.
  data size type i.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
  tested_arraylist->clear( ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 0 ).
endmethod.                    "clear


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->CONTAINS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method contains.
  data contains type abap_bool.
  contains = tested_arraylist->contains( element1 ).
  cl_aunit_assert=>assert_equals( act = contains exp = abap_true ).
  contains = tested_arraylist->contains( element2 ).
  cl_aunit_assert=>assert_equals( act = contains exp = abap_true ).
  contains = tested_arraylist->contains( element3 ).
  cl_aunit_assert=>assert_equals( act = contains exp = abap_true ).
  data element4 type ref to zcl_object.
  contains = tested_arraylist->contains( element4 ).
  cl_aunit_assert=>assert_equals( act = contains exp = abap_false ).
  create object element4.
  contains = tested_arraylist->contains( element4 ).
  cl_aunit_assert=>assert_equals( act = contains exp = abap_false ).
endmethod.                    "contains


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->CONTAINSALL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method containsall.
  data elements type ref to zcl_arraylist.
  create object elements.
  elements->add( element1 ).
  elements->add( element2 ).
  data containsall type abap_bool.
  containsall = tested_arraylist->containsall( elements ).
  cl_aunit_assert=>assert_equals( act = containsall exp = abap_true ).
  data element4 type ref to zcl_object.
  create object element4.
  elements->add( element4 ).
  containsall = tested_arraylist->containsall( elements ).
  cl_aunit_assert=>assert_equals( act = containsall exp = abap_false ).
endmethod.                    "containsall


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->GET
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get.
  data element type ref to zcl_object.
  element = tested_arraylist->get( 0 ).
  cl_aunit_assert=>assert_equals( act = element exp = element1 ).
  element = tested_arraylist->get( 1 ).
  cl_aunit_assert=>assert_equals( act = element exp = element2 ).
  element = tested_arraylist->get( 2 ).
  cl_aunit_assert=>assert_equals( act = element exp = element3 ).
endmethod.                    "get


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->INDEXOF
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method indexof.
  data index type i.
  index = tested_arraylist->indexof( element1 ).
  cl_aunit_assert=>assert_equals( act = index exp = 0 ).
  index = tested_arraylist->indexof( element2 ).
  cl_aunit_assert=>assert_equals( act = index exp = 1 ).
  index = tested_arraylist->indexof( element3 ).
  cl_aunit_assert=>assert_equals( act = index exp = 2 ).
endmethod.                    "indexof


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->ISEMPTY
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method isempty.
  data isempty type abap_bool.
  isempty = tested_arraylist->isempty( ).
  cl_aunit_assert=>assert_equals( act = isempty exp = abap_false ).
  tested_arraylist->clear( ).
  isempty = tested_arraylist->isempty( ).
  cl_aunit_assert=>assert_equals( act = isempty exp = abap_true ).
endmethod.                    "isempty


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->ITERATOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method iterator.
  data counter type i.
  data iterator type ref to zif_iterator.
  iterator = tested_arraylist->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data element type ref to zcl_object.
    element = iterator->next( ).
    case counter.
      when 0.
        cl_aunit_assert=>assert_equals( act = element exp = element1 ).
      when 1.
        cl_aunit_assert=>assert_equals( act = element exp = element2 ).
      when 2.
        cl_aunit_assert=>assert_equals( act = element exp = element3 ).
      when others.
        cl_aunit_assert=>fail( ).
    endcase.
    counter = counter + 1.
  endwhile.
endmethod.                    "iterator


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->LASTINDEXOF
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method lastindexof.
  data index type i.
  index = tested_arraylist->lastindexof( element1 ).
  cl_aunit_assert=>assert_equals( act = index exp = 0 ).
  tested_arraylist->add( element1 ).
  index = tested_arraylist->lastindexof( element1 ).
  cl_aunit_assert=>assert_equals( act = index exp = 3 ).
endmethod.                    "lastindexof


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->LISTITERATOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method listiterator.
  data counter type i.
  data iterator type ref to zif_listiterator.
  iterator = tested_arraylist->listiterator( ).
  while iterator->hasnext( ) = abap_true.
    data element type ref to zcl_object.
    element = iterator->next( ).
    case counter.
      when 0.
        cl_aunit_assert=>assert_equals( act = element exp = element1 ).
      when 1.
        cl_aunit_assert=>assert_equals( act = element exp = element2 ).
      when 2.
        cl_aunit_assert=>assert_equals( act = element exp = element3 ).
      when others.
        cl_aunit_assert=>fail( ).
    endcase.
    counter = counter + 1.
  endwhile.
endmethod.                    "listiterator


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->LISTITERATORAT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method listiteratorat.
  data counter type i.
  data iterator type ref to zif_listiterator.
  iterator = tested_arraylist->listiteratorat( 1 ).
  while iterator->hasnext( ) = abap_true.
    data element type ref to zcl_object.
    element = iterator->next( ).
    case counter.
      when 0.
        cl_aunit_assert=>assert_equals( act = element exp = element2 ).
      when 1.
        cl_aunit_assert=>assert_equals( act = element exp = element3 ).
      when others.
        cl_aunit_assert=>fail( ).
    endcase.
    counter = counter + 1.
  endwhile.
endmethod.                    "listiteratorat


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->REMOVE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method remove.
  data size type i.
  data element type ref to zcl_object.
  data isremoved type abap_bool.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
  isremoved = tested_arraylist->remove( element1 ).
  cl_aunit_assert=>assert_equals( act = isremoved exp = abap_true ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 2 ).
  element = tested_arraylist->get( 0 ).
  cl_aunit_assert=>assert_equals( act = element exp = element2 ).
  isremoved = tested_arraylist->remove( element2 ).
  cl_aunit_assert=>assert_equals( act = isremoved exp = abap_true ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 1 ).
  element = tested_arraylist->get( 0 ).
  cl_aunit_assert=>assert_equals( act = element exp = element3 ).
  isremoved = tested_arraylist->remove( element3 ).
  cl_aunit_assert=>assert_equals( act = isremoved exp = abap_true ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 0 ).
endmethod.                    "remove


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->REMOVEALL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method removeall.
  data size type i.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
  data elements type ref to zcl_arraylist.
  create object elements.
  elements->add( element1 ).
  elements->add( element2 ).
  tested_arraylist->removeall( elements ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 1 ).
  data element type ref to zcl_object.
  element = tested_arraylist->get( 0 ).
  cl_aunit_assert=>assert_equals( act = element exp = element3 ).
endmethod.                    "removeall


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->REMOVEAT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method removeat.
  data size type i.
  data element type ref to zcl_object.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
  element = tested_arraylist->removeat( 1 ).
  cl_aunit_assert=>assert_equals( act = element exp = element2 ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 2 ).
  element = tested_arraylist->removeat( 1 ).
  cl_aunit_assert=>assert_equals( act = element exp = element3 ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 1 ).
  element = tested_arraylist->removeat( 0 ).
  cl_aunit_assert=>assert_equals( act = element exp = element1 ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 0 ).
endmethod.                    "removeat


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->RETAINALL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method retainall.
  data size type i.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
  data elements type ref to zcl_arraylist.
  create object elements.
  elements->add( element1 ).
  elements->add( element3 ).
  tested_arraylist->retainall( elements ).
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 2 ).
  data element type ref to zcl_object.
  element = tested_arraylist->get( 0 ).
  cl_aunit_assert=>assert_equals( act = element exp = element1 ).
  element = tested_arraylist->get( 1 ).
  cl_aunit_assert=>assert_equals( act = element exp = element3 ).
endmethod.                    "retainall


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->SET
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method set.
  data element type ref to zcl_object.
  element = tested_arraylist->get( 1 ).
  cl_aunit_assert=>assert_equals( act = element exp = element2 ).
  tested_arraylist->set( index = 1 element = element3 ).
  element = tested_arraylist->get( 1 ).
  cl_aunit_assert=>assert_equals( act = element exp = element3 ).
endmethod.                    "set


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_UT_ARRAYLIST->SETUP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method setup.
  create object element1.
  create object element2.
  create object element3.
  create object tested_arraylist.
  tested_arraylist->add( element1 ).
  tested_arraylist->add( element2 ).
  tested_arraylist->add( element3 ).
endmethod.                    "setup


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->SIZE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method size.
  data size type i.
  size = tested_arraylist->size( ).
  cl_aunit_assert=>assert_equals( act = size exp = 3 ).
endmethod.                    "size


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UT_ARRAYLIST->TOARRAY
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method toarray.
  data testarray type zarray.
  append element1 to testarray.
  append element2 to testarray.
  append element3 to testarray.
  data array type zarray.
  array = tested_arraylist->toarray( ).
  cl_aunit_assert=>assert_equals( act = testarray exp = array ).
endmethod.                    "toarray
ENDCLASS.
