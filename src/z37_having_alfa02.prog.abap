*&---------------------------------------------------------------------*
*& Report Z37_HAVING_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z37_HAVING_ALFA02.

  data:
        begin of gwa_flight,
        carrid   type s_carr_id,
        currency type s_currcode,
        min      type p decimals 2,
        max      type p decimals 2,
      end of gwa_flight.

  select carrid currency min( price ) max( price )
    from zsflightalfa02
    into (gwa_flight-carrid,gwa_flight-currency,gwa_flight-min,gwa_flight-max)
    where fldate between '19940101' and '20221111'
    group by carrid currency having currency eq 'USD'.

    write: / gwa_flight-carrid,gwa_flight-currency,gwa_flight-min,gwa_flight-max.

  endselect.

    types:
        begin of gty_flight,
        carrid   type s_carr_id,
        currency type s_currcode,
        min      type p decimals 2,
        max      type p decimals 2,
      end of gty_flight.

  data gt_flights type table of gty_flight.

  select carrid currency min( price ) max( price )
    from zsflightalfa02
    into table gt_flights
    where fldate between '19940101' and '20221111'
    group by carrid currency having currency eq 'USD'.


   IF sy-subrc eq 0.
      cl_demo_output=>display( gt_flights ).
   ENDIF.
