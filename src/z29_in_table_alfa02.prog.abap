*&---------------------------------------------------------------------*
*& Report Z29_IN_TABLE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z29_IN_TABLE_ALFA02.

  data: gt_planes type table of zsaplanealfa02,
        gr_weight type range of s_plan_wei,
        gwa_weight like line of gr_weight.

  types: begin of ty_range_S_seatsmax,
    sign type c length 1,
    option type c length 2,
    low type s_seatsmax,
    high type s_seatsmax,
    end of ty_range_s_seatsmax.

  data: gr_seatsmax type table of ty_range_s_seatsmax,
        gwa_seatsmax type ty_range_s_seatsmax.

  gwa_seatsmax-sign = 'I'.
  gwa_seatsmax-option = 'BT'.
  gwa_seatsmax-low = '100'.
  gwa_seatsmax-high = '200'.

" I = igual
" E <> distinto
  gwa_weight-sign = 'E'.
  gwa_weight-option = 'EQ'.
  gwa_weight-low = '25458'.

  APPEND gwa_weight to gr_weight.

  select * from zsaplanealfa02
    into table gt_planes
    where seatsmax in gr_seatsmax
    and weight in gr_weight.

  IF sy-subrc eq 0.

     cl_demo_output=>display( gt_planes ).

  ENDIF.
