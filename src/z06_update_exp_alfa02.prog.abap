*&---------------------------------------------------------------------*
*& Report Z06_UPDATE_EXP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z06_UPDATE_EXP_ALFA02.

*  data: gt_sflight type table of sflight,
*        gt_zflight type table of zsflightalfa02.

*
*  select * from sflight
*    into table gt_sflight.
*
*    IF sy-subrc eq 0.
*
*        move-corresponding gt_sflight to gt_zflight.
*
*        insert zsflightalfa02 from table gt_zflight.
*
*        IF sy-subrc eq 0.
*
*          write 'Registros copiados correctamente'.
*
*        ENDIF.
*
*    ENDIF.

" SEATSMAX_B  S_SMAX_B  INT4  10  0 0 Maximum capacity in business class
" SEATSOCC_B  S_SOCC_B  INT4  10  0 0 Occupied seats in business class


data gv_seats type i.

gv_seats = 3.

  update zsflightalfa02
    set seatsmax_b = seatsmax_b + 10
    seatsocc_b = seatsocc_b + gv_seats
    where carrid eq 'LH'.

  IF sy-subrc eq 0.

    write / 'Se han actualizado todos los registros'.

  ELSE.

    write / 'No se han actualizado los registros'.

  ENDIF.
