*&---------------------------------------------------------------------*
*& Report Z22_SEL_PACKAGE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z22_SEL_PACKAGE_ALFA02.

  data: gt_flights type sorted table of zspflialfa02
        with non-unique key carrid connid,
        gwa_flight type zspflialfa02.

  select * from zspflialfa02 into table gt_flights
    package size 2.

  LOOP AT gt_flights into gwa_flight.

    write: / gwa_flight-carrid, gwa_flight-connid.

  ENDLOOP.

  skip 1.

  endselect.
