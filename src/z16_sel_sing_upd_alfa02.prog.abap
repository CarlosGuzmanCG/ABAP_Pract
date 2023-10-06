*&---------------------------------------------------------------------*
*& Report Z16_SEL_SING_UPD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z16_sel_sing_upd_alfa02.

  DATA gwa_flight TYPE spfli.

  SELECT SINGLE * FROM spfli
    INTO gwa_flight
    WHERE carrid  EQ 'AA'.

 IF sy-subrc EQ 0.

      WRITE gwa_flight-mandt.

 ENDIF.

 SELECT SINGLE * FROM spfli CLIENT SPECIFIED
   INTO gwa_flight
   WHERE mandt EQ '000'
   AND carrid EQ 'AA'.

   IF sy-subrc eq 0.

      WRITE gwa_flight-mandt.

   ENDIF.
