*&---------------------------------------------------------------------*
*& Report Z07_MODIFY_WA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z07_MODIFY_WA_ALFA02.

  data gwa_airline type zscarralfa02.

  gwa_airline-carrid = 'WZ'.
  gwa_airline-carrname = 'Wizz Air'.
  gwa_airline-currcode = 'EUR'.
  gwa_airline-url = 'http://www.wizzair.com'.

  modify zscarralfa02 from gwa_airline.

  IF sy-subrc eq 0.

    write / 'El registro se modifico en base de datos'.

  ELSE.

    Write 'El registro no se inserto'.

  ENDIF.
