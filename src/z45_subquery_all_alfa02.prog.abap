*&---------------------------------------------------------------------*
*& Report Z45_SUBQUERY_ALL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z45_SUBQUERY_ALL_ALFA02.

  types: begin of colm,
    producer type zsaplanealfa02-producer,
    countt   type i,
  end of colm.

  data gt_zs type table of colm.

  select producer count(*) from zsaplanealfa02
    into table gt_zs
    group by producer
    having count(*) >= all (
    select count(*) from zsaplanealfa02 group by producer ).

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_zs ).
    ENDIF.
