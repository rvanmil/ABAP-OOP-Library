class ZCL_JSON_PARSER definition
  public
  inheriting from ZCL_OBJECT
  final
  create public .

public section.

*"* public components of class zCL_JSON_PARSER
*"* do not include other source files here!!!
  constants JSON_TOKEN_ARRAY_START type C value '['. "#EC NOTEXT
  constants JSON_TOKEN_ARRAY_END type C value ']'. "#EC NOTEXT
  constants JSON_TOKEN_OBJECT_START type C value '{'. "#EC NOTEXT
  constants JSON_TOKEN_OBJECT_END type C value '}'. "#EC NOTEXT
  constants JSON_TOKEN_NAME_VAL_SEPARATOR type C value ':'. "#EC NOTEXT
  constants JSON_TOKEN_VALUE_SEPARATOR type C value ','. "#EC NOTEXT
  constants JSON_TOKEN_STRING type C value '"'. "#EC NOTEXT
  constants JSON_TOKEN_ESCAPE type C value '\'. "#EC NOTEXT

  class-methods CLASS_CONSTRUCTOR .
  class-methods UTF8_BYTE_VALUE
    importing
      !CHAR type CHAR1
    returning
      value(RETURNING) type XSTRING .
  methods DESERIALIZE
    importing
      !JSON_STRING type STRING
    returning
      value(RETURNING) type ref to ZIF_JSON_VALUE
    raising
      ZCX_JSON_PARSE_ERROR .
  methods SERIALIZE
    importing
      !JSON_VALUE type ref to ZIF_JSON_VALUE
    returning
      value(RETURNING) type STRING .
protected section.
*"* protected components of class zCL_JSON_PARSER
*"* do not include other source files here!!!
private section.

*"* private components of class zCL_JSON_PARSER
*"* do not include other source files here!!!
  class-data UTF8_CONVERTER type ref to CL_ABAP_CONV_OUT_CE .

  methods JSON_ARRAY_TO_STRING
    importing
      !JSON_ARRAY type ref to ZCL_JSON_ARRAY
    returning
      value(RETURNING) type STRING .
  methods JSON_BOOLEAN_TO_STRING
    importing
      !JSON_BOOLEAN type ref to ZCL_JSON_BOOLEAN
    returning
      value(RETURNING) type STRING .
  methods JSON_NUMBER_TO_STRING
    importing
      !JSON_NUMBER type ref to ZCL_JSON_NUMBER
    returning
      value(RETURNING) type STRING .
  methods JSON_OBJECT_TO_STRING
    importing
      !JSON_OBJECT type ref to ZCL_JSON_OBJECT
    returning
      value(RETURNING) type STRING .
  methods JSON_STRING_TO_STRING
    importing
      !JSON_STRING type ref to ZCL_JSON_STRING
    returning
      value(RETURNING) type STRING .
  methods _SUBSTRING
    importing
      !THESTRING type STRING
      !BEGININDEX type I
      !ENDINDEX type I optional
    returning
      value(RETURNING) type STRING .
ENDCLASS.



CLASS ZCL_JSON_PARSER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_PARSER=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method class_constructor.
  utf8_converter = cl_abap_conv_out_ce=>create( encoding = 'UTF-8' ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_JSON_PARSER->DESERIALIZE
* +-------------------------------------------------------------------------------------------------+
* | [--->] JSON_STRING                    TYPE        STRING
* | [<-()] RETURNING                      TYPE REF TO ZIF_JSON_VALUE
* | [!CX!] ZCX_JSON_PARSE_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method deserialize.
  data msg type string.

  data result type ref to zif_json_value.
  data parent type ref to zif_json_value.
  data state type c.
  data state_stack type standard table of c.
  data value_stack type standard table of ref to zif_json_value.
  data stack_depth type i value 1.
  data position type i value 0.

  " Helper variables
  data parent_object type ref to zcl_json_object.
  data parent_array type ref to zcl_json_array.
  data json_pair type ref to zcl_json_pair.
  data json_pair_name type ref to zif_json_value.
  data json_pair_name_string type ref to zcl_json_string.

  " The main loop; process each character in the received JSON string
  data limit type i.
  limit = strlen( json_string ).
  while position < limit.
    " Get the character at the current position
    data char type c.
    data byte_value type xstring.
    char = json_string+position(1).
    byte_value = me->utf8_byte_value( char ).

    " Ignore spaces and control characters
    if byte_value <= '20' or
       ( byte_value >= '7F' and byte_value <= 'C2A0' ).
      position = position + 1.
      continue.
    endif.

    " Process the character
    case char.

      when json_token_object_start. " Start of object
        insert state into state_stack index stack_depth.
        insert parent into value_stack index stack_depth.
        stack_depth = stack_depth + 1.
        create object parent type zcl_json_object.
        clear result.
        state = char.

      when json_token_object_end. " End of object
        if state = json_token_name_val_separator.
          " End of object reached and state is a name/value separator
          " This means the parent is an object and the result is a value
          " It also means the value stack has a string (name) on top
          " - Get the pair name
          stack_depth = stack_depth - 1.
          read table value_stack into json_pair_name index stack_depth.
          json_pair_name_string ?= json_pair_name.
          " - Create the pair
          create object json_pair
            exporting
              name  = json_pair_name_string
              value = result.
          " - Add the pair to the parent
          parent_object ?= parent.
          parent_object->add( json_pair ).
          clear: parent_object, json_pair_name, json_pair_name_string, json_pair.
          " Set state to its previous value
          read table state_stack into state index stack_depth.
        endif.
        if state = json_token_object_start.
          " End of object reached and state is the begin of an object
          " Parent becomes the result (we could be finished here)...
          result = parent.
          " ...and set the parent and state to their previous values
          stack_depth = stack_depth - 1.
          read table state_stack into state index stack_depth.
          read table value_stack into parent index stack_depth.
        else.
          " Can only reach end of object if state is the start of an object
          message e002(zjson) with position json_token_object_end into msg.
          raise exception type zcx_json_parse_error
            exporting
              message = msg.
        endif.

      when json_token_array_start. " Start of array
        insert state into state_stack index stack_depth.
        insert parent into value_stack index stack_depth.
        stack_depth = stack_depth + 1.
        create object parent type zcl_json_array.
        clear result.
        state = char.

      when json_token_array_end. " End of array
        if state = json_token_array_start.
          " End of array reached and state is the start of an array
          " This means the parent is an array and the result is a value
          parent_array ?= parent.
          if result is bound. " Only add the result to the array if its bound
            parent_array->add( result ).
          endif.
          clear parent_array.
          " Parent becomes the result (we could be finished here)...
          result = parent.
          " ...and set the parent and state to their previous values
          stack_depth = stack_depth - 1.
          read table state_stack into state index stack_depth.
          read table value_stack into parent index stack_depth.
        else.
          " Can only reach end of array if state is the start of an array
          message e002(zjson) with position json_token_array_end into msg.
          raise exception type zcx_json_parse_error
            exporting
              message = msg.
        endif.

      when json_token_value_separator. " Value separator
        " Cannot reach a value separator when there is no result yet
        if result is not bound.
          message e002(zjson) with position json_token_value_separator into msg.
          raise exception type zcx_json_parse_error
            exporting
              message = msg.
        endif.
        if state = json_token_name_val_separator.
          " Value separator reached and state is a name/value separator
          " This means the parent is an object and the result is a value
          " It also means the value stack has a string (name) on top
          " - Get the pair name
          stack_depth = stack_depth - 1.
          read table value_stack into json_pair_name index stack_depth.
          json_pair_name_string ?= json_pair_name.
          " - Create the pair
          create object json_pair
            exporting
              name  = json_pair_name_string
              value = result.
          " - Add the pair to the parent
          parent_object ?= parent.
          parent_object->add( json_pair ).
          clear: parent_object, json_pair_name, json_pair_name_string, json_pair.
          " Set state to its previous value
          read table state_stack into state index stack_depth.
          " Clear the result because there should be another value coming after this
          clear result.
        elseif state = json_token_array_start.
          " Value separator reached and state is the start of an array
          " This means the parent is an array and the result is a value
          parent_array ?= parent.
          parent_array->add( result ).
          clear parent_array.
          " Keep state the same while we're inside an array
          " Clear the result because there should be another value coming after this
          clear result.
        else.
          message e002(zjson) with position json_token_value_separator into msg.
          raise exception type zcx_json_parse_error
            exporting
              message = msg.
        endif.

      when json_token_name_val_separator. " Name/value separator
        " Can only reach a name/value separator while we're inside an object
        if state = json_token_object_start.
          " Name/value separator reached and state is the start of an object
          " This means the parent is an object and the result is a string (name)
          insert state into state_stack index stack_depth.
          insert result into value_stack index stack_depth.
          stack_depth = stack_depth + 1.
          state = char.
          " Clear the result because there should be a value coming after this
          clear result.
        else.
          message e002(zjson) with position json_token_name_val_separator into msg.
          raise exception type zcx_json_parse_error
            exporting
              message = msg.
        endif.

      when json_token_string. " String value
        " Process the entire string value before continuing the main loop
        data string_start_position type i.
        data previous_was_json_token_escape type abap_bool.
        data is_escaped_string type abap_bool.
        string_start_position = position + 1. " Skip the first character since it's the string token
        previous_was_json_token_escape = abap_false.
        is_escaped_string = abap_false.
        while position < limit.
          " Get the next character
          position = position + 1.
          char = json_string+position(1).
          byte_value = me->utf8_byte_value( char ).
          " Keep looping until another unescaped string separator is found
          if previous_was_json_token_escape = abap_true.
            previous_was_json_token_escape = abap_false.
            continue.
          elseif char = json_token_escape.
            " The string contains escaped characters
            is_escaped_string = abap_true.
            continue.
          elseif char = json_token_string.
            " End of string reached, get its value by retrieving the substring
            data result_string type string.
            result_string = _substring( thestring = json_string beginindex = string_start_position endindex = position ).
            if is_escaped_string = abap_true.
              " String has escaped characters
              " Use javascript engine to evaluate the string
              data js_processor_string type ref to cl_java_script.
              data script_string type string.
              concatenate `var jsonString = "` result_string `";` into script_string. "#EC NOTEXT
              js_processor_string = cl_java_script=>create( ).
              js_processor_string->compile( script_name = 'evaljsonstring.js' script = script_string ). "#EC NOTEXT
              js_processor_string->execute( script_name = 'evaljsonstring.js' ). "#EC NOTEXT
              result_string = js_processor_string->evaluate( java_script = 'jsonString;' ). "#EC NOTEXT
            endif.
            " Set the json string value as result
            create object result type zcl_json_string
              exporting
                value = result_string.
            exit. " Exit string value loop
          endif.
        endwhile.

      when others.
        " Possible values which don't have an indicator are a number, boolean, or null value
        data end4 type i.
        data substring4 type string.
        end4 = position + 4.
        substring4 = _substring( thestring = json_string beginindex = position endindex = end4 ).
        data end5 type i.
        data substring5 type string.
        end5 = position + 5.
        substring5 = _substring( thestring = json_string beginindex = position endindex = end5 ).
        if ( byte_value >= '30' and byte_value <= '39' ) or " 0,1,2,3,4,5,6,7,8,9
             byte_value = '2B' or byte_value = '2D' or " + -
             byte_value = '2E'. " .
          " Number
          " Process the entire number value before continuing the main loop
          data num_start_position type i.
          num_start_position = position.
          while position < limit.
            " Get the next character
            position = position + 1.
            char = json_string+position(1).
            byte_value = me->utf8_byte_value( char ).
            " Keep looping until anything non-number related is found
            if ( byte_value >= '30' and byte_value <= '39' ) or " 0,1,2,3,4,5,6,7,8,9
               byte_value = '2B' or byte_value = '2D' or " + -
               byte_value = '2E' or " .
               byte_value = '45' or byte_value = '65'. " e E
              " Continue number value loop
              continue.
            else.
              " End of number reached
              exit.
            endif.
          endwhile.
          " Get the number value by retrieving the substring
          data result_num_string type string.
          result_num_string = _substring( thestring = json_string beginindex = num_start_position endindex = position ).
          " Convert the string to a float, simply by assigning it to a variable of type F.
          " This is possible, because the ABAP float notation is identical to
          " the JSON notation (which is amazing really!)
          data result_num type f.
          result_num = result_num_string.
          " Set the json number value as result
          create object result type zcl_json_number
            exporting
              value = result_num.
          " Go back one step, so the main loop can continue with the next char
          position = position - 1.
        elseif substring4 = 'null'.                         "#EC NOTEXT
          " Null
          create object result type zcl_json_null.
          position = position + 3.
        elseif substring4 = 'true'.                         "#EC NOTEXT
          " Boolean, true
          create object result type zcl_json_boolean
            exporting
              value = abap_true.
          position = position + 3.
        elseif substring5 = 'false'.                        "#EC NOTEXT
          " Boolean, false
          create object result type zcl_json_boolean
            exporting
              value = abap_false.
          position = position + 4.
        endif.

    endcase.

    " Continue to next position
    position = position + 1.
  endwhile.

  " Return the result
  returning = result.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_JSON_PARSER->JSON_ARRAY_TO_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] JSON_ARRAY                     TYPE REF TO ZCL_JSON_ARRAY
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method json_array_to_string.
  data string_value type string.
  data is_first type abap_bool.
  data iterator type ref to zif_iterator.
  is_first = abap_true.
  iterator = json_array->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data json_value type ref to zif_json_value.
    json_value ?= iterator->next( ).
    data value type string.
    case json_value->get_type( ).
      when zcl_json_types=>type_string.
        data json_string_value type ref to zcl_json_string.
        json_string_value ?= json_value.
        value = me->json_string_to_string( json_string_value ).
      when zcl_json_types=>type_number.
        data json_number_value type ref to zcl_json_number.
        json_number_value ?= json_value.
        value = me->json_number_to_string( json_number_value ).
      when zcl_json_types=>type_boolean.
        data json_boolean_value type ref to zcl_json_boolean.
        json_boolean_value ?= json_value.
        value = me->json_boolean_to_string( json_boolean_value ).
      when zcl_json_types=>type_null.
        value = `null`.                                     "#EC NOTEXT
      when zcl_json_types=>type_object.
        data json_object_value type ref to zcl_json_object.
        json_object_value ?= json_value.
        value = me->json_object_to_string( json_object_value ).
      when zcl_json_types=>type_array.
        data json_array_value type ref to zcl_json_array.
        json_array_value ?= json_value.
        value = me->json_array_to_string( json_array_value ).
    endcase.
    if is_first = abap_true.
      string_value = value.
      is_first = abap_false.
    else.
      concatenate string_value `, ` value into string_value.
    endif.
  endwhile.
  concatenate `[ ` string_value ` ]` into string_value.
  returning = string_value.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_JSON_PARSER->JSON_BOOLEAN_TO_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] JSON_BOOLEAN                   TYPE REF TO ZCL_JSON_BOOLEAN
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method json_boolean_to_string.
  data value type string.
  if json_boolean->value = abap_true.
    value = 'true'.                                         "#EC NOTEXT
  else.
    value = 'false'.                                        "#EC NOTEXT
  endif.
  returning = value.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_JSON_PARSER->JSON_NUMBER_TO_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] JSON_NUMBER                    TYPE REF TO ZCL_JSON_NUMBER
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method json_number_to_string.
  data value type string.
  value = json_number->value.
  returning = value.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_JSON_PARSER->JSON_OBJECT_TO_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] JSON_OBJECT                    TYPE REF TO ZCL_JSON_OBJECT
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method json_object_to_string.
  data string_value type string.
  data is_first type abap_bool.
  data iterator type ref to zif_iterator.
  is_first = abap_true.
  iterator = json_object->iterator( ).
  while iterator->hasnext( ) = abap_true.
    data json_pair type ref to zcl_json_pair.
    json_pair ?= iterator->next( ).
    " - Name
    data name type string.
    name = me->json_string_to_string( json_pair->name ).
    " - Value
    data json_value type ref to zif_json_value.
    json_value = json_pair->value.
    data value type string.
    case json_value->get_type( ).
      when zcl_json_types=>type_string.
        data json_string_value type ref to zcl_json_string.
        json_string_value ?= json_value.
        value = me->json_string_to_string( json_string_value ).
      when zcl_json_types=>type_number.
        data json_number_value type ref to zcl_json_number.
        json_number_value ?= json_value.
        value = me->json_number_to_string( json_number_value ).
      when zcl_json_types=>type_boolean.
        data json_boolean_value type ref to zcl_json_boolean.
        json_boolean_value ?= json_value.
        value = me->json_boolean_to_string( json_boolean_value ).
      when zcl_json_types=>type_null.
        value = `null`.                                     "#EC NOTEXT
      when zcl_json_types=>type_object.
        data json_object_value type ref to zcl_json_object.
        json_object_value ?= json_value.
        value = me->json_object_to_string( json_object_value ).
      when zcl_json_types=>type_array.
        data json_array_value type ref to zcl_json_array.
        json_array_value ?= json_value.
        value = me->json_array_to_string( json_array_value ).
    endcase.
    if is_first = abap_true.
      concatenate name ` : ` value into string_value.
      is_first = abap_false.
    else.
      concatenate string_value `, ` name ` : ` value into string_value.
    endif.
  endwhile.
  concatenate `{ ` string_value ` }` into string_value.
  returning = string_value.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_JSON_PARSER->JSON_STRING_TO_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] JSON_STRING                    TYPE REF TO ZCL_JSON_STRING
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method json_string_to_string.
  data value type string.
  value = json_string->value.

  " Escape characters according to json spec

  " - Backslashes first so the backslashes added by the other escapes won't be double-escaped
  replace all occurrences of '\' in value with '\\'.
  " - Double quote
  replace all occurrences of '"' in value with '\"'.
  " - Slash
  replace all occurrences of '/' in value with '\/'.

  " Convert the value to UTF-8 bytes, so we can easily find and replace characters which must be escaped
  data converter_out type ref to cl_abap_conv_out_ce.
  converter_out = cl_abap_conv_out_ce=>create( encoding = `UTF-8` ).
  data value_x type xstring.
  converter_out->convert( exporting data = value importing buffer = value_x ).

  " - Backspace
  data backspace_x type x length 1 value `08`.
  data escaped_backspace type string value `\b`.
  data escaped_backspace_x type xstring.
  converter_out->convert( exporting data = escaped_backspace importing buffer = escaped_backspace_x ).
  replace all occurrences of backspace_x in value_x with escaped_backspace_x in byte mode.
  " - Formfeed
  data formfeed_x type x length 1 value `0C`.
  data escaped_formfeed type string value `\f`.
  data escaped_formfeed_x type xstring.
  converter_out->convert( exporting data = escaped_formfeed importing buffer = escaped_formfeed_x ).
  replace all occurrences of formfeed_x in value_x with escaped_formfeed_x in byte mode.
  " - Newline
  data newline_x type x length 1 value `0A`.
  data escaped_newline type string value `\n`.
  data escaped_newline_x type xstring.
  converter_out->convert( exporting data = escaped_newline importing buffer = escaped_newline_x ).
  replace all occurrences of newline_x in value_x with escaped_newline_x in byte mode.
  " - Carriage return
  data carriagereturn_x type x length 1 value `0D`.
  data escaped_carriagereturn type string value `\r`.
  data escaped_carriagereturn_x type xstring.
  converter_out->convert( exporting data = escaped_carriagereturn importing buffer = escaped_carriagereturn_x ).
  replace all occurrences of carriagereturn_x in value_x with escaped_carriagereturn_x in byte mode.
  " - Horizontal tab
  data horizontaltab_x type x length 1 value `09`.
  data escaped_horizontaltab type string value `\t`.
  data escaped_horizontaltab_x type xstring.
  converter_out->convert( exporting data = escaped_horizontaltab importing buffer = escaped_horizontaltab_x ).
  replace all occurrences of horizontaltab_x in value_x with escaped_horizontaltab_x in byte mode.

  " Convert the value back to a UTF-8 string
  data converter_in type ref to cl_abap_conv_in_ce.
  converter_in = cl_abap_conv_in_ce=>create( encoding = `UTF-8` ).
  converter_in->convert( exporting input = value_x importing data = value ).

  " Surround value with double quotes
  concatenate `"` value `"` into value.

  returning = value.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_JSON_PARSER->SERIALIZE
* +-------------------------------------------------------------------------------------------------+
* | [--->] JSON_VALUE                     TYPE REF TO ZIF_JSON_VALUE
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method serialize.
  data value type string.
  case json_value->get_type( ).
    when zcl_json_types=>type_string.
      data json_string_value type ref to zcl_json_string.
      json_string_value ?= json_value.
      value = me->json_string_to_string( json_string_value ).
    when zcl_json_types=>type_number.
      data json_number_value type ref to zcl_json_number.
      json_number_value ?= json_value.
      value = me->json_number_to_string( json_number_value ).
    when zcl_json_types=>type_boolean.
      data json_boolean_value type ref to zcl_json_boolean.
      json_boolean_value ?= json_value.
      value = me->json_boolean_to_string( json_boolean_value ).
    when zcl_json_types=>type_null.
      value = `null`.                                       "#EC NOTEXT
    when zcl_json_types=>type_object.
      data json_object_value type ref to zcl_json_object.
      json_object_value ?= json_value.
      value = me->json_object_to_string( json_object_value ).
    when zcl_json_types=>type_array.
      data json_array_value type ref to zcl_json_array.
      json_array_value ?= json_value.
      value = me->json_array_to_string( json_array_value ).
  endcase.
  returning = value.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JSON_PARSER=>UTF8_BYTE_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [--->] CHAR                           TYPE        CHAR1
* | [<-()] RETURNING                      TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method utf8_byte_value.
  utf8_converter->reset( ).
  utf8_converter->write( data = char ).
  returning = utf8_converter->get_buffer( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_JSON_PARSER->_SUBSTRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] THESTRING                      TYPE        STRING
* | [--->] BEGININDEX                     TYPE        I
* | [--->] ENDINDEX                       TYPE        I(optional)
* | [<-()] RETURNING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _substring.
  data begin type i.
  data end type i.
  if endindex is not supplied.
    end = strlen( thestring ).
  else.
    end = endindex.
  endif.
  if beginindex < 0.
    begin = 0.
  else.
    begin = beginindex.
  endif.
  if end > strlen( thestring ).
    end = strlen( thestring ).
  endif.
  if begin > end.
    return.
  endif.
  data substring type string.
  if begin = 0 and end = strlen( thestring ).
    substring = thestring.
  else.
    data len type i.
    len = end - begin.
    substring = thestring+begin(len).
  endif.
  returning = substring.
endmethod.
ENDCLASS.
