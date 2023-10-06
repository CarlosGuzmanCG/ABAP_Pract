*&---------------------------------------------------------------------*
*& Report Z19_SEL_ENDSEL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z19_SEL_ENDSEL_ALFA02.

  data: gt_flights type table of ZSPFLIALFA02,
        gwa_flight type ZSPFLIALFA02.

" Caso 1

*select * from ZSPFLIALFA02 into gwa_flight.
*
*" Aplicar logica
*
*  add 1 to gwa_flight-distance.
*
*  append gwa_flight to gt_flights.
*
*  endselect.
*
*  cl_demo_output=>display( gwa_flight ).

" Caso 2

*select * from ZSPFLIALFA02 into gwa_flight where carrid eq 'AA'.
*
*  "Aplicar logica
*
*  add 1 to gwa_flight-distance.
*
*  append gwa_flight to gt_flights.
*
*  ENDSELECT.
*
*  cl_demo_output=>display( gwa_flight ).

" Caso 3
Types: begin of gty_flights,
       carrid   type s_carr_id,
       connid   type s_conn_id,
       cityfrom type s_from_cit,
  end of gty_flights.

  data: gt_flights_type  type standard table of gty_flights,
        gwa_flights_type type gty_flights.

  select * from ZSPFLIALFA02 into corresponding fields of gwa_flights_type.

    APPEND gwa_flights_type to gt_flights_type.

   ENDSELECT.

   cl_demo_output=>display( gt_flights_type ).
