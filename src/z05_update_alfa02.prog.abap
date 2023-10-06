*&---------------------------------------------------------------------*
*& Report Z05_UPDATE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z05_UPDATE_ALFA02.

  update zscarralfa02 set currcode = 'USD'
         where carrid = 'AC' and carrname = 'Air Canada' and currcode <> 'USD'.

  IF sy-subrc eq 0.

      write 'Dato actualizado'.

  ELSE.

      write 'Datos no actualizados'.

  ENDIF.
