class CX_UNSUPPORTEDOPERATION definition
  public
  inheriting from CX_RUNTIMEEXCEPTION
  final
  create public .

public section.

  constants CX_UNSUPPORTEDOPERATION type SOTR_CONC value '00155D334B0D1EE2B8FD3C3528612991'. "#EC NOTEXT

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !MESSAGE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS CX_UNSUPPORTEDOPERATION IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CX_UNSUPPORTEDOPERATION->CONSTRUCTOR
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
   me->textid = CX_UNSUPPORTEDOPERATION .
 ENDIF.
endmethod.
ENDCLASS.
