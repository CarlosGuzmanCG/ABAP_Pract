*&---------------------------------------------------------------------*
*& Report Z33_COUNT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z33_COUNT_ALFA02.

  data gv_count type i.

  select count( * ) from zspflialfa02
    into gv_count
    where carrid eq 'LH'.

  IF sy-subrc eq 0.
     write / gv_count.
  ENDIF.

  select COUNT( DISTINCT period ) from zspflialfa02
    into gv_count.

  IF sy-subrc eq 0.
     write / gv_count.
  ENDIF.
