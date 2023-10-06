*&---------------------------------------------------------------------*
*& Report Z11_DELETE_IT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z11_DELETE_IT_ALFA02.

*delete from zscarralfa02
*  where carrid eq 'AA'
*    and currcode eq 'USD'.

delete from zscarralfa02
  where currcode eq 'USD'.

if sy-subrc eq 0.

  write 'Registro eliminado de la base de datos'.

 ELSE.

   write 'Registro no eliminado de la db'.

endif.
