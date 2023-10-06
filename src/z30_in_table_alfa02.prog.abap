*&---------------------------------------------------------------------*
*& Report Z30_IN_TABLE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z30_IN_TABLE_ALFA02.

  DATA: gt_flights TYPE TABLE OF zsflightalfa02,
        gr_price   TYPE RANGE OF s_price WITH HEADER LINE.

  gr_price-sign = 'I'.
  gr_price-option = 'BT'.
  gr_price-low = '500'.
  gr_price-high = '1500'.
  APPEND gr_price.

  SELECT * FROM zsflightalfa02 INTO TABLE gt_flights
    WHERE price IN gr_price AND currency EQ 'DEM'.

  IF sy-subrc EQ 0.
    cl_demo_output=>display( gt_flights ).
  ENDIF.
