*&---------------------------------------------------------------------*
*& Report zamdp_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zamdp_alfa02.

data gt_flights type ty_flights.

zcl_flights_alfa02=>calling_another_amdp(
  EXPORTING
    iv_mandt   = sy-mandt
    iv_carrid  = 'AA'
  IMPORTING
    et_flights = gt_flights ).

cl_demo_output=>display( gt_flights ).
