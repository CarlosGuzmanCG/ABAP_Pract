*&---------------------------------------------------------------------*
*& Report Z27_ESCAPE_CHAR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z27_ESCAPE_CHAR_ALFA02.

  data: gt_tax_name type table of ztax_code,
        gv_str type c length 20.

  gv_str = '%' && '10#%' && '%'.

  select * from ztax_code
    into table gt_tax_name
    where text1 like gv_str escape '#'.

  IF sy-subrc eq 0.
    cl_demo_output=>display( gt_tax_name ).
  ENDIF.
