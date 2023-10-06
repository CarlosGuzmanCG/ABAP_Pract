*&---------------------------------------------------------------------*
*& Report Z21_SEL_COL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z21_SEL_COL_ALFA02.

  types: begin of gty_flights,
    carrid   type S_CARR_ID,
    CITYFROM type S_FROM_CIT,
    AIRPFROM type S_FROMAIRP,
    CITYTO   type S_TO_CITY,
    AIRPTO   type S_TOAIRP,
    end of gty_flights.

  data gt_zs type table of gty_flights.

  select carrid CITYFROM AIRPFROM CITYTO AIRPTO from
    zspflialfa02 into table gt_zs.

   IF sy-subrc eq 0.

      cl_demo_output=>display( gt_zs ).

   ENDIF.
