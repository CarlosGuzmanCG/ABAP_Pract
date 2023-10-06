CLASS zcl_flights_alfa02 DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS GET_FLIGHTS IMPORTING VALUE(iv_mandt) type mandt
                                        value(iv_carrid) type s_Carr_id
                                        EXPORTING value(et_flights) type ty_flights.


    CLASS-METHODS calling_another_amdp IMPORTING VALUE(iv_mandt) type mandt
                                        value(iv_carrid) type s_Carr_id
                                        EXPORTING value(et_flights) type ty_flights.

ENDCLASS.



CLASS zcl_flights_alfa02 IMPLEMENTATION.



  METHOD get_flights by database PROCEDURE FOR HDB LANGUAGE
            sqlscript options read-only using sflight.

  et_flights = select * from sflight as a
                       where mandt = :iv_mandt
                       and carrid = :iv_carrid;


  ENDMETHOD.

  METHOD calling_another_amdp by DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
  USING zcl_flights_alfa02=>get_flights.

    CALL "ZCL_FLIGHTS_ALFA02=>GET_FLIGHTS"(
        iv_mandt   => :iv_mandt,
        iv_carrid  => :iv_carrid,
        et_flights => :et_flights );

  ENDMETHOD.

ENDCLASS.
