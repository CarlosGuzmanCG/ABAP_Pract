*&---------------------------------------------------------------------*
*& Report Z29_IN_OP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z29_IN_OP_ALFA02.

  data gwa_zs type zscarralfa02.

  select single * from zscarralfa02 into gwa_zs
    where carrid in ('QF', 'SA', 'SR').

    IF sy-subrc eq 0.
       cl_demo_output=>display( gwa_zs ).
    ENDIF.
