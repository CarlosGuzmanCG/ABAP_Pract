*&---------------------------------------------------------------------*
*& Report Z19_SEL_FOR_ALL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z19_SEL_FOR_ALL_ALFA02.

  data: gt_airlines type table of zscarralfa02,
        gt_flights  type table of zscarralfa02.

  select * from zscarralfa02
    into table gt_airlines
    up to 5 rows.

    IF sy-subrc eq 0.

       select * from zscarralfa02
         into table gt_flights
         for all entries in gt_airlines
         where carrid EQ gt_airlines-carrid.

         IF sy-subrc eq 0.

            cl_demo_output=>display( gt_flights ).

         ENDIF.

    ENDIF.
