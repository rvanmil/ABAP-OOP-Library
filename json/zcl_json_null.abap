class ZCL_JSON_NULL definition
  public
  inheriting from ZCL_OBJECT
  final
  create public .

public section.

*"* public components of class zCL_JSON_NULL
*"* do not include other source files here!!!
  interfaces ZIF_JSON_VALUE .
protected section.
*"* protected components of class zCL_JSON_NULL
*"* do not include other source files here!!!
private section.
*"* private components of class zCL_JSON_NULL
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_JSON_NULL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_JSON_NULL->ZIF_JSON_VALUE~GET_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_json_value~get_type.
  returning = zcl_json_types=>type_null.
endmethod.
ENDCLASS.
