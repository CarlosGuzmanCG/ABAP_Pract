*&---------------------------------------------------------------------*
*& Report Z25_BINARY_REL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z25_binary_rel_alfa02.

  DATA gt_zs TYPE ZSFLIGHTALFA02.

  select single * from ZSFLIGHTALFA02 into gt_zs
    where fldate >= '19950101' and fldate =< '19950301'.

  IF sy-subrc eq 0.
      cl_demo_output=>display( gt_zs ).
  ENDIF.
