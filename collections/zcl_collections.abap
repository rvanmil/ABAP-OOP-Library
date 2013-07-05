class ZCL_COLLECTIONS definition
  public
  inheriting from ZCL_OBJECT
  final
  create private .

public section.

*"* public components of class zCL_COLLECTIONS
*"* do not include other source files here!!!
  class-methods UNMODIFIABLELIST
    importing
      !LIST type ref to ZIF_LIST
    returning
      value(RETURNING) type ref to ZIF_LIST .
protected section.
*"* protected components of class zCL_COLLECTIONS
*"* do not include other source files here!!!
private section.
*"* private components of class zCL_COLLECTIONS
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_COLLECTIONS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_COLLECTIONS=>UNMODIFIABLELIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] LIST                           TYPE REF TO ZIF_LIST
* | [<-()] RETURNING                      TYPE REF TO ZIF_LIST
* +--------------------------------------------------------------------------------------</SIGNATURE>
method unmodifiablelist.
  data unmodifiablelist type ref to lcl_unmodifiablelist.
  create object unmodifiablelist
    exporting
      list = list.
  returning = unmodifiablelist.
endmethod.
ENDCLASS.
