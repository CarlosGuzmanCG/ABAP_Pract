*&---------------------------------------------------------------------*
*& Report Z49_SUBQUERY_IN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z49_SUBQUERY_IN_ALFA02.

  data gt_spfli type table of zspflialfa02.

*  select * from zspflialfa02 as a
*    into table gt_spfli
*    where carrid in ( select carrid from zsflightalfa02 where
*                             carrid eq a~carrid
*    and connid eq a~connid ).
*
*  IF sy-subrc eq 0.
*     cl_demo_output=>display( gt_spfli ).
*  ENDIF.

  data gt_flights type table of zsflightalfa02.

  select * from zsflightalfa02 into table gt_flights.

  IF sy-subrc eq 0 and gt_flights is not INITIAL.

     select * from zspflialfa02
       into table gt_spfli for all ENTRIES IN gt_flights
       where carrid eq gt_flights-carrid
       and connid eq gt_flights-connid.

    IF sy-subrc eq 0.
        cl_demo_output=>display( gt_spfli ).
    ENDIF.

  ENDIF.
