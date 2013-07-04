class CL_JSON_STRING definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_JSON_STRING
*"* do not include other source files here!!!
  interfaces IF_JSON_VALUE .

  aliases GET_TYPE
    for IF_JSON_VALUE~GET_TYPE .

  data VALUE type STRING read-only .

  methods CONSTRUCTOR
    importing
      !VALUE type STRING .
protected section.
*"* protected components of class CL_JSON_STRING
*"* do not include other source files here!!!
private section.
*"* private components of class CL_JSON_STRING
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_JSON_STRING IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_STRING->IF_JSON_VALUE~GET_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_json_value~get_type.
  returning = cl_json_types=>type_string.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_STRING->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  me->value = value.
endmethod.
ENDCLASS.
