class CL_BITWISE definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_BITWISE
*"* do not include other source files here!!!
  class-methods LEFT_SHIFT_X
    importing
      !VALUE type RAW4
      !POSITIONS type I
    returning
      value(RETURNING) type RAW4 .
  class-methods LEFT_SHIFT_I
    importing
      !VALUE type I
      !POSITIONS type I
    returning
      value(RETURNING) type I .
  class-methods RIGHT_SHIFT_X
    importing
      !VALUE type RAW4
      !POSITIONS type I
    returning
      value(RETURNING) type RAW4 .
  class-methods RIGHT_SHIFT_I
    importing
      !VALUE type I
      !POSITIONS type I
    returning
      value(RETURNING) type I .
  class-methods UNSIGNED_RIGHT_SHIFT_X
    importing
      !VALUE type RAW4
      !POSITIONS type I
    returning
      value(RETURNING) type RAW4 .
  class-methods UNSIGNED_RIGHT_SHIFT_I
    importing
      !VALUE type I
      !POSITIONS type I
    returning
      value(RETURNING) type I .
  class-methods ADD_X
    importing
      !A type RAW4
      !B type RAW4
    returning
      value(RETURNING) type RAW4 .
  class-methods ADD_I
    importing
      !A type I
      !B type I
    returning
      value(RETURNING) type I .
  class-methods SUBTRACT_X
    importing
      !A type RAW4
      !B type RAW4
    returning
      value(RETURNING) type RAW4 .
  class-methods SUBTRACT_I
    importing
      !A type I
      !B type I
    returning
      value(RETURNING) type I .
  class-methods MULTIPLY_X
    importing
      !A type RAW4
      !B type RAW4
    returning
      value(RETURNING) type RAW4 .
  class-methods MULTIPLY_I
    importing
      !A type I
      !B type I
    returning
      value(RETURNING) type I .
protected section.
*"* protected components of class CL_BITWISE
*"* do not include other source files here!!!
private section.

  constants:
*"* private components of class CL_BITWISE
*"* do not include other source files here!!!
    H_00000001 type X LENGTH 4 value '00000001'. "#EC NOTEXT
  constants:
    H_3FFFFFFF type X LENGTH 4 value '3FFFFFFF'. "#EC NOTEXT
  constants:
    H_40000000 type X length 4 value '40000000'. "#EC NOTEXT
  constants:
    H_7FFFFFFF type X length 4 value '7FFFFFFF'. "#EC NOTEXT
  constants:
    H_80000000 type X length 4 value '80000000'. "#EC NOTEXT
  constants MIN_INT type I value -2147483648. "#EC NOTEXT
ENDCLASS.



CLASS CL_BITWISE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>ADD_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] A                              TYPE        I
* | [--->] B                              TYPE        I
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method add_i.
  data byte_a type x length 4.
  data byte_b type x length 4.
  byte_a = a.
  byte_b = b.
  returning = add_x( a = byte_a b = byte_b ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>ADD_X
* +-------------------------------------------------------------------------------------------------+
* | [--->] A                              TYPE        RAW4
* | [--->] B                              TYPE        RAW4
* | [<-()] RETURNING                      TYPE        RAW4
* +--------------------------------------------------------------------------------------</SIGNATURE>
method add_x.
  data result type x length 4.
  try.
      " First try regular addition
      result = a + b.
    catch cx_sy_arithmetic_overflow.
      " Overflow occured, perform bitwise addition
      data carry type x length 4.
      carry = a bit-and b.
      result = a bit-xor b.
      while carry <> 0.
        data shiftedcarry type x length 4.
        shiftedcarry = left_shift_x( value = carry positions = 1 ).
        carry = result bit-and shiftedcarry.
        result = result bit-xor shiftedcarry.
      endwhile.
  endtry.
  returning = result.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>LEFT_SHIFT_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        I
* | [--->] POSITIONS                      TYPE        I
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method left_shift_i.
  if positions = 0.
    returning = value.
    return.
  endif.
  data byte_value type x length 4.
  byte_value = value.
  returning = left_shift_x( value = byte_value positions = positions ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>LEFT_SHIFT_X
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        RAW4
* | [--->] POSITIONS                      TYPE        I
* | [<-()] RETURNING                      TYPE        RAW4
* +--------------------------------------------------------------------------------------</SIGNATURE>
method left_shift_x.
  if positions = 0.
    returning = value.
    return.
  endif.
  data positions_to_shift type i.
  positions_to_shift = positions mod 32.
  if positions_to_shift > 0.
    data result type x length 4.
    try.
        " First try regular multiplication
        result = value * ( 2 ** positions_to_shift ).
      catch cx_sy_arithmetic_overflow.
        " Overflow occured, perform bitwise multiplication
        data calc_value type x length 4.
        calc_value = value.
        data b type x length 4.
        do positions_to_shift times.
          b = calc_value bit-and h_40000000.
          calc_value = calc_value bit-and h_3fffffff.
          calc_value = calc_value * 2.
          if b <> 0.
            calc_value = calc_value bit-or h_80000000.
          endif.
        enddo.
        result = calc_value.
    endtry.
    returning = result.
    return.
  else.
    returning = value.
    return.
  endif.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>MULTIPLY_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] A                              TYPE        I
* | [--->] B                              TYPE        I
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method multiply_i.
  data byte_a type x length 4.
  data byte_b type x length 4.
  byte_a = a.
  byte_b = b.
  returning = multiply_x( a = byte_a b = byte_b ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>MULTIPLY_X
* +-------------------------------------------------------------------------------------------------+
* | [--->] A                              TYPE        RAW4
* | [--->] B                              TYPE        RAW4
* | [<-()] RETURNING                      TYPE        RAW4
* +--------------------------------------------------------------------------------------</SIGNATURE>
method multiply_x.
  data result type x length 4.
  try.
      " First try regular multiplication
      result = a * b.
    catch cx_sy_arithmetic_overflow.
      " Overflow occured, perform bitwise multiplication
      data calc_a type x length 4.
      data calc_b type x length 4.
      calc_a = a.
      calc_b = b.
      result = 0.
      while calc_b <> 0.
        data calc_c type x length 4.
        calc_c = calc_b bit-and h_00000001.
        if calc_c <> 0.
          result = add_x( a = result b = calc_a ).
        endif.
        calc_a = left_shift_x( value = calc_a positions = 1 ).
        calc_b = unsigned_right_shift_x( value = calc_b positions = 1 ).
      endwhile.
  endtry.
  returning = result.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>RIGHT_SHIFT_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        I
* | [--->] POSITIONS                      TYPE        I
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method right_shift_i.
  if positions = 0.
    returning = value.
    return.
  endif.
  data byte_value type x length 4.
  byte_value = value.
  returning = right_shift_x( value = byte_value positions = positions ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>RIGHT_SHIFT_X
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        RAW4
* | [--->] POSITIONS                      TYPE        I
* | [<-()] RETURNING                      TYPE        RAW4
* +--------------------------------------------------------------------------------------</SIGNATURE>
method right_shift_x.
  if positions = 0.
    returning = value.
    return.
  endif.
  data positions_to_shift type i.
  positions_to_shift = positions mod 32.
  if positions_to_shift = 31.
    if value < 0.
      returning = -1.
      return.
    else.
      returning = 0.
      return.
    endif.
  elseif positions_to_shift > 0.
    returning = value div ( 2 ** positions_to_shift ).
    return.
  else.
    returning = value.
    return.
  endif.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>SUBTRACT_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] A                              TYPE        I
* | [--->] B                              TYPE        I
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method subtract_i.
  data byte_a type x length 4.
  data byte_b type x length 4.
  byte_a = a.
  byte_b = b.
  returning = subtract_x( a = byte_a b = byte_b ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>SUBTRACT_X
* +-------------------------------------------------------------------------------------------------+
* | [--->] A                              TYPE        RAW4
* | [--->] B                              TYPE        RAW4
* | [<-()] RETURNING                      TYPE        RAW4
* +--------------------------------------------------------------------------------------</SIGNATURE>
method subtract_x.
  data result type x length 4.
  try.
      " First try regular subtraction
      result = a - b.
    catch cx_sy_arithmetic_overflow.
      " Overflow occured, perform bitwise subtraction
      " a - b is the same as a + (-1 * b)
      data b_negated type x length 4.
      if b = min_int.
        b_negated = b.
      else.
        b_negated = b * -1.
      endif.
      result = add_x( a = a b = b_negated ).
  endtry.
  returning = result.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>UNSIGNED_RIGHT_SHIFT_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        I
* | [--->] POSITIONS                      TYPE        I
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method unsigned_right_shift_i.
  if positions = 0.
    returning = value.
    return.
  endif.
  data byte_value type x length 4.
  byte_value = value.
  returning = unsigned_right_shift_x( value = byte_value positions = positions ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_BITWISE=>UNSIGNED_RIGHT_SHIFT_X
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        RAW4
* | [--->] POSITIONS                      TYPE        I
* | [<-()] RETURNING                      TYPE        RAW4
* +--------------------------------------------------------------------------------------</SIGNATURE>
method unsigned_right_shift_x.
  if positions = 0.
    returning = value.
    return.
  endif.
  data positions_to_shift type i.
  positions_to_shift = positions mod 32.
  if positions_to_shift > 0.
    data calc_value type x length 4.
    data a type x length 4.
    data b type x length 4.
    calc_value = value.
    a = calc_value bit-and h_7fffffff.
    a = right_shift_x( value = a positions = positions_to_shift ).
    b = calc_value bit-and h_80000000.
    b = right_shift_x( value = b positions = positions_to_shift ).
    returning = a - b.
    return.
  else.
    returning = value.
    return.
  endif.
endmethod.
ENDCLASS.
