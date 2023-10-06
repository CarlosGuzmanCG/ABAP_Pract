*&---------------------------------------------------------------------*
*& Include          ZBI_VIRT_ALFA02_TOP
*&---------------------------------------------------------------------*
  "Transparent Table
  TABLES: zbi_cln_logali,
          zbi_cat_logali.

  "data table modify in exercise 3.26
  TYPES: BEGIN OF gty_libros_papel,
    bbdd type abap_bool,             " new column hiden [x] is value true[x] or false[]
    field_style type lvc_t_styl.     " edit customizable column in create_layout F01
    INCLUDE STRUCTURE zbi_lib_logali.
 types:  end of gty_libros_papel.

  "system variable
  DATA ok_code TYPE syucomm.


  "dynpro alv
  DATA:  go_custom_container TYPE REF TO cl_gui_custom_container, " using in  DISPLAY_ALV_LIB_PAPEL and instance_cust_cont
         go_gui_cont_header TYPE REF TO cl_gui_container, " new class final 3
         go_gui_cont_body TYPE REF TO cl_gui_container,   " new class final 3
         go_alv_lib_papel    TYPE REF TO cl_gui_alv_grid. "instance of standar object notify class 'go_event_receiver'

  "" variable global fieldcatalog [F01] in BUILD_FIELD_CAT
  DATA: gt_fieldcat TYPE lvc_t_fcat.

  DATA gt_libros_papel TYPE TABLE OF gty_libros_papel.  "  'zbi_lib_logali. " table standar db'

  DATA gs_layout TYPE lvc_s_layo. " edif allow in column

  CLASS lcl_event_alv_grid DEFINITION DEFERRED. " we define the class only

  DATA go_event_alv_grid TYPE REF TO lcl_event_alv_grid. " local class reference

  data gs_variants type disvariant. " system variants

  data gt_toolbar_excluding type  ui_functions.

  data go_salv_table type ref to cl_salv_table.

  types: begin of gty_lib.
    INCLUDE STRUCTURE zbi_lib_logali.
    types t_color type lvc_t_scol.
  types: end of gty_lib.

  data gt_libros_ele type table of gty_lib.

  data gv_first_time type abap_bool.

  class lcl_events_salv_list DEFINITION DEFERRED.

  data go_salv_event type ref to lcl_events_salv_list.

" 5.02
  data: gt_hier_cat type table of ZBi_CAT_LOGALI,
        gt_hier_lib type table of zbi_lib_logali.

  data  go_salv_hier_cat_lib type ref to cl_salv_hierseq_table.

  CLASS lcl_event_salv_hierseq DEFINITION DEFERRED.
  DATA go_salv_event_hierseq TYPE REF TO lcl_event_salv_hierseq.

  TYPES: BEGIN OF gty_clientes,
        NOMBRE    TYPE PSOVN,
        APELLIDOS TYPE PSONM,
        EMAIL     TYPE ZBI_EMAIL,
       END OF gty_clientes.

 "new

 data: GO_SALV_TREE_CAT_LIB_CLI TYPE REF TO CL_SALV_TREE,
       GT_CAT_LIB_CLI TYPE TABLE OF ZBI_CAT_LIB_CLI_LOGALI,
       GT_TEMP_CAT_LIB_CLI TYPE TABLE OF ZBI_CAT_LIB_CLI_LOGALI.

 data: GO_GUI_TREE_ACC_CAT_LIB TYPE REF TO CL_GUI_ALV_TREE,
       GS_GUI_TREE_HEADER      TYPE TREEV_HHDR,
       GT_GUI_TREE_FIELDCAT    TYPE LVC_T_FCAT,
       GT_ACC_CAT_LIB          TYPE TABLE OF ZBI_ACC_CAT_LIB_LOGALI,
       GT_TEMP_ACC_CAT_LIB     TYPE TABLE OF ZBI_ACC_CAT_LIB_LOGALI.

 data GV_FAV_KEY type LVC_NKEY.

 data: GV_FAV_FOLDER_ID TYPE I,
       GV_FAV_LINE_ID TYPE I,
       GO_LINE_BEHAVIOUR TYPE REF TO CL_DRAGDROP,
       GO_FAV_BEHAVIOUR TYPE REF TO CL_DRAGDROP.

CLASS lcl_gui_tree_events DEFINITION DEFERRED.

DATA go_gui_tree_events TYPE REF TO lcl_gui_tree_events.
