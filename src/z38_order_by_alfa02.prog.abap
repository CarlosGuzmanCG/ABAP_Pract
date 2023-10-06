*&---------------------------------------------------------------------*
*& Report Z38_ORDER_BY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z38_order_by_alfa02.

  DATA gt_flights TYPE TABLE OF zsflightalfa02.

*  SELECT * FROM zsflightalfa02
*    INTO TABLE gt_flights ORDER BY carrid fldate price DESCENDING.

*  select * from zsflightalfa02 into table gt_flights
*    "primary key
*    order by carrid connid fldate DESCENDING.

*DATA: gt_scarr TYPE STANDARD TABLE OF zscarralfa02.
*
*SELECT * FROM zscarralfa02
*  INTO TABLE gt_scarr.
*
*  IF sy-subrc EQ 0 AND  gt_scarr[] IS NOT INITIAL.
*
*     SELECT * FROM zsflightalfa02
*       INTO TABLE gt_flights
*       FOR ALL ENTRIES IN gt_scarr
*       WHERE carrid EQ gt_scarr-carrid
*       ORDER BY PRIMARY KEY.
*
*      IF sy-subrc EQ 0.
*        cl_demo_output=>display( gt_flights ).
*      ENDIF.
*
*  ENDIF.

  types: begin of gty_flights,
    carrid   type zsflightalfa02-carrid,
    currency type zsflightalfa02-currency,
    fldate   type zsflightalfa02-fldate,
    min      type p decimals 2,
    max      type p decimals 2,
  end of gty_flights.

  data gt_flight_type type STANDARD TABLE OF gty_flights.

  select carrid currency fldate min( price ) max( price )
    from zsflightalfa02 into table gt_flight_type
    up to 1 rows
    where planetype eq 'A340-600'
    group by carrid currency fldate having currency in ( 'EUR','USD' )
    order by fldate.

  IF sy-subrc eq 0.
      cl_demo_output=>display( gt_flight_type ).
  ENDIF.
