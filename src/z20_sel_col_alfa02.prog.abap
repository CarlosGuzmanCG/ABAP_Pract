*&---------------------------------------------------------------------*
*& Report Z20_SEL_COL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z20_SEL_COL_ALFA02.

" Caso 1
  data gv_cityfrom type s_from_cit.

  select single cityfrom from ZSPFLIALFA02
    into gv_cityfrom
    where carrid eq 'AA'.

 IF sy-subrc eq 0.

   write gv_cityfrom.

 ENDIF.

 " Caso 2

 TYPES: begin of gty_flights,
        carrid type s_carr_id,
        connid type s_conn_id,
        cityfrom type s_from_cit,
   end of gty_flights.

  data: gt_flights type table of gty_flights,
        gwa_flight type gty_flights.

  select single carrid connid cityfrom from ZSPFLIALFA02
    into gwa_flight.

    IF sy-subrc eq 0.

       write: / gwa_flight-carrid, gwa_flight-connid, gwa_flight-cityfrom.

    ENDIF.

" caso 3

  select carrid connid cityfrom from ZSPFLIALFA02
    into table gt_flights.

    IF sy-subrc eq 0.

       cl_demo_output=>display( gt_flights ).

    ENDIF.

    data gt_bbdd type table of ZSPFLIALFA02.

    select carrid connid from ZSPFLIALFA02
      into corresponding fields of table gt_bbdd.

      IF sy-subrc eq 0.

         cl_demo_output=>display( gt_bbdd ).

      ENDIF.
