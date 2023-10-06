*&---------------------------------------------------------------------*
*& Report Z32_MIN_MAX_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z32_MIN_MAX_ALFA02.

  data: gv_weight_max type s_plan_wei,
        gv_weight_min type s_plan_wei,
        gv_seatsmax type s_seatsmax.

  select max( weight ) from zsaplanealfa02
    into gv_weight_max.

  IF sy-subrc eq 0.
     write / gv_weight_max UNIT 'KG' COLOR COL_HEADING .
  ENDIF.


  select min( weight ) from zsaplanealfa02
    into gv_weight_min.

  IF sy-subrc eq 0.
     write / gv_weight_min UNIT 'KG' COLOR COL_KEY .
  ENDIF.

  select max( weight ) min( weight ) max( seatsmax ) from zsaplanealfa02
    into ( gv_weight_max, gv_weight_min, gv_seatsmax ).

  IF sy-subrc eq 0.
     write: / gv_seatsmax,
            / gv_weight_max UNIT 'KG',
            / gv_weight_min unit 'KG'.
  ENDIF.
