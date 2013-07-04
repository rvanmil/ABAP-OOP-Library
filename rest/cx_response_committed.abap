class CX_RESPONSE_COMMITTED definition
  public
  inheriting from CX_RUNTIMEEXCEPTION
  final
  create public .

public section.

  constants CX_RESPONSE_COMMITTED type SOTR_CONC value '00155D334B0D1EE2B982627F94832991'. "#EC NOTEXT

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !MESSAGE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS CX_RESPONSE_COMMITTED IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CX_RESPONSE_COMMITTED->CONSTRUCTOR
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
   me->textid = CX_RESPONSE_COMMITTED .
 ENDIF.
endmethod.
ENDCLASS.
