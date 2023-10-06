*&---------------------------------------------------------------------*
*& Report Z011_DELETE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z011_DELETE_ALFA02.

  data gwa_zs type zscarralfa02.

  select * from zscarralfa02
    into gwa_zs where carrid = 'ps:'.
  endselect.

    IF sy-subrc eq 0.

      delete zscarralfa02 from gwa_zs.

      IF sy-subrc eq 0.

         write 'Dato eliminado de la base de datos'.

      ENDIF.

    ELSE.

        write 'No existen los datos enla base de datos'.

    ENDIF.
