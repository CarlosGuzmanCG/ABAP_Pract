*&---------------------------------------------------------------------*
*& Report Z02_INSERT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z02_INSERT_ALFA02.

  DATA: gt_sca type table of scarr,
        gt_zsc type standard table of zscarralfa02.


  TRY.

    select *  from scarr
      into table gt_sca where CURRCODE eq 'EUR'.


    IF sy-subrc eq 0.

    move-CORRESPONDING gt_sca to gt_zsc.

    insert zscarralfa02 from table gt_zsc.

      IF sy-subrc eq 0.

          write /'Datos guardados'.

          WRITE: 'El numero de registro insertados: ', sy-dbcnt.

      ENDIF.

    ENDIF.

  CATCH CX_SY_OPEN_SQL_DB.

      write: 'ERROR: '.

  ENDTRY.
