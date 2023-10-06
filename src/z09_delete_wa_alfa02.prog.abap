*&---------------------------------------------------------------------*
*& Report Z09_DELETE_WA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z09_delete_wa_alfa02.

  DATA gwa_airline TYPE zscarralfa02.

  " DL - DELTA AIRLINES
  SELECT SINGLE * FROM zscarralfa02
    INTO gwa_airline
    WHERE carrid EQ 'DL'.

  IF sy-subrc EQ 0.

    DELETE zscarralfa02 FROM gwa_airline.

    IF sy-subrc EQ 0.

       WRITE / 'Registro eliminado de la base de datos'.

    ENDIF.

   ELSE.

     write / 'El registro no existe'.

  ENDIF.
