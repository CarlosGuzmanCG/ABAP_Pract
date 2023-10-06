*&---------------------------------------------------------------------*
*& Report Z14_SELECT_SINGLE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z14_SELECT_SINGLE_ALFA02.

  DATA gwa_flight type ZSPFLIALFA02.

  select single * from ZSPFLIALFA02
         into gwa_flight where carrid eq 'AA'.

    IF sy-subrc eq 0.

       write gwa_flight-cityfrom.

    ENDIF.

    types: begin of gty_flights,
           carrid   type s_carr_id,
           connid   type s_conn_id,
           cityfrom type s_from_cit,
           end of gty_flights.

    data gwa_flight_type type gty_flights.

" Regisro realizando un mapeo a traves de los nombres
" y si coinciden los nombres se van a mover los datos
" para el tipo local "gwa_flight_type"

    select single * from ZSPFLIALFA02
      into corresponding fields of gwa_flight_type
      where carrid eq 'AA'.

    IF sy-subrc eq 0.

       write gwa_flight_type-cityfrom.

    ENDIF.
