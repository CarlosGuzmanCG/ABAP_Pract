*&---------------------------------------------------------------------*
*& Report Z03_INSERT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z03_INSERT_ALFA02.

  data: gt_sc type table of scarr,
        gz_zs type table of zscarralfa02,
        gcx_root type ref to cx_root.

    TRY.

      select *  from scarr into table gt_sc where CURRCODE <> 'USD'.

        IF SY-SUBRC EQ 0.

          MOVE-CORRESPONDING gt_sc TO gz_zs.

          INSERT zscarralfa02 from table gz_zs.

            IF SY-SUBRC EQ 0.

              Write / 'Datos guardados....'.

            ENDIF.

        ENDIF.

    CATCH CX_SY_OPEN_SQL_DB into gcx_root.

        write: / 'Error ', gcx_root->get_text( ).

    ENDTRY.
