*&---------------------------------------------------------------------*
*& Report Z03_UPDATE_WA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z03_UPDATE_WA_ALFA02.

  data gwa_airline type zscarralfa02.

  "Obtenemos solo un registro
  select  single * from zscarralfa02
    into gwa_airline
    where carrid eq 'AF'.

  IF sy-subrc eq 0.

    write gwa_airline-currcode.

    gwa_airline-currcode = 'USD'.

    update zscarralfa02 from gwa_airline.

    IF sy-subrc eq 0.

      write / 'Registro actualizado correctamente'.

    ENDIF.

  ENDIF.
