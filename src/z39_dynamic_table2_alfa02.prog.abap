*&---------------------------------------------------------------------*
*& Report Z39_DYNAMIC_TABLE2_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z39_DYNAMIC_TABLE2_ALFA02.

  parameters par_db type c LENGTH 20.

  types: begin of columns,
    planetype type S_PLANETYE,
    seatsmax type S_SEATSMAX,
    END OF columns.

    data gt_zsc type table of columns.

try.
  select planetype seatsmax from (par_db)
    into table gt_zsc.
catch cx_root.
  write 'ERROR'.
endtry.

  IF sy-subrc eq 0 and gt_zsc is not INITIAL.
      cl_Demo_output=>display( gt_zsc ).
  ENDIF.
