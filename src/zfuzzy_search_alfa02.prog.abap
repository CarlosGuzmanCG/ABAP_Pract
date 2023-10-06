*&---------------------------------------------------------------------*
*& Report zfuzzy_search_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfuzzy_search_alfa02.

zcl_fuzzy_search_alfa02=>get_customers(
  EXPORTING
    iv_name      = 'Fisch'
    iv_threshold = '0.6'
  IMPORTING
    et_customers = data(lt_customers) ).

cl_demo_output=>display( lt_customers ).
