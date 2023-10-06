*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_TOP
*&---------------------------------------------------------------------*

*INCLUDE fZA23_ASIGEMPcdt.

TABLES: za23_empleados,
        za23_familiares,
        za23_habilidades,
        za23_asigemp,
        za23_areas,
        za23_puestos,
        za23_horarios,
        za23_bajas_emp,
        za23_capac,
        za23_emp_cap,
        za23_reg_nominas,
        ZA23_VAC_PERM,
        ibipparms.

DATA: cond(72) TYPE c,
      gv_tab_where LIKE TABLE OF cond.

CONTROLS GV_TABSTRIP TYPE TABSTRIP.

DATA: gt_asig_where TYPE TABLE OF string.

DATA lv_boolact TYPE abap_bool.

*data gt_name type SFLIGHT-FLDATE.

DATA gv_code3004 TYPE sy-ucomm.

"TABNAME
DATA gv_tabname TYPE dd02l-tabname.

"CDHDR AND CDPOS
DATA: gt_cdtxt TYPE TABLE OF cdtxt,
      gv_objecttid TYPE cdhdr-objectid.

" lock object
DATA: gv_garg LIKE seqg3-garg,
      gt_seqg3 LIKE TABLE OF seqg3 WITH HEADER LINE,
      gv_msg TYPE string.

DATA gv_first_time TYPE abap_bool.

"VARIABLE
DATA gv_assig_id TYPE numc10.

"set_list
DATA: gv_init,
      gv_id TYPE vrm_id,
      gt_values TYPE vrm_values,
      gs_values LIKE LINE OF gt_values.

"help search in screen 3000 register of job
DATA: gv_id_emp TYPE numc10.
DATA gv_rec_check TYPE abap_bool.  " in screen 3004 for verif register
" confrimation
DATA: gv_answ.
" CUSTOM CONTAINER
DATA: go_cust_cont_emerg  TYPE REF TO cl_gui_custom_container,
      go_alv_grid_emerg   TYPE REF TO cl_gui_alv_grid, "instance of standar object notify class 'go_event_receiver'

      go_cust_cont_skill TYPE REF TO cl_gui_custom_container,
      go_alv_grid_skill  TYPE REF TO cl_gui_alv_grid,

      go_custom_cont_ade TYPE REF TO cl_gui_custom_container,
      go_alv_grid_ade    TYPE REF TO cl_gui_alv_grid,
      " SHOW REPORT
      go_alv_grid_his_rep           TYPE REF TO cl_gui_alv_grid,
      go_history_reports_container  TYPE REF TO cl_gui_custom_container,
      "catalog
      go_catalog_alv       TYPE REF TO cl_gui_alv_grid,
      go_catalog_container TYPE REF TO cl_gui_custom_container.



"fieldcatalog
DATA: gt_fieldcat_emerg   TYPE lvc_t_fcat, " FIELDCATALOG IN EMERGY
      gt_fieldcat_skill   TYPE lvc_t_fcat,
      gt_fieldcat_his_rep TYPE lvc_t_fcat, " FIELDCATALOG IN SKILLS

      gt_catalog_fieldcat      TYPE lvc_t_fcat.

 "excluding
 DATA gt_excluding TYPE ui_functions.

DATA: gs_layout TYPE lvc_s_layo. "declaration layout

" VARABLE SYSTEM

DATA: ok_code TYPE syucomm.
DATA: gv_code TYPE sy-ucomm.
DATA: gv_act_button TYPE sy-ucomm.
DATA: gv_act TYPE sy-ucomm.
*      gv_code_cust_fam TYPE sy-ucomm,
*      gv_code_cust_skl TYPE sy-ucomm.

DATA: lv_refresh TYPE sy-dynnr.
DATA: gv_ui_func TYPE ui_func.
DATA: gv_value_row TYPE i,
      gv_value_id_assig TYPE i,
      gv_value_id_emp   TYPE i.

"COUNT VALUE FAMILY
DATA: gv_count_fam TYPE i,
      gv_count_skill TYPE i.

" TABLE
*  TYPES: BEGIN OF gty_emp_family,
*    mandt TYPE mandt,
*    id_familiar      TYPE za23_id_familiar,
*    id_empleado      TYPE za23_id_empleado,
*    nombre           TYPE za23_nombre,
*    apellido_paterno TYPE za23_apellido_pat,
*    apellido_materno TYPE za23_apellido_mat,
*    parentesco       TYPE za23_parentesco,
*    calle            TYPE za23_direccion_calle,
*    colonia          TYPE za23_direccion_colonia,
*    municipio        TYPE za23_municipio,
*    estado           TYPE za23_estado_rs,
*    no_interior      TYPE za23_noc_interior,
*    no_exterior      TYPE za23_noc_exterior,
*    cp               TYPE za23_cod_postal,
*    n_telefono1      TYPE za23_num_telefono1,
*    n_telefono2      TYPE za23_num_telefono2.
* TYPES: END OF gty_emp_family.

* CREATION OF TEMPORARY CATALOG

  DATA: gt_family TYPE TABLE OF ZCL_HR_FAMILY_ALFA02=>gty_emp_family,
        ls_family LIKE LINE OF gt_family.

"----------

*  DATA: gt_family like ZCL_HR_FAMILY_ALFA02 ,
*        ls_family TYPE gty_emp_family.
"------

 DATA: gt_areas TYPE TABLE OF za23_areas,
       gs_areas TYPE za23_areas.

 DATA: gt_puestos TYPE TABLE OF za23_puestos,
       gs_puestos TYPE za23_puestos.

 DATA: gs_employee TYPE za23_empleados.


DATA: gt_rep_his  TYPE TABLE OF zhrv_se_alfa02." TABLE VIEW SHOW HISTORY REPORT

" CONFIGURATION VIEW ZA23V_EM_EC_C
  TYPES: BEGIN OF gty_EM_EC_C,
    bbdd        TYPE abap_bool,
    field_style TYPE lvc_t_styl.
    INCLUDE STRUCTURE za23v_emp_cap_v .
  TYPES: END OF gty_EM_EC_C.

DATA: gtv_em_ec_c TYPE TABLE OF gty_EM_EC_C.

DATA: gt_train     TYPE TABLE OF zhr_emp_asi_cap,
      gs_train     TYPE zhr_emp_asi_cap.

" VIEW ZA23V_EMP_VAC

*TYPES: BEGIN OF gty_emp_cap,
*  bbdd    TYPE abap_bool,
*  field_style TYPE lvc_t_styl.
*  INCLUDE STRUCTURE ZHRV_EMPV_ALFA02.
*types: end of gty_emp_cap.

*DATA: gt_emp_cap TYPE TABLE OF ZHRV_EMPV_ALFA02,
*      gs_emp_cap TYPE ZHRV_EMPV_ALFA02.


" RECORD PAYROLL
TYPES: BEGIN OF gty_erp_regnom,
  bbdd        TYPE abap_bool.
  INCLUDE STRUCTURE zhr_emp_regnom.
TYPES: END OF gty_erp_regnom.

DATA: gt_payroll TYPE TABLE OF gty_erp_regnom,
      gs_payroll TYPE gty_erp_regnom. "ZHR_EMP_REGNOM.

" gs_train_upd

TYPES: BEGIN OF gty_data_tra_upd,
  id_cap_emp TYPE za23_id_cap_emp,
  id_empleado TYPE za23_id_empleado,
  id_asignacion TYPE za23_id_asignacion,
  id_capacitacion TYPE za23_id_cap.
TYPES: END OF gty_data_tra_upd.

DATA: gs_train_upd TYPE gty_data_tra_upd.


 DATA: gv_id_area TYPE numc10,
       gv_id_puesto TYPE numc10.
 "VARIABLE SEARCH EMPLOYEE
 DATA: lv_txt_id_emp TYPE numc10.

  " CREATION OF TABLE STANDAR

  DATA: gt_emp_cap TYPE TABLE OF ZHRV_EMPV_ALFA02,
        gs_emp_cap TYPE ZHRV_EMPV_ALFA02.

  DATA: gt_skill TYPE TABLE OF za23_habilidades,
        gs_skill TYPE za23_habilidades.


  "update training
  DATA: gt_training_v TYPE TABLE OF za23_emp_cap,
        gs_training_v TYPE za23_emp_cap.

  " TREE STRUCTURE

  DATA: go_salv_tree TYPE REF TO cl_salv_tree,
        gt_ade_tree TYPE TABLE OF zhr_de_ar_emp_tree_alfa02.

  DATA: gt_ade_temp_tree TYPE TABLE OF zhr_de_ar_emp_tree_alfa02.

" PAYROLL RECORD HISTORY
DATA gt_zhrv TYPE TABLE OF zhrv_p_e_alfa02.

  "
  TYPES: BEGIN OF gty_cap,
    bbdd        TYPE abap_bool,
    field_style TYPE lvc_t_styl.
    INCLUDE STRUCTURE za23_capac.
  TYPES: END OF gty_cap.

  DATA: gt_cap TYPE TABLE OF gty_cap.

" BY INITIAL SCREEN
DATA: gv_add_employee.
"RB
DATA: rb1_gn_male,
      rb2_gn_female.


DATA: box_employee_name TYPE string.

" JOB ASSIGNMENT
DATA: box_position_name TYPE string,
      box_name_area TYPE string.

" ALL THE CLASS
CLASS lcl_validate_data DEFINITION DEFERRED. " DEFINITION CLASS
CLASS lcl_events_receivers DEFINITION DEFERRED. "events of handle_hostpot_click
CLASS lcl_transaction DEFINITION DEFERRED.
CLASS lcl_generate_id DEFINITION DEFERRED.

DATA go_validate TYPE REF TO lcl_validate_data. " variable for user in the class
DATA go_events_receiver TYPE REF TO lcl_events_receivers.
DATA go_register_emp TYPE REF TO lcl_transaction.
DATA go_generate_id TYPE REF TO lcl_generate_id.

" endclass

"confirmation ins
DATA: gv_flag_emp TYPE abap_bool,
      gv_gent_id_emp TYPE abap_bool,
      gv_flag_tra TYPE abap_bool.

" ICON
DATA: icon_1 TYPE icons-text,
      warning_light1 TYPE char30,
      icon_2 TYPE icons-text,
      warning_light2 TYPE char30,
      icon_3 TYPE icons-text,
      warning_light3 TYPE char30,
      icon_4 TYPE icons-text,
      warning_light4 TYPE char30,
      icon_5 TYPE icons-text,
      warning_light5 TYPE char30,
      icon_6 TYPE icons-text,
      warning_light6 TYPE char30,
      icon_7 TYPE icons-text,
      warning_light7 TYPE char30,
      icon_8 TYPE icons-text,
      warning_light8 TYPE char30,
      icon_9 TYPE icons-text,
      warning_light9 TYPE char30,
      icon_10 TYPE icons-text,
      warning_light10 TYPE char30,
      icon_11 TYPE icons-text,
      warning_light11 TYPE char30,
       icon_12 TYPE icons-text,
      warning_light12 TYPE char30,
       icon_13 TYPE icons-text,
      warning_light13 TYPE char30,
       icon_14 TYPE icons-text,
      warning_light14 TYPE char30,
       icon_15 TYPE icons-text,
      warning_light15 TYPE char30,
       icon_16 TYPE icons-text,
      warning_light16 TYPE char30,
       icon_17 TYPE icons-text,
      warning_light17 TYPE char30,
       icon_18 TYPE icons-text,
      warning_light18 TYPE char30.

"--------
      TYPES: BEGIN OF gs_name,
        name TYPE string.
      TYPES: END OF gs_name.
      DATA: ls_name2 TYPE gs_name,
            lt_name2 TYPE TABLE OF gs_name.

" CREATE PDF
  TYPE-POOLS: slis.
  "use of the table gt_zhrv
  DATA: gt_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.
  "structure pdf
  DATA: BEGIN OF gt_objaux OCCURS 0.
        INCLUDE STRUCTURE tline.
  DATA: END OF gt_objaux.

  DATA: path TYPE string,
        fullpath TYPE string.

  data: gv_file type string.

  DATA: gt_v_p_e_alfa02 TYPE TABLE OF zhrv_p_e_alfa02.

  DATA: RBT_ACT,
        RBT_DES.
