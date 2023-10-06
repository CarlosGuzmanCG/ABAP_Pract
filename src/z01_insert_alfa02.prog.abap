*&---------------------------------------------------------------------*
*& Report Z01_INSERT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z01_INSERT_ALFA02.

  data: gwa_zscar type zscarralfa02,
        gcx_sql type ref to cx_root.


  gwa_zscar-carrid = 'BA'.

  gwa_zscar-carrname = 'British Airways'.

  gwa_zscar-currcode = 'GBP'.

  gwa_zscar-url = 'http://www.britishairways.com'.

  TRY.

    insert zscarralfa02 from gwa_zscar.

   IF sy-subrc eq 0.

        Write / 'Datos guardados'.

    ELSE.

      WRITE 'Datos no guardados'.

   endif.

  CATCH CX_SY_OPEN_SQL_DB into gcx_sql.

    write: 'ERROR: ', gcx_sql->get_text( ).

  ENDTRY.
