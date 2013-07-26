report zrestlog no standard page heading line-size 1023.

data: restlog_record type zrestlog,
      restlog_records type standard table of zrestlog,
      alv type ref to cl_salv_table,
      request_lines type standard table of string,
      request_line type string.

select-options s_date for restlog_record-requestdate.
select-options s_time for restlog_record-requesttime.
select-options s_user for restlog_record-requestuser.
select-options s_path for restlog_record-resourcepath.
select-options s_name for restlog_record-resourcename.

start-of-selection.

  select * into table restlog_records from zrestlog
    where requestdate in s_date and
          requesttime in s_time and
          requestuser in s_user and
          resourcepath in s_path and
          resourcename in s_name
    order by requestdate descending requesttime descending.

end-of-selection.

  loop at restlog_records into restlog_record.
    condense: restlog_record-requestdate, restlog_record-requesttime, restlog_record-requestuser,
              restlog_record-resourcepath, restlog_record-resourcename, restlog_record-resourceid.
    write: / `Date:   ` color col_key, restlog_record-requestdate.
    write: / `Time:   ` color col_key, restlog_record-requesttime.
    write: / `User:   ` color col_key, restlog_record-requestuser.
    write: / `Path:   ` color col_key, restlog_record-resourcepath.
    write: / `Name:   ` color col_key, restlog_record-resourcename.
    write: / `Id:     ` color col_key, restlog_record-resourceid.
    write: / `Request:` color col_key.
    split restlog_record-request at cl_abap_char_utilities=>cr_lf into table request_lines.
    loop at request_lines into request_line.
      write: / request_line.
    endloop.
    uline.
  endloop.