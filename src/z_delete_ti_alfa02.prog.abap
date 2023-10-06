*&---------------------------------------------------------------------*
*& Report Z_DELETE_TI_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_delete_ti_alfa02.

DATA gt_facturas TYPE STANDARD TABLE OF vbrk WITH HEADER LINE.

SELECT * FROM vbrk
  INTO TABLE gt_facturas
  WHERE fkart EQ 'F2'.

  IF sy-subrc EQ 0.

    WRITE / 'Las facturas antes de eliminar el registro'.

    SKIP.

    LOOP AT gt_facturas.

      WRITE / gt_facturas-vbeln.

    ENDLOOP.

    LOOP AT gt_facturas.
      IF sy-tabix GT 2.
        DELETE gt_facturas.
      ENDIF.
    ENDLOOP.

  WRITE 'despues de eliminar los registros'.

DELETE gt_facturas INDEX 1.

  LOOP AT gt_facturas.
    SKIP 3.
      WRITE / gt_facturas-vbeln.

    ENDLOOP.

  ENDIF.
