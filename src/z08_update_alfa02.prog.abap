*&---------------------------------------------------------------------*
*& Report Z08_UPDATE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z08_update_alfa02.

  UPDATE zsflightalfa02
    SET seatsmax_f = seatsmax_f + 18
        seatsocc_f = seatsocc_f + 15.

  IF sy-subrc EQ 0.

    WRITE / 'Se han actualizado todos los registros'.

  ELSE.

      WRITE / 'No se han actualizado los registros'.

  ENDIF.
