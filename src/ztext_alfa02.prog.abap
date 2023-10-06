*&---------------------------------------------------------------------*
*& Report ZTEXT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEXT_ALFA02.

TYPES: BEGIN OF ty_datos,
         campo1 TYPE string,
         campo2 TYPE string,
       END OF ty_datos.

DATA: wa_datos TYPE ty_datos,
      lt_datos TYPE TABLE OF ty_datos.

DATA: go_alv TYPE REF TO cl_gui_alv_grid,
      gt_fieldcat TYPE lvc_t_fcat.

gt_fieldcat = VALUE lvc_t_fcat( ( fieldname = 'CAMPO1' )
                                ( fieldname = 'CAMPO2' ) ).

CREATE OBJECT go_alv
  EXPORTING
    i_parent = cl_gui_container=>screen0.

CALL METHOD go_alv->set_table_for_first_display
  EXPORTING
    i_structure_name = 'TY_DATOS'
  CHANGING
    it_outtab        = lt_datos
    it_fieldcatalog  = gt_fieldcat.
