CLASS zcl_table_fun_alfa02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .



PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    class-methods get_flights for TABLE FUNCTION ZTF_FLIGHTS_ALFA02.

ENDCLASS.



CLASS zcl_table_fun_alfa02 IMPLEMENTATION.

  METHOD get_flights by DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY USING scarr spfli.



   lt_flights =  select airline.mandt as client,
        airline.carrname as airlinename,
        flight.connid as flightconn,
        flight.cityfrom as cityfrom,
        flight.cityto as cityto
    from scarr as airline
        inner JOIN spfli as flight
        on airline.mandt = flight.mandt and
            airline.carrid = flight.carrid
     where airline.mandt = :clnt and
        flight.carrid = :airlinecode
        order by airline.mandt, flight.carrid, flight.connid;

        return select * from :lt_flights;

  ENDMETHOD.

ENDCLASS.
