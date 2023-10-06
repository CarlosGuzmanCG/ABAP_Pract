*&---------------------------------------------------------------------*
*& Report Z28_ESCAPE_OP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z28_ESCAPE_OP_ALFA02.

  data: gt_zs type ztax_code,
        search type string.

  search = '%' && '27#%' && '%'.

  select single * from ztax_code into gt_zs
    where text1 like search escape '#'.

 IF sy-subrc eq 0.
    cl_demo_output=>display( gt_zs ).
 ENDIF.
