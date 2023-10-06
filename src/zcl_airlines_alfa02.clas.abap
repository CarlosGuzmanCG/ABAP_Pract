CLASS zcl_airlines_alfa02 DEFINITION
  PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb.

    TYPES: BEGIN OF GTY_AIR,
           NAME TYPE S_AIRPNAME,
           TIME_ZONE TYPE S_TZONE,
      END OF GTY_AIR.

    TYPES: gty_airl TYPE TABLE OF GTY_AIR.

    CLASS-METHODS GET_AIRLINES IMPORTING value(iv_mandt) type mandt
                    exporting value(et_airlines) type gty_airl.

    class-METHODS CALL_AMDP IMPORTING value(iv_mandt) type mandt
                    exporting value(et_airlines) type gty_airl.


ENDCLASS.



CLASS zcl_airlines_alfa02 IMPLEMENTATION.

  METHOD get_airlines by DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING SAIRPORT.

    et_airlines = select name, time_zone from SAIRPORT as a
        where mandt = :iv_mandt;

  ENDMETHOD.

  METHOD call_amdp by DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING
    zcl_airlines_alfa02=>GET_AIRLINES.

    CALL "ZCL_AIRLINES_ALFA02=>GET_AIRLINES"(
        iv_mandt    => :iv_mandt,
        et_airlines => :et_airlines );

  ENDMETHOD.

ENDCLASS.
