class CL_OBJECT definition
  public
  create public .

public section.
*"* public components of class CL_OBJECT
*"* do not include other source files here!!!
  type-pools ABAP .

  methods CLONE
    returning
      value(RETURNING) type ref to CL_OBJECT .
  methods EQUALS
    importing
      !OBJ type ref to CL_OBJECT
    returning
      value(RETURNING) type ABAP_BOOL .
  methods GETCLASS
  final
    returning
      value(RETURNING) type ref to CL_ABAP_OBJECTDESCR .
protected section.
*"* protected components of class CL_OBJECT
*"* do not include other source files here!!!
private section.
*"* private components of class CL_OBJECT
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_OBJECT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_OBJECT->CLONE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO CL_OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method clone.
  raise exception type cx_clonenotsupported.

  " Any implementation of this method MUST follow these rules:
  " - TRUE:   x->clone( ) <> x
  " - TRUE:   x->clone( )->getclass( ) = x->getclass( )
  " - TRUE:   x->clone( )->equals( x )
  " - The clone object should be independent of the original object, which means
  "   you must also clone all mutable objects which comprise the internal "deep structure"
  "   of the object being cloned.
  " - In case of arrays only the array object must be cloned and not the objects inside
  "   the array, resulting in a "shallow copy"
  "
  " IMPORTANT
  " This method does NOT behave like it does in Java.
  " The difference is, it will NEVER return an instance of an object (in Java, when a class
  " implements the Cloneable interface, this method will return an instance of that class).
  " This means you CANNOT rely on calling super->clone( ) to get an instance,
  " if none of the superclasses implement the clone( ) method.
  " In practice, this means you will have to create the instance yourself if you want to
  " make your objects cloneable. In the case of abstract classes this won't be possible,
  " which means you cannot use super->clone( ) and you have to write an implementation in
  " each concrete subclass.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_OBJECT->EQUALS
* +-------------------------------------------------------------------------------------------------+
* | [--->] OBJ                            TYPE REF TO CL_OBJECT
* | [<-()] RETURNING                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
method equals.
  " Only compare reference by default
  if me = obj.
    returning = abap_true.
    return.
  else.
    returning = abap_false.
    return.
  endif.

  " Override this method to implement a more specific comparison.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_OBJECT->GETCLASS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETURNING                      TYPE REF TO CL_ABAP_OBJECTDESCR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method getclass.
  returning ?= cl_abap_typedescr=>describe_by_object_ref( me ).
endmethod.
ENDCLASS.
