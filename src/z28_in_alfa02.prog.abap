*&---------------------------------------------------------------------*
*& Report Z28_IN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z28_IN_ALFA02.

DATA gt_airlines type standard table of zscarralfa02.

select * from zscarralfa02
  into table gt_airlines
  where carrid in ( 'AA', 'LH' ).

 IF sy-subrc eq 0.
   cl_demo_output=>display( gt_airlines ).
 ENDIF.
