*&---------------------------------------------------------------------*
*& Report Z47_SUBQUERY_EXISTS_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z47_SUBQUERY_EXISTS_ALFA02.

  data gt_Zs type table of zsaplanealfa02.

  select * from zsaplanealfa02 as a into table gt_Zs
    where exists ( select * from zsflightalfa02
    where planetype eq a~planetype ).

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_Zs ).
    ENDIF.
