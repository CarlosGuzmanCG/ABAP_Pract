*&---------------------------------------------------------------------*
*& Report Z24_BETWEEN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z24_BETWEEN_ALFA02.

  data gt_flights type table of zsflightalfa02.

  select * from zsflightalfa02
    into table gt_flights
    where fldate between '19991111' and '20221111'.

  IF sy-subrc eq 0.

      cl_demo_output=>display( gt_flights ).

  ENDIF.

  " F1
*  data(gv_dias_fin_semana_flag) = boolc( sy-fdayw between 6 and 7 ).

  "Mismo codigo F2

  data gv_dias_fin_semana_flag type c length 1. " abap_bool

  gv_dias_fin_semana_flag = boolc( sy-fdayw between 6 and 7 ).

  WRITE: sy-fdayw, gv_dias_fin_semana_flag.
