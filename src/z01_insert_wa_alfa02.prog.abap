*&---------------------------------------------------------------------*
*& Report Z01_INSERT_WA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z01_INSERT_WA_ALFA02.

  data gwa_airline type ZSCARRALFA02.

*  gwa_airline-mandt = '801'.  "Mandante
  gwa_airline-carrid = 'SAA'.
  gwa_airline-carrname = 'American Airlines'.
  gwa_airline-currcode = 'USD'.
  gwa_airline-url = 'http://www.aa.com'.

*  insert into ZSCARRALFA02 values gwa_airline.

*  insert ZSCARRALFA02 CLIENT SPECIFIED from gwa_airline. " INSERT con mandante

  insert ZSCARRALFA02 from gwa_airline.

  IF sy-subrc eq 0.

      message 'Registro insertado correctamente en db' type 'I'.

  ELSE.

      MESSAGE 'REGISTRO NO INSERTADO' TYPE 'E'.

  ENDIF.
