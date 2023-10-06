*&---------------------------------------------------------------------*
*& Report Z_DESCRIBE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DESCRIBE_ALFA02.

data: gt_materiales type standard table of mara,
      gv_lineas type i.

select * from mara into table gt_materiales where ersda eq
  '20220401'.

if sy-subrc eq 0.
  describe table gt_materiales lines gv_lineas.
ENDIF.

write gv_lineas.
