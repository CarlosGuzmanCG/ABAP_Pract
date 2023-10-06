*&---------------------------------------------------------------------*
*& Report Z12_DELETE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z12_DELETE_ALFA02.

  data gt_zs type table of zscarralfa02.


  FIELD-SYMBOLS <gwa_zs> type zscarralfa02.

  select * from zscarralfa02 into table gt_zs
                where carrid in ( 'QF', 'SA' ).


    IF sy-subrc eq 0.

        Write / 'Datos a eliminar'.

        LOOP AT GT_ZS ASSIGNING <GWA_ZS>.

          write: / <gwa_zs>-carrid, ' ', <gwa_zs>-carrname.

        ENDLOOP.

       delete zscarralfa02 from TABLE gt_zs.

       IF sy-subrc eq 0.

          Write / 'Registros borrados'.

       ENDIF.

    ELSE.

        Write 'Los datos no existen en la base de datos'.

    ENDIF.
