*&---------------------------------------------------------------------*
*& Report Z39_DYNAMIC_COL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z39_DYNAMIC_COL_ALFA02.

  parameters: par_db    type c LENGTH 20,
              campos_d type c length 20.

  types: begin of columns,
    planetype type S_PLANETYE,
    seatsmax  type S_SEATSMAX,

    END OF columns.

    data gt_zsc type table of columns.

try.

  select (campos_d) from (par_db)
    into corresponding fields of table gt_zsc.

catch cx_root.

  write 'ERROR'.

endtry.

  IF sy-subrc eq 0 and gt_zsc[] is not INITIAL.
      cl_Demo_output=>display( gt_zsc ).
  ENDIF.
