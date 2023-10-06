*&---------------------------------------------------------------------*
*& Report Z31_NULL_OP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z31_NULL_OP_ALFA02.

  data gwa_zs type zspflialfa02.

  select single * from zspflialfa02 into gwa_zs
    where fltype is not null and fltype ne space.

  IF sy-subrc eq 0.
      cl_demo_output=>display( gwa_zs ).
  ENDIF.
