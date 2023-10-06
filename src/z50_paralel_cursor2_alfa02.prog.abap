*&---------------------------------------------------------------------*
*& Report Z50_PARALEL_CURSOR2_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z50_PARALEL_CURSOR2_ALFA02.

  data: gv_cursor_1 type cursor,
        gv_cursor_2 type cursor.

  data:  gwa_zs1 type zsaplanealfa02,
         gwa_zs2 type zsaplanealfa02.

   data: gv_flag_1 type abap_bool,
         gv_flag_2 type abap_bool.

  open cursor: gv_cursor_1 for select PLANETYPE PRODUCER
    from zsaplanealfa02 where producer eq 'BA',

    gv_cursor_2 for select PLANETYPE PRODUCER
    from zsaplanealfa02 where producer eq 'BOE'.

DO.

  IF gv_flag_1 eq abap_false.

     fetch NEXT CURSOR gv_cursor_1 into CORRESPONDING FIELDS OF
     gwa_zs1.

     IF sy-subrc eq 0.
        FORMAT color = 5.
        write: / gwa_zs1-planetype, gwa_zs1-producer.
     ELSE.
       close cursor gv_cursor_1.
       gv_flag_1 = abap_true.
     ENDIF.

  ENDIF.

  IF gv_flag_2 eq abap_false.

    FETCH NEXT CURSOR gv_cursor_2 into CORRESPONDING FIELDS OF
    gwa_zs2.

    IF sy-subrc eq 0.
       format color = 6.

        write: / gwa_zs2-planetype, gwa_zs2-producer.

    ELSE.

      close cursor gv_cursor_2.
      gv_flag_2 = abap_true.

    ENDIF.

  ENDIF.

  IF gv_flag_1 eq abap_true and gv_flag_2 eq abap_true.
    exit.
  ENDIF.

ENDDO.
