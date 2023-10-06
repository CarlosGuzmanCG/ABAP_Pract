*&---------------------------------------------------------------------*
*& Report Z21_SEL_UP_TO_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z21_SEL_UP_TO_ALFA02.

  data gt_airlines type table of zscarralfa02.

  select * from zscarralfa02
    into table gt_airlines
    up to 3 rows.

    IF sy-subrc eq 0.

       cl_demo_output=>display( gt_airlines ).

    ENDIF.
