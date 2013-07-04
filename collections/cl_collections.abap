class CL_COLLECTIONS definition
  public
  inheriting from CL_OBJECT
  final
  create private .

public section.

*"* public components of class CL_COLLECTIONS
*"* do not include other source files here!!!
  class-methods UNMODIFIABLELIST
    importing
      !LIST type ref to IF_LIST
    returning
      value(RETURNING) type ref to IF_LIST .
protected section.
*"* protected components of class CL_COLLECTIONS
*"* do not include other source files here!!!
private section.
*"* private components of class CL_COLLECTIONS
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_COLLECTIONS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_COLLECTIONS=>UNMODIFIABLELIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] LIST                           TYPE REF TO IF_LIST
* | [<-()] RETURNING                      TYPE REF TO IF_LIST
* +--------------------------------------------------------------------------------------</SIGNATURE>
method unmodifiablelist.
  data unmodifiablelist type ref to lcl_unmodifiablelist.
  create object unmodifiablelist
    exporting
      list = list.
  returning = unmodifiablelist.
endmethod.
ENDCLASS.
