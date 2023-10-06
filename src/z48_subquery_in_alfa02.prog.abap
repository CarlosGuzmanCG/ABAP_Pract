*&---------------------------------------------------------------------*
*& Report Z48_SUBQUERY_IN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z48_SUBQUERY_IN_ALFA02.

  data gt_zs type table of zscarralfa02.

  select * from zscarralfa02 as a into table gt_zs
    where carrid in ( select carrid from zspflialfa02 where carrid eq a~carrid ).

  IF sy-subrc eq 0.
     cl_demo_output=>display( gt_zs ).
  ENDIF.
