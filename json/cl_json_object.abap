class CL_JSON_OBJECT definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_JSON_OBJECT
*"* do not include other source files here!!!
  interfaces IF_JSON_VALUE .

  aliases GET_TYPE
    for IF_JSON_VALUE~GET_TYPE .

  methods CONSTRUCTOR .
  methods ADD
    importing
      !PAIR type ref to CL_JSON_PAIR
    returning
      value(RETURNING) type ABAP_BOOL .
  methods CLEAR .
  methods GET
    importing
      !INDEX type I
    returning
      value(RETURNING) type ref to CL_JSON_PAIR .
  methods ITERATOR
    returning
      value(RETURNING) type ref to IF_ITERATOR .
  methods REMOVE
    importing
      !PAIR type ref to CL_JSON_PAIR
    returning
      value(RETURNING) type ABAP_BOOL .
  methods SET
    importing
      !INDEX type I
      !PAIR type ref to CL_JSON_PAIR
    returning
      value(RETURNING) type ref to CL_JSON_PAIR .
  methods SIZE
    returning
      value(RETURNING) type I .
protected section.
*"* protected components of class CL_JSON_OBJECT
*"* do not include other source files here!!!
private section.

*"* private components of class CL_JSON_OBJECT
*"* do not include other source files here!!!
  data PAIRS type ref to CL_ARRAYLIST .
ENDCLASS.



CLASS CL_JSON_OBJECT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_OBJECT->IF_JSON_VALUE~GET_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_json_value~get_type.
  returning = cl_json_types=>type_object.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_OBJECT->ADD
* +-------------------------------------------------------------------------------------------------+
* | [--->] PAIR                           TYPE REF TO CL_JSON_PAIR
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method add.
  data object type ref to cl_object.
  object = pair.
  returning = me->pairs->add( object ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_OBJECT->CLEAR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method clear.
  me->pairs->clear( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_OBJECT->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  " Init pairs list
  create object me->pairs.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_OBJECT->GET
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [<-()] RETURNING                      TYPE REF TO CL_JSON_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get.
  returning ?= me->pairs->get( index ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_OBJECT->ITERATOR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO IF_ITERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method iterator.
  returning = me->pairs->iterator( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_OBJECT->REMOVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] PAIR                           TYPE REF TO CL_JSON_PAIR
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method remove.
  data object type ref to cl_object.
  object = pair.
  returning = me->pairs->remove( object ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_OBJECT->SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] INDEX                          TYPE        I
* | [--->] PAIR                           TYPE REF TO CL_JSON_PAIR
* | [<-()] RETURNING                      TYPE REF TO CL_JSON_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method set.
  data object type ref to cl_object.
  object = pair.
  returning ?= me->pairs->set( index = index element = object ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_OBJECT->SIZE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method size.
  returning = me->pairs->size( ).
endmethod.
ENDCLASS.
