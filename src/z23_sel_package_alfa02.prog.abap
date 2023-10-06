*&---------------------------------------------------------------------*
*& Report Z23_SEL_PACKAGE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z23_SEL_PACKAGE_ALFA02.

  data gwa_zs type table of zscarralfa02.

  FIELD-SYMBOLS <gtw_zs> type zscarralfa02.

  select * from zscarralfa02
    into table gwa_zs package size 2.

  LOOP AT gwa_zs ASSIGNING <gtw_zs>.

      write: / <gtw_zs>-carrid, <gtw_zs>-carrname.

  ENDLOOP.

  skip 2.

  endselect.
