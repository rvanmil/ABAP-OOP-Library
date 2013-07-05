class ZCX_TEXT_CONVERSION_ERROR definition
  public
  inheriting from ZCX_RUNTIMEEXCEPTION
  final
  create public .

public section.

  constants ZCX_TEXT_CONVERSION_ERROR type SOTR_CONC value '00155D334B0D1EE2B9826501204AA991'. "#EC NOTEXT

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !MESSAGE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_TEXT_CONVERSION_ERROR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCX_TEXT_CONVERSION_ERROR->CONSTRUCTOR
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
   me->textid = ZCX_TEXT_CONVERSION_ERROR .
 ENDIF.
endmethod.
ENDCLASS.
