*&---------------------------------------------------------------------*
*& Report Z30_NULL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z30_NULL_ALFA02.

  DATA gt_flights type table of zspflialfa02.

  select * from zspflialfa02
    into table gt_flights
    " Distinto a null => is not null or ne space
    where period is null
    or period eq space.

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_flights ).
    ENDIF.
