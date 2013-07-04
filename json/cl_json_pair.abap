class CL_JSON_PAIR definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_JSON_PAIR
*"* do not include other source files here!!!
  data NAME type ref to CL_JSON_STRING read-only .
  data VALUE type ref to IF_JSON_VALUE read-only .

  methods CONSTRUCTOR
    importing
      !NAME type ref to CL_JSON_STRING
      !VALUE type ref to IF_JSON_VALUE .
protected section.
*"* protected components of class CL_JSON_PAIR
*"* do not include other source files here!!!
private section.
*"* private components of class CL_JSON_PAIR
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_JSON_PAIR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_PAIR->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE REF TO CL_JSON_STRING
* | [--->] VALUE                          TYPE REF TO IF_JSON_VALUE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  me->name = name.
  me->value = value.
endmethod.
ENDCLASS.
