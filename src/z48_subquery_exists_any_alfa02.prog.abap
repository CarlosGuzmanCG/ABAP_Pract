*&---------------------------------------------------------------------*
*& Report Z48_SUBQUERY_EXISTS_ANY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z48_SUBQUERY_EXISTS_ANY_ALFA02.

  data gt_flights type table of zsflightalfa02.

  select * from zsflightalfa02 as a
    into tABLE gt_flights
    WHERE seatsocc < a~seatsmax and  exists ( select * from zspflialfa02
                                            where carrid eq a~carrid and
                                              connid eq a~connid and
                                              cityfrom eq 'FRANKFURT' ).

  IF SY-SUBRC EQ 0.
     CL_DEMO_OUTPUT=>display( gt_flights ).
  ENDIF.
