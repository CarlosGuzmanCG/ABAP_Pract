*&---------------------------------------------------------------------*
*& Report z_airlines01_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_airlines01_alfa02.


zcl_airlines_alfa02=>call_amdp(
  EXPORTING
    iv_mandt    = sy-mandt
  IMPORTING
    et_airlines = data(lt_Airl) ).

cl_demo_output=>display( lt_Airl ).
