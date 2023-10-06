*&---------------------------------------------------------------------*
*& Report z_fuzzy_search_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_fuzzy_search_alfa02.

zcl_airlines01_alfa02=>get_airlines(
  EXPORTING
    lv_airline_name = 'AIR'
    iv_threshold    =  1
  IMPORTING
    et_airlines     = DATA(LT_AIR)
).

 CL_DEMO_OUTPUT=>DISPLAY( LT_AIR ).
