CLASS zcl_table_fun01_alfa02 DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    class-methods get_flights for TABLE FUNCTION ZCDS_TF_ALFA02.

ENDCLASS.



CLASS zcl_table_fun01_alfa02 IMPLEMENTATION.

  METHOD get_flights by database function for HDB LANGUAGE SQLSCRIPT
   OPTIONS READ-ONLY "solo hacemos una lectura
   using scarr spfli.

   lt_flights =  select airline.mandt as client,
        airline.carrname as airliname,
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
