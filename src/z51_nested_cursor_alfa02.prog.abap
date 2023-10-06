*&---------------------------------------------------------------------*
*& Report Z51_NESTED_CURSOR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z51_NESTED_CURSOR_ALFA02.

  DATA: gwa_scarr  TYPE zscarralfa02,
      gwa_flight TYPE zsflightalfa02.

DATA: gv_cursor_1 TYPE cursor,
      gv_cursor_2 TYPE cursor.

DATA(gr_out) = cl_demo_output=>new( ).

OPEN CURSOR gv_cursor_1 FOR SELECT * FROM zscarralfa02
                                  ORDER BY PRIMARY KEY.
DO.

  FETCH NEXT CURSOR gv_cursor_1 INTO gwa_scarr.

  IF sy-subrc NE 0.
    CLOSE CURSOR gv_cursor_1.
    EXIT.
  ENDIF.
  gr_out->begin_section( gwa_scarr-carrid  ).

  OPEN CURSOR gv_cursor_2 FOR SELECT * FROM zsflightalfa02
                          WHERE carrid EQ gwa_scarr-carrid.
  DO.
    FETCH NEXT CURSOR gv_cursor_2 INTO gwa_flight.
    IF sy-subrc NE 0.
      CLOSE CURSOR gv_cursor_2.
      EXIT.
    ENDIF.
    gr_out->write( |{ gwa_flight-carrid } { gwa_flight-connid } { gwa_flight-fldate } | ).
  ENDDO.

  gr_out->end_section( ).

ENDDO.

gr_out->display( ).
