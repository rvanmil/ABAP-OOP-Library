class CL_JSON_NUMBER definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_JSON_NUMBER
*"* do not include other source files here!!!
  interfaces IF_JSON_VALUE .

  aliases GET_TYPE
    for IF_JSON_VALUE~GET_TYPE .

  data VALUE type F read-only .

  methods CONSTRUCTOR
    importing
      !VALUE type F .
protected section.
*"* protected components of class CL_JSON_NUMBER
*"* do not include other source files here!!!
private section.
*"* private components of class CL_JSON_NUMBER
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_JSON_NUMBER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_NUMBER->IF_JSON_VALUE~GET_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_json_value~get_type.
  returning = cl_json_types=>type_number.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_NUMBER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        F
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  me->value = value.
endmethod.
ENDCLASS.
