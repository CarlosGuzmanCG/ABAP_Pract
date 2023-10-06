*&---------------------------------------------------------------------*
*& Report Z27_LIKE_OP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z27_LIKE_OP_ALFA02.

  data gwa_zs type table of doktl.

  select * from doktl into table gwa_zs
    up to 5 rows
    where doktext like '_CONTEXT_'.

  IF sy-subrc eq 0.
    cl_demo_output=>display( gwa_zs ).
  ENDIF.
