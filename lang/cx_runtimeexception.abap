class CX_RUNTIMEEXCEPTION definition
  public
  inheriting from CX_NO_CHECK
  create public .

public section.

  constants CX_RUNTIMEEXCEPTION type SOTR_CONC value '00155D334B0D1EE2B8FD2B3F667A8991'. "#EC NOTEXT
  data MESSAGE type STRING read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !MESSAGE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS CX_RUNTIMEEXCEPTION IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CX_RUNTIMEEXCEPTION->CONSTRUCTOR
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
.
 IF textid IS INITIAL.
   me->textid = CX_RUNTIMEEXCEPTION .
 ENDIF.
me->MESSAGE = MESSAGE .
endmethod.
ENDCLASS.
