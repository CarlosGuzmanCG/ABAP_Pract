*&---------------------------------------------------------------------*
*& Report Z24_BINARY_REL_OPER_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z24_BINARY_REL_OPER_ALFA02.

  data gt_flights type table of zsflightalfa02.

  select * from zsflightalfa02 into table gt_flights
    where fldate <> '20211111'.

    IF  sy-subrc eq 0.

      cl_demo_output=>display( gt_flights ).

    ENDIF.
