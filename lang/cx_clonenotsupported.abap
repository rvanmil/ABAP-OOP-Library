class CX_CLONENOTSUPPORTED definition
  public
  inheriting from CX_RUNTIMEEXCEPTION
  final
  create public .

public section.

  constants CX_CLONENOTSUPPORTED type SOTR_CONC value '00155D334B0D1EE2B8FD3A94F7EE2991'. "#EC NOTEXT

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !MESSAGE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS CX_CLONENOTSUPPORTED IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CX_CLONENOTSUPPORTED->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] TEXTID                         LIKE        TEXTID(optional)
* | [--->] PREVIOUS                       LIKE        PREVIOUS(optional)
* | [--->] MESSAGE                        TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
MESSAGE = MESSAGE
.
 IF textid IS INITIAL.
   me->textid = CX_CLONENOTSUPPORTED .
 ENDIF.
endmethod.
ENDCLASS.
