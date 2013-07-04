class CL_STRING_DISTANCE definition
  public
  inheriting from CL_OBJECT
  final
  create public .

public section.

*"* public components of class CL_STRING_DISTANCE
*"* do not include other source files here!!!
  class-methods DISTANCE
    importing
      !STRING1 type STRING
      !STRING2 type STRING
    returning
      value(RETURNING) type I .
protected section.
*"* protected components of class CL_STRING_DISTANCE
*"* do not include other source files here!!!
private section.

*"* private components of class CL_STRING_DISTANCE
*"* do not include other source files here!!!
  class-methods _MIN
    importing
      !INT1 type I
      !INT2 type I
      !INT3 type I
    returning
      value(RETURNING) type I .
ENDCLASS.



CLASS CL_STRING_DISTANCE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_STRING_DISTANCE=>DISTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] STRING1                        TYPE        STRING
* | [--->] STRING2                        TYPE        STRING
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method distance.
  types: begin of ty_row,
           value type standard table of i with default key,
         end of ty_row.
  data distance_table_row type ty_row.
  data distance_table type standard table of ty_row.

  data col_count type i.
  col_count = strlen( string2 ) + 1.
  data row_count type i.
  row_count = strlen( string1 ).

  " Create first row
  data value type i.
  value = 0.
  do col_count times.
    append value to distance_table_row-value.
    value = value + 1.
  enddo.
  append distance_table_row to distance_table.
  clear distance_table_row.

  " Create next rows
  value = 0.
  do row_count times.
    value = value + 1.
    data is_first type abap_bool.
    is_first = abap_true.
    do col_count times.
      if is_first = abap_true.
        append value to distance_table_row-value.
        is_first = abap_false.
      else.
        append 0 to distance_table_row-value.
      endif.
    enddo.
    append distance_table_row to distance_table.
    clear distance_table_row.
  enddo.

  " Calculate distances
  data counter_rows type i.
  data counter_cols type i.
  field-symbols <new_value> type i.
  field-symbols <distance_table_row> type ty_row.
  counter_rows = 1.
  loop at distance_table assigning <distance_table_row>.
    if counter_rows = 1.
      counter_rows = counter_rows + 1.
      continue.
    endif.
    counter_cols = 0.
    do col_count times.
      counter_cols = counter_cols + 1.
      if counter_cols = 1. " Skip first column
        continue.
      endif.
      read table <distance_table_row>-value assigning <new_value> index counter_cols.

      data previous_row type i.
      previous_row = counter_rows - 1.
      data previous_col type i.
      previous_col = counter_cols - 1.

      " Distance previous row
      data dist1 type i.
      field-symbols <previous_row> type ty_row.
      field-symbols <previous_row_value> type i.
      read table distance_table assigning <previous_row> index previous_row.
      read table <previous_row>-value assigning <previous_row_value> index counter_cols.
      dist1 = <previous_row_value> + 1.

      " Distance previous column
      data dist2 type i.
      field-symbols <previous_col_value> type i.
      read table <distance_table_row>-value assigning <previous_col_value> index previous_col.
      dist2 = <previous_col_value> + 1.

      " Distance previous row and column
      data dist3 type i.
      field-symbols <previous_row_col_value> type i.
      read table <previous_row>-value assigning <previous_row_col_value> index previous_col.
      data char_pos1 type i.
      char_pos1 = previous_row - 1.
      data char_pos2 type i.
      char_pos2 = previous_col - 1.
      if string1+char_pos1(1) = string2+char_pos2(1).
        dist3 = <previous_row_col_value>.
      else.
        dist3 = <previous_row_col_value> + 1.
      endif.

      " Use minimum distance
      <new_value> = _min( int1 = dist1 int2 = dist2 int3 = dist3 ).

    enddo.
    counter_rows = counter_rows + 1.
  endloop.

  field-symbols <result> type i.
  data row type i.
  row = row_count.
  data col type i.
  col = strlen( string2 ).
  read table distance_table assigning <distance_table_row> index row.
  read table <distance_table_row>-value assigning <result> index col.
  if <result> is not assigned.
    returning = 0.
  else.
    returning = <result>.
  endif.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method CL_STRING_DISTANCE=>_MIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] INT1                           TYPE        I
* | [--->] INT2                           TYPE        I
* | [--->] INT3                           TYPE        I
* | [<-()] RETURNING                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method _min.
  data result type i.
  if int1 < int2.
    result = int1.
  else.
    result = int2.
  endif.
  if int3 < result.
    result = int3.
  endif.
  returning = result.
endmethod.
ENDCLASS.
