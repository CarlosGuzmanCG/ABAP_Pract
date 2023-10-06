*&---------------------------------------------------------------------*
*& Report Z07_UPDATE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z07_UPDATE_ALFA02.

  update zscarralfa02 set currcode = 'USD'
        where carrid = 'LH' or carrid = 'NG'.

  IF sy-subrc eq 0.

    write / 'Datos actualizados'.

  ELSE.

    write / 'Datos no actualizados'.

  ENDIF.
