class CL_JSON_BOOLEAN definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.
*"* public components of class CL_JSON_BOOLEAN
*"* do not include other source files here!!!
  type-pools ABAP .

  interfaces IF_JSON_VALUE .

  aliases GET_TYPE
    for IF_JSON_VALUE~GET_TYPE .

  data VALUE type ABAP_BOOL read-only .

  methods CONSTRUCTOR
    importing
      !VALUE type ABAP_BOOL .
protected section.
*"* protected components of class CL_JSON_BOOLEAN
*"* do not include other source files here!!!
private section.
*"* private components of class CL_JSON_BOOLEAN
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_JSON_BOOLEAN IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_BOOLEAN->IF_JSON_VALUE~GET_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method if_json_value~get_type.
  returning = cl_json_types=>type_boolean.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_JSON_BOOLEAN->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  super->constructor( ).
  me->value = value.
endmethod.
ENDCLASS.
