*&---------------------------------------------------------------------*
*& Report Z_MOVE_TI_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_MOVE_TI_ALFA02.

types: BEGIN OF proveedores,
       lifnr type lifnr,
       land1 type land1_gp,
       name1 type name1_gp,
       END OF proveedores.

Data: gt_mis_prov type standard table of proveedores,
      gwa_mis_prov type proveedores,

      gt_bd_prov type standard table of lfa1,
      gwa_bd_prov type lfa1.


select * from lfa1
    into table gt_bd_prov
    where land1 eq 'DE'.

IF sy-subrc eq 0.

  LOOP AT gt_bd_prov into gwa_bd_prov.

    MOVE-CORRESPONDING gwa_bd_prov to gwa_mis_prov.

    APPEND gwa_mis_prov to gt_mis_prov.

  ENDLOOP.

  LOOP AT gt_mis_prov INTO gwa_mis_prov.


    Write: / gwa_mis_prov-lifnr,
             gwa_mis_prov-land1,
             gwa_mis_prov-name1.

  ENDLOOP.

ENDIF.
