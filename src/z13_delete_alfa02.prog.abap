*&---------------------------------------------------------------------*
*& Report Z13_DELETE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z13_DELETE_ALFA02.

  delete from zscarralfa02 where carrid in ( 'AC', 'JL' ).

  IF sy-subrc eq 0.

     write / 'Datos borrados'.

  ELSE.

    Write / 'Datos no encontrados'.

  ENDIF.
