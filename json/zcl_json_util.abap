class ZCL_JSON_UTIL definition
  public
  inheriting from ZCL_OBJECT
  final
  create public .

public section.
  type-pools ABAP .

*"* public components of class zCL_JSON_UTIL
*"* do not include other source files here!!!
  class-methods NEW_OBJECT_WITH_ARRAY_PAIR
    importing
      !NAME type STRING
      !VALUE type ref to ZCL_JSON_ARRAY
    returning
      value(RETURNING) type ref to ZCL_JSON_OBJECT .
  class-methods NEW_OBJECT_WITH_BOOL_PAIR
    importing
      !NAME type STRING
      !VALUE type ABAP_BOOL
    returning
      value(RETURNING) type ref to ZCL_JSON_OBJECT .
  class-methods NEW_OBJECT_WITH_NULL_PAIR
    importing
      !NAME type STRING
    returning
      value(RETURNING) type ref to ZCL_JSON_OBJECT .
  class-methods NEW_OBJECT_WITH_NUMBER_PAIR
    importing
      !NAME type STRING
      !VALUE type F
    returning
      value(RETURNING) type ref to ZCL_JSON_OBJECT .
  class-methods NEW_OBJECT_WITH_OBJECT_PAIR
    importing
      !NAME type STRING
      !VALUE type ref to ZCL_JSON_OBJECT
    returning
      value(RETURNING) type ref to ZCL_JSON_OBJECT .
  class-methods NEW_OBJECT_WITH_STRING_PAIR
    importing
      !NAME type STRING
      !VALUE type STRING
    returning
      value(RETURNING) type ref to ZCL_JSON_OBJECT .
  class-methods NEW_PAIR_WITH_ARRAY
    importing
      !NAME type STRING
      !VALUE type ref to ZCL_JSON_ARRAY
    returning
      value(RETURNING) type ref to ZCL_JSON_PAIR .
  class-methods NEW_PAIR_WITH_BOOL
    importing
      !NAME type STRING
      !VALUE type ABAP_BOOL
    returning
      value(RETURNING) type ref to ZCL_JSON_PAIR .
  class-methods NEW_PAIR_WITH_NULL
    importing
      !NAME type STRING
    returning
      value(RETURNING) type ref to ZCL_JSON_PAIR .
  class-methods NEW_PAIR_WITH_NUMBER
    importing
      !NAME type STRING
      !VALUE type F
    returning
      value(RETURNING) type ref to ZCL_JSON_PAIR .
  class-methods NEW_PAIR_WITH_OBJECT
    importing
      !NAME type STRING
      !VALUE type ref to ZCL_JSON_OBJECT
    returning
      value(RETURNING) type ref to ZCL_JSON_PAIR .
  class-methods NEW_PAIR_WITH_STRING
    importing
      !NAME type STRING
      !VALUE type STRING
    returning
      value(RETURNING) type ref to ZCL_JSON_PAIR .
protected section.
*"* protected components of class zCL_JSON_UTIL
*"* do not include other source files here!!!
private section.
*"* private components of class zCL_JSON_UTIL
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_JSON_UTIL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_OBJECT_WITH_ARRAY_PAIR
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE REF TO ZCL_JSON_ARRAY
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_object_with_array_pair.
  data json_obj type ref to zcl_json_object.
  data json_pair type ref to zcl_json_pair.
  create object json_obj.
  json_pair = new_pair_with_array( name = name value = value ).
  json_obj->add( json_pair ).
  returning = json_obj.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_OBJECT_WITH_BOOL_PAIR
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE        ABAP_BOOL
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_object_with_bool_pair.
  data json_obj type ref to zcl_json_object.
  data json_pair type ref to zcl_json_pair.
  create object json_obj.
  json_pair = new_pair_with_bool( name = name value = value ).
  json_obj->add( json_pair ).
  returning = json_obj.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_OBJECT_WITH_NULL_PAIR
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_object_with_null_pair.
  data json_obj type ref to zcl_json_object.
  data json_pair type ref to zcl_json_pair.
  create object json_obj.
  json_pair = new_pair_with_null( name = name ).
  json_obj->add( json_pair ).
  returning = json_obj.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_OBJECT_WITH_NUMBER_PAIR
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE        F
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_object_with_number_pair.
  data json_obj type ref to zcl_json_object.
  data json_pair type ref to zcl_json_pair.
  create object json_obj.
  json_pair = new_pair_with_number( name = name value = value ).
  json_obj->add( json_pair ).
  returning = json_obj.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_OBJECT_WITH_OBJECT_PAIR
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE REF TO ZCL_JSON_OBJECT
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_object_with_object_pair.
  data json_obj type ref to zcl_json_object.
  data json_pair type ref to zcl_json_pair.
  create object json_obj.
  json_pair = new_pair_with_object( name = name value = value ).
  json_obj->add( json_pair ).
  returning = json_obj.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_OBJECT_WITH_STRING_PAIR
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE        STRING
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_object_with_string_pair.
  data json_obj type ref to zcl_json_object.
  data json_pair type ref to zcl_json_pair.
  create object json_obj.
  json_pair = new_pair_with_string( name = name value = value ).
  json_obj->add( json_pair ).
  returning = json_obj.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_PAIR_WITH_ARRAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE REF TO ZCL_JSON_ARRAY
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_pair_with_array.
  data pair type ref to zcl_json_pair.
  data pair_name type ref to zcl_json_string.
  create object pair_name
    exporting
      value = name.
  create object pair
    exporting
      name  = pair_name
      value = value.
  returning = pair.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_PAIR_WITH_BOOL
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE        ABAP_BOOL
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_pair_with_bool.
  data pair type ref to zcl_json_pair.
  data pair_name type ref to zcl_json_string.
  data pair_value type ref to zcl_json_boolean.
  create object pair_name
    exporting
      value = name.
  create object pair_value
    exporting
      value = value.
  create object pair
    exporting
      name  = pair_name
      value = pair_value.
  returning = pair.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_PAIR_WITH_NULL
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_pair_with_null.
  data pair type ref to zcl_json_pair.
  data pair_name type ref to zcl_json_string.
  data pair_value type ref to zcl_json_null.
  create object pair_name
    exporting
      value = name.
  create object pair_value.
  create object pair
    exporting
      name  = pair_name
      value = pair_value.
  returning = pair.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_PAIR_WITH_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE        F
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_pair_with_number.
  data pair type ref to zcl_json_pair.
  data pair_name type ref to zcl_json_string.
  data pair_value type ref to zcl_json_number.
  create object pair_name
    exporting
      value = name.
  create object pair_value
    exporting
      value = value.
  create object pair
    exporting
      name  = pair_name
      value = pair_value.
  returning = pair.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_PAIR_WITH_OBJECT
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE REF TO ZCL_JSON_OBJECT
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_pair_with_object.
  data pair type ref to zcl_json_pair.
  data pair_name type ref to zcl_json_string.
  create object pair_name
    exporting
      value = name.
  create object pair
    exporting
      name  = pair_name
      value = value.
  returning = pair.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_UTIL=>NEW_PAIR_WITH_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] NAME                           TYPE        STRING
* | [--->] VALUE                          TYPE        STRING
* | [<-()] RETURNING                      TYPE REF TO ZCL_JSON_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method new_pair_with_string.
  data pair type ref to zcl_json_pair.
  data pair_name type ref to zcl_json_string.
  data pair_value type ref to zcl_json_string.
  create object pair_name
    exporting
      value = name.
  create object pair_value
    exporting
      value = value.
  create object pair
    exporting
      name  = pair_name
      value = pair_value.
  returning = pair.
endmethod.
ENDCLASS.
