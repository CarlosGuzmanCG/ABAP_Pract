*&---------------------------------------------------------------------*
*& Report Z45_SUBQUERY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z45_SUBQUERY_ALFA02.

  data gwa_flight type zsflightalfa02.
" Caso 1
  select single * from zsflightalfa02
    into gwa_flight
    where seatsocc eq ( select max( seatsocc ) from zsflightalfa02 ).

  IF sy-subrc eq 0.
     write: / gwa_flight-carrid, gwa_flight-seatsocc.
  ENDIF.

  " Caso 2

  select single * from zsflightalfa02
    into gwa_flight
    where carrid eq ( select carrid from zscarralfa02 where carrname eq 'Qantas Airways' ).

  IF sy-subrc eq 0.
     write: / gwa_flight-carrid, gwa_flight-seatsocc.
  ENDIF.

  " Caso 3

  data gt_flights type STANDARD TABLE OF zsflightalfa02.

  select * from zsflightalfa02
    into table gt_flights
    where carrid eq ( select carrid from zscarralfa02 where carrname eq 'Lufthansa' ).

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_flights ).
    ENDIF.
