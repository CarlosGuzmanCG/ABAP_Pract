*&---------------------------------------------------------------------*
*& Report Z22_SEL_UP_TO_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z22_SEL_UP_TO_ALFA02.

  data gwa_zs type table of zsflightalfa02.

  select * from zsflightalfa02
    into table gwa_zs Up To 3 rows.

  IF sy-subrc eq 0.
      cl_demo_output=>display( gwa_zs ).
  ENDIF.
