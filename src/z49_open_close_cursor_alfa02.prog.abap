*&---------------------------------------------------------------------*
*& Report Z49_OPEN_CLOSE_CURSOR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z49_open_close_cursor_alfa02.

  DATA: gv_finished TYPE abap_bool,
        gv_cursor   TYPE cursor,
        gwa_zs      TYPE zsaplanealfa02.

  OPEN CURSOR gv_cursor FOR SELECT *
              FROM zsaplanealfa02
              WHERE producer EQ 'BOE'.

  WHILE gv_finished EQ abap_false.

    fetch next cursor gv_cursor into gwa_zs.

    IF sy-subrc eq 0.

        write: / gwa_zs-planetype.
    ELSE.

      close cursor gv_cursor.

      gv_finished = abap_true.

    ENDIF.

  ENDWHILE.
