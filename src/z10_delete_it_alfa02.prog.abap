*&---------------------------------------------------------------------*
*& Report Z10_DELETE_IT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z10_DELETE_IT_ALFA02.

  data gt_airlines type table of zscarralfa02.

  " AC Air Canada
  " AF Air France
  " AZ Alitalia

  select * from zscarralfa02
    into table gt_airlines
    " Multiples condiciones
    where carrid in ( 'AC', 'AF', 'AZ' ).

 IF sy-subrc eq 0.

    delete zscarralfa02 from table gt_airlines.

    IF sy-subrc eq 0.

      write / 'Los registros se han eliminado de la base de datos'.

    ENDIF.

   ELSE.

     write / 'Registros no encontrados'.

 ENDIF.
