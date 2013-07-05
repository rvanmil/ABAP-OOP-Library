class ZCX_STATICEXCEPTION definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  constants ZCX_STATICEXCEPTION type SOTR_CONC value '00155D334B0D1EE2B8FD2F95F2326991'. "#EC NOTEXT
  data MESSAGE type STRING read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !MESSAGE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_STATICEXCEPTION IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCX_STATICEXCEPTION->CONSTRUCTOR
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
   me->textid = ZCX_STATICEXCEPTION .
 ENDIF.
me->MESSAGE = MESSAGE .
endmethod.
ENDCLASS.
