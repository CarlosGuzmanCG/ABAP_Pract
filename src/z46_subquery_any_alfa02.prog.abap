*&---------------------------------------------------------------------*
*& Report Z46_SUBQUERY_ANY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z46_SUBQUERY_ANY_ALFA02.

  data gwa_zs type table of zscarralfa02.

  select * from zscarralfa02 into table gwa_zs
    where carrid eq any ( select carrid from zspflialfa02 where cityfrom eq 'FRANKFURT').

    IF sy-subrc eq 0.
       cl_demo_output=>display( gwa_zs ).
    ENDIF.
