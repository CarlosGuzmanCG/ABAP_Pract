*&---------------------------------------------------------------------*
*& Report z02_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_alfa02.

cl_dd_ddl_annotation_Service=>get_annos(
  EXPORTING
    entityname         = 'ZB_11_ALFA02'
  IMPORTING
    element_annos      = data(gt_element_annos) ).

    cl_demo_output=>display( gt_element_annos ).
