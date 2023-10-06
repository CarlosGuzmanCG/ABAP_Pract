*&---------------------------------------------------------------------*
*& Report Z52_NESTED_CURSOR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z52_NESTED_CURSOR_ALFA02.

  DATA: gwa_spfli        type zspflialfa02,
        gwa_sflight      type zsflightalfa02,
        gwa_sflight_temp type zsflightalfa02..

  data: gv_cursor_1 type cursor,
        gv_cursor_2 type cursor.

  data(gr_out) = cl_demo_output=>new( ).

  open cursor: gv_cursor_1 for select * from zspflialfa02
               order by primary key,

               gv_cursor_2 for select * from zsflightalfa02
               order by primary key.

  DO.

   fetch next cursor gv_cursor_1 into gwa_spfli.

   IF sy-subrc ne 0.

      exit.

   ENDIF.

    gr_out->begin_section( |{ gwa_spfli-carrid } { gwa_spfli-connid }| ).

  DO.

    IF not gwa_sflight_temp is INITIAL.
       gwa_sflight = gwa_sflight_temp.
       clear gwa_sflight_temp.

    ELSE.
      FETCH NEXT CURSOR gv_cursor_2 into gwa_sflight.

      IF sy-subrc ne 0.
         exit.
      ELSEIF gwa_sflight-carrid ne gwa_spfli-carrid
        or gwa_sflight-connid ne gwa_spfli-connid.

        gwa_sflight_temp = gwa_sflight.

        exit.

      ENDIF.
    ENDIF.

    gr_out->write( |{ gwa_sflight-carrid } { gwa_sflight-connid } { gwa_sflight-fldate }|  ).

  ENDDO.
  gr_out->end_section( ).

  ENDDO.

  close cursor: gv_cursor_1, gv_cursor_2.

  gr_out->display( ).
