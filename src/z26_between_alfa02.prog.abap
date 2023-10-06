*&---------------------------------------------------------------------*
*& Report Z26_BETWEEN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z26_BETWEEN_ALFA02.

  data gt_zs type zsflightalfa02.

  select single * from zsflightalfa02
    into gt_zs
    where fldate between '19950101' and '19950301'.

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_zs ).
    ENDIF.
