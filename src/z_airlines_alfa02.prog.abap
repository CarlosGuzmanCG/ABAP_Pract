*&---------------------------------------------------------------------*
*& Report z_airlines_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_airlines_alfa02.

TYPES: BEGIN OF GTY_AIR,
    NAME TYPE S_AIRPNAME,
    TIME_ZONE TYPE S_TZONE,
END OF GTY_AIR.

data: gty_airl TYPE table of GTY_AIR.

zcl_airlines_alfa02=>get_airlines(
  EXPORTING
    iv_mandt    =  sy-mandt
  IMPORTING
    et_airlines = gty_airl ).

if not gty_airl is initial.
 cl_demo_output=>display( gty_airl ).
endif.
