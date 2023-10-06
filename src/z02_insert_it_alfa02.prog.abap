*&---------------------------------------------------------------------*
*& Report Z02_INSERT_IT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_insert_it_alfa02.

  DATA: gt_bbdd     TYPE STANDARD TABLE OF zscarralfa02,
        gt_airlines TYPE TABLE OF scarr,
        gcx_exception TYPE REF TO cx_root.

" Caso 1 - Insert from IT

*  SELECT * FROM scarr
*    " Guardamos la informacion en la tabla interna gt_airlines
*          INTO TABLE gt_airlines
*           WHERE currcode EQ 'USD'.
*
*  IF sy-subrc EQ 0.
*    Mover los datos entre tablas internas
*     MOVE-CORRESPONDING gt_airlines TO gt_bbdd.
*
*      INSERT zscarralfa02 FROM TABLE gt_bbdd.
*
*      IF sy-subrc eq 0.
*
*         WRITE: 'El numero de registro insertados: ', sy-dbcnt.
*
*      ENDIF.
*
*  ENDIF.

" Caso 2 - Insert ccon duplicado - Tratamiento de excepcion

*SELECT * FROM scarr
*  INTO TABLE gt_airlines.
*
*  IF sy-subrc EQ 0.
*
*    MOVE-CORRESPONDING gt_airlines TO gt_bbdd.
*
*    TRY.
*
*        INSERT zscarralfa02 FROM TABLE  gt_bbdd.
*
*    CATCH cx_sy_open_sql_db into gcx_exception.
*
*      WRITE: 'Error registrado: ', gcx_exception->get_text( ).
*
*    ENDTRY.
*
*    IF sy-subrc EQ 0.
*
*        WRITE: 'N° registros insertados', sy-dbcnt.
*
*    ENDIF.
*
*  ENDIF.

" Caso 3 - Insert con duplicado - Sin tratamienro de excepcion

  SELECT * FROM scarr
  INTO TABLE gt_airlines.

  IF sy-subrc EQ 0.

    MOVE-CORRESPONDING gt_airlines TO gt_bbdd.

    INSERT zscarralfa02 FROM TABLE  gt_bbdd ACCEPTING DUPLICATE KEYS.

    WRITE: / 'N° registros insertados', sy-dbcnt,
           / 'Sy-subrc = ', sy-subrc.

  ENDIF.
