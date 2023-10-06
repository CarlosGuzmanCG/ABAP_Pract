*&---------------------------------------------------------------------*
*& Report Z18_SEL_INTO_TABLE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z18_SEL_INTO_TABLE_ALFA02.

  data gt_flights type table of ZSPFLIALFA02.

  select * from ZSPFLIALFA02
    into table gt_flights.

  APPEND initial line to gt_flights.

*    cl_demo_output=>display(
*      EXPORTING
*        data = gt_flights
*        name = 'Tabla estandar ZSPFLIALFA02'
*    ).

 " Caso 2

    types: begin of gty_flights,
                    carrid   type s_carr_id,
                    connid   type s_conn_id,
                    cityfrom type s_from_cit,
           end of gty_flights.

    data gt_flights_type type table of gty_flights.

    select * from ZSPFLIALFA02
      into corresponding fields of table gt_flights_type.

    append initial line to gt_flights_type.

    select * from ZSPFLIALFA02
      into CORRESPONDING FIELDS OF table gt_flights_type.

      cl_demo_output=>display(
        EXPORTING
          data = gt_flights_type
          name = 'TABLE gt_flights_type'
      ).
