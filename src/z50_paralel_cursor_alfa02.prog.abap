*&---------------------------------------------------------------------*
*& Report Z50_PARALEL_CURSOR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z50_PARALEL_CURSOR_ALFA02.

  data: gv_cursor_1 type cursor,
        gv_cursor_2 type cursor.

  data: gwa_spfli_1 type zspflialfa02,
        gwa_spfli_2 type zspflialfa02.

  data: gv_flag_1 type abap_bool,
        gv_flag_2 type abap_bool.

  open cursor: gv_cursor_1 for select carrid connid
    from zspflialfa02 where carrid eq 'LH',

    gv_cursor_2 for select carrid connid
    from zspflialfa02 where carrid eq 'LH'.

  DO.

    IF gv_flag_1 eq abap_false.

      fetch next cursor gv_cursor_1 into CORRESPONDING FIELDS OF
        gwa_spfli_1.

      IF sy-subrc eq 0.
        FORMAT COLOR = 5.
         write : / gwa_spfli_1-carrid, gwa_spfli_1-connid.

      ELSE.

        CLOSE CURSOR gv_cursor_1.
        gv_flag_1 = abap_false.

      ENDIF.

    ENDIF.

   IF gv_flag_2 eq abap_false.

     fetch next cursor gv_cursor_2 into CORRESPONDING FIELDS OF gwa_spfli_2.

     IF sy-subrc eq 0.
       FORMAT COLOR = 6.
        write : / gwa_spfli_2-carrid, gwa_spfli_2-connid.

     ELSE.

       close cursor gv_cursor_2.
       gv_flag_2 = abap_true.

     ENDIF.

   ENDIF.

   IF gv_flag_1 eq abap_true and gv_flag_2 eq abap_true.
      exit.
   ENDIF.

  ENDDO.
