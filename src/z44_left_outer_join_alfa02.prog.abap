*&---------------------------------------------------------------------*
*& Report Z44_LEFT_OUTER_JOIN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z44_LEFT_OUTER_JOIN_ALFA02.

TYPES: begin of gty_flight,
  carrid   type s_carr_id,
  carrname type s_carrname,
  fldate   type s_date,
  price    TYPE s_price,
  currency type s_currcode,
  end of gty_flight.

  data gt_flights type STANDARD TABLE OF gty_flight.

  select a~carrid a~carrname b~fldate b~price b~currency
    from ( zscarralfa02 as a
    left outer join zsflightalfa02 as b on a~carrid eq b~carrid )
    into table gt_flights order by price.

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_flights ).
    ENDIF.
