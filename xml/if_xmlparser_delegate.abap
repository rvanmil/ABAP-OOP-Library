interface IF_XMLPARSER_DELEGATE
  public .


  methods PARSER_DID_START_DOCUMENT
    importing
      !PARSER type ref to CL_XMLPARSER .
  methods PARSER_DID_END_DOCUMENT
    importing
      !PARSER type ref to CL_XMLPARSER .
  methods PARSER_DID_START_ELEMENT
    importing
      !PARSER type ref to CL_XMLPARSER
      !ELEMENTNAME type STRING .
  methods PARSER_DID_END_ELEMENT
    importing
      !PARSER type ref to CL_XMLPARSER
      !ELEMENTNAME type STRING .
  methods PARSER_FOUND_CHARACTERS
    importing
      !PARSER type ref to CL_XMLPARSER
      !CHARACTERS type STRING .
  methods PARSER_FOUND_COMMENT
    importing
      !PARSER type ref to CL_XMLPARSER
      !COMMENT type STRING .
  methods PARSER_ERROR_OCCURRED
    importing
      !PARSER type ref to CL_XMLPARSER
      !ERROR type I .
endinterface.
