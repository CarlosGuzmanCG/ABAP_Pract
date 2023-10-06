*&---------------------------------------------------------------------*
*& Include          Z_CONCESIONARIO_AUT_ALFA02_TOP
*&---------------------------------------------------------------------*

TABLES zco_clientes.

types: begin of gty_vehiculos,
        bbdd type abap_bool,             " new column hiden [x] is value true[x] or false[]
        field_style type lvc_t_styl.     " edit customizable column in create_layout F01
        include STRUCTURE zco_vehiculos. " Structure db
types: END OF gty_vehiculos.

DATA: go_custom_container TYPE REF TO cl_gui_custom_container, " *
      go_alv_grid         TYPE REF TO cl_gui_alv_grid. "instance of standar object notify class 'go_event_receiver'

DATA: gt_clientes           TYPE TABLE OF zco_clientes,
      go_gui_cont_header    type ref to cl_gui_container, " div container header
      go_gui_container_body type ref to cl_gui_container, "div container body
      gt_vehiculos          TYPE TABLE OF gty_vehiculos. " update for new TYPES gty_vehiculo, before zco_vehiculo

" variable global fieldcatalog
" the structure comes in the method perform
DATA  gt_fieldcat TYPE lvc_t_fcat. " type lvc_s_fcat => is a type structure table.

DATA gs_layout TYPE lvc_s_layo. " allow edif in column

DATA ok_code TYPE syucomm. " system variable

CLASS lcl_events_receiver DEFINITION DEFERRED. " we define the class only in-->CL

" the variable notify of the class standar 'go_alv_grid' where is gotten up events 'go_alv_grid'
DATA go_event_receiver TYPE REF TO lcl_events_receiver. " variable for user in the set_handle

data gs_variants type disvariant.   "variant

data gt_toolbar_excluding type ui_functions. "

*******************************************************
*List SALV

  data go_salv_table type ref to cl_salv_table.  "

  data gv_first_time type abap_bool. "

  class lcl_sav_event definition DEFERRED. "definition in other class CL

  data go_salv_event type ref to lcl_sav_event. " by sort

   types: begin of gty_vehiculos_alq.
    include type zco_vehiculos.
    types t_color type lvc_t_scol. " new column
  types: end of gty_vehiculos_alq.

  data gt_veh_alq type table of  gty_vehiculos_alq. "zco_vehiculos.

  data: gt_veh_hier type table of zco_vehiculos,
        gt_cln_hier type table of zco_clientes.

  data go_salv_hier type ref to cl_salv_hierseq_table.

  class lcl_hier_events definition DEFERRED.

  data go_hier_events type ref to lcl_hier_events.

  DATA: go_salv_tree type ref to cl_salv_tree,
        gt_mmc_tree  type table of zco_ma_mo_cl_tree,
        gt_mmc_temp_tree type table of zco_ma_mo_cl_tree. " get data in video 7

  data: go_gui_tree         type ref to cl_gui_alv_tree,
        gs_hierarchy_header type treev_hhdr.

  data: gv_fav_key       type lvc_nkey,
        gv_fav_folder_id type i,
        gv_fav_line_id   type i.

  "
  data: go_line_behaviour type ref to cl_dragdrop,
        go_fav_behaviour  type ref to cl_dragdrop.

  class lcl_gui_tree_events DEFINITION DEFERRED.

  data go_gui_tree_events type ref to lcl_gui_tree_events.

  " table internal fieldcatalog tree
  data gt_fieldcat_tree type lvc_t_fcat.
