*&---------------------------------------------------------------------*
*& Report z14_mde_test_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z14_mde_test_alfa02.

cl_dd_ddl_annotation_Service=>get_annos( " detalles agregados o que ya existian
  EXPORTING
    entityname         = 'ZB_15_AIRL_M_ALFA02'
  IMPORTING
    element_annos      = data(gt_element_annos) ).

    cl_dd_ddl_annotation_service=>get_annos_4_element( "detalles tecnicos
      EXPORTING
        entityname         = 'ZB_16_AIRL_M_ALFA02 '
        elementname        = 'AIRLINE'
      importing
        annos = data(gt_element_annos_elem)  ).

*    cl_demo_output=>display( gt_element_annos ).
cl_demo_output=>display( gt_element_annos_elem ).
