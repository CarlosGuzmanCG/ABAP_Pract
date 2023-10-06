*&---------------------------------------------------------------------*
*& Include          ZMAT_ITEMS_ALFA02_TOP
*&---------------------------------------------------------------------*

DATA ok_code TYPE syucomm.

" you can use data but you have to change the scrren and sql
TABLES zmat_alfa02. " replace --> ZST_MAT_ITEMS_ALFA_02.7

  DATA gs_items TYPE zmat_alfa02. "REPLACE  -->zst_mat_items.

" hiden catalog in screen
  TYPES: BEGIN OF gty_mat_items,
    bbdd TYPE abap_bool.
    INCLUDE STRUCTURE zmat_alfa02.
  TYPES: END OF gty_mat_items.


  DATA gt_fieldcat TYPE lvc_t_fcat.

  DATA: go_custom_container TYPE REF TO cl_gui_custom_container,
        go_alv_mat_items TYPE REF TO cl_gui_alv_grid.

  DATA gt_mat_items TYPE TABLE OF gty_mat_items.

   DATA gt_mat_original TYPE TABLE OF gty_mat_items. " copy of table original

*  data gt_mat_items type table of ZMAT_ALFA02." replace --> ZST_MAT_ITEMS_ALFA_02.

  DATA gs_layout TYPE lvc_s_layo. "declaration layout

  CLASS lcl_event_alv DEFINITION DEFERRED. " ADD class

   DATA go_events TYPE REF TO lcl_event_alv. " shape 1
