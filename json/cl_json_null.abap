class CL_JSON_NULL definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_JSON_NULL
*"* do not include other source files here!!!
  interfaces IF_JSON_VALUE .
protected section.
*"* protected components of class CL_JSON_NULL
*"* do not include other source files here!!!
private section.
*"* private components of class CL_JSON_NULL
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_JSON_NULL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_NULL->IF_JSON_VALUE~GET_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_json_value~get_type.
  returning = cl_json_types=>type_null.
endmethod.
ENDCLASS.
