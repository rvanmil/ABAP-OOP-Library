class ZCL_JSON_BOOLEAN definition
  public
  inheriting from ZCL_OBJECT
  final
  create public .

public section.
*"* public components of class zCL_JSON_BOOLEAN
*"* do not include other source files here!!!
  type-pools ABAP .

  interfaces ZIF_JSON_VALUE .

  aliases GET_TYPE
    for ZIF_JSON_VALUE~GET_TYPE .

  data VALUE type ABAP_BOOL read-only .

  methods CONSTRUCTOR
    importing
      !VALUE type ABAP_BOOL .
protected section.
*"* protected components of class zCL_JSON_BOOLEAN
*"* do not include other source files here!!!
private section.
*"* private components of class zCL_JSON_BOOLEAN
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_JSON_BOOLEAN IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_JSON_BOOLEAN->ZIF_JSON_VALUE~GET_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method zif_json_value~get_type.
  returning = zcl_json_types=>type_boolean.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_JSON_BOOLEAN->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  me->value = value.
endmethod.
ENDCLASS.
