*&---------------------------------------------------------------------*
*& Report Z_READ_TI_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_read_ti_alfa02.

DATA: gt_proveedores TYPE STANDARD TABLE OF lfm1,
      gwa_proveedores TYPE lfm1.

SELECT * FROM lfm1 INTO TABLE gt_proveedores
   WHERE lifnr EQ 'BP1110'.

IF sy-subrc EQ 0.
  READ TABLE gt_proveedores INTO gwa_proveedores WITH KEY
  ekorg = '1110'.

  IF sy-subrc EQ 0.
    WRITE: 'Nombre del responsable = ', gwa_proveedores-ernam.
  ELSE.
    WRITE '...'.
   ENDIF.
  ELSE.
    WRITE '..'.
  ENDIF.
