*&---------------------------------------------------------------------*
*& Report Z47_SUBQUERY_ANY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z47_SUBQUERY_ANY_ALFA02.

  data gt_airlines type table of zscarralfa02.

  select * from zscarralfa02
    into table gt_airlines
    " ANY = ALMENOS EXISTE UN REGISTRO CUMPLE LA CONDICION
    where carrid eq any ( select carrid from zsflightalfa02 where seatsmax ge 350 ).

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_airlines ).
    ENDIF.
