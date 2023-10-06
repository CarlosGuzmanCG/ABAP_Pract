*&---------------------------------------------------------------------*
*& Report Z19_SEL_INTO_TBL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z19_SEL_INTO_TBL_ALFA02.

  data gwa_zs type table of zspflialfa02.

  select * from zspflialfa02 into table gwa_zs.

  append initial line to gwa_zs.

  select * from zspflialfa02 appending table gwa_zs.

  cl_demo_output=>display( gwa_zs ).
