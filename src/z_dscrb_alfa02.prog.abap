*&---------------------------------------------------------------------*
*& Report Z_DSCRB_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_dscrb_alfa02.

DATA: gt_deudor TYPE STANDARD TABLE OF kna1,
      gwa_deudores TYPE kna1,
      gv_t TYPE i,
      date1 TYPE d.

SELECT * FROM kna1 INTO TABLE gt_deudor
          WHERE land1 EQ 'US' .

IF sy-subrc EQ 0.

  DESCRIBE TABLE gt_deudor LINES gv_t.

  WRITE: / 'Total de deudores', gv_t.

  READ TABLE gt_deudor INTO gwa_deudores WITH KEY regio = 'ILIllinois'.

  IF sy-subrc EQ 0.

  WRITE: 'Nombre: ', gwa_deudores-kunnr.

  ENDIF.

ENDIF.


SELECT * FROM kna1 INTO TABLE gt_deudor.


IF sy-subrc EQ 0.

  SORT gt_deudor DESCENDING BY erdat.

  LOOP AT gt_deudor INTO gwa_deudores WHERE erdat > '20050101' .

    WRITE: / 'Deudor: ', gwa_deudores-kunnr , 'fecha: ', gwa_deudores-erdat.

  ENDLOOP.



  LOOP AT gt_deudor INTO gwa_deudores WHERE erdat > '20050101' .

    date1 = gwa_deudores-erdat.

    IF date1 EQ '20050722'.

      gwa_deudores-erdat = sy-datum.

      MODIFY gt_deudor FROM gwa_deudores.

    ENDIF.

  ENDLOOP.


ENDIF.

DATA gt_deudores_cab TYPE STANDARD TABLE OF kna1 WITH HEADER LINE.

SELECT * FROM kna1 INTO TABLE gt_deudores_cab WHERE land1 = 'DE'.

IF sy-subrc EQ 0.

  LOOP AT gt_deudores_Cab.

    " write: / '----' , gt_deudores_cab-LAND1, '->', gt_deudores_Cab-erdat.

    date1 = gt_deudores_Cab-erdat.

    IF date1 EQ '19920624'.

      DELETE gt_deudores_cab.

    ENDIF.

  ENDLOOP.

ENDIF.


SELECT * FROM kna1 INTO TABLE gt_deudor
  UP TO 1 ROWS WHERE land1 = 'US'  .

IF sy-subrc EQ 0.

  LOOP AT gt_deudor INTO gwa_deudores.

    DELETE TABLE gt_deudor FROM gwa_deudores.

  ENDLOOP.

ENDIF.


types: begin of empleados,
       name1 type name1,
       end of empleados.

Data: gt_mis_empleados type standard table of empleados,
      gwa_mis_empleados type empleados,

      gt_bd_empleados type STANDARD TABLE OF kna1,
      gwa_bd_empleados type kna1.


select * from kna1 into table gt_bd_empleados.

IF sy-subrc eq 0.

  LOOP AT gt_bd_empleados into gwa_bd_empleados.

  MOVE-CORRESPONDING gwa_bd_empleados to gwa_mis_empleados.

  APPEND gwa_mis_empleados to gt_mis_empleados.

SKIP  5.
  ENDLOOP.

    LOOP AT gt_bd_empleados into gwa_bd_empleados.


    Write: / gwa_mis_empleados-name1.

  ENDLOOP.

ENDIF.
