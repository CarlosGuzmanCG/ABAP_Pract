*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.

*  IF SY-uname EQ 'ASCSA'.

 ok_code = sy-ucomm.

 DATA(lv_clear_SCRREN) = |CLEAR_SCREEN_{ sy-dynnr }|.
 PERFORM (lv_clear_SCRREN) IN PROGRAM (sy-repid) IF FOUND.

 CASE ok_code.
   WHEN 'CANCEL' OR 'BACK' OR 'EXIT'."-------------CANCEL-------------------------
     LEAVE PROGRAM.
   WHEN 'BT_ADD_EMP'."-----------------------------EMPLOYEE REGISTRATION----------
     PERFORM call_add_employee.
   WHEN 'BT_JOB_POS'."-----------------------------JOB ASSIGNMENT-----------------
     perform initial_job_pos.
     CALL SCREEN 3003.
   WHEN 'BT_UPD_EMP'."-----------------------------UPDATE EMPLOYEE----------------
     PERFORM instance_alv_emp.
     CALL SCREEN 3004.
   WHEN 'BT_LAY'."---------------------------------LAYOFF-------------------------
     CALL SCREEN 3006.
   WHEN 'BT_SW_EMP'."------------------------------VIEW EMPLOYEE------------------
     gv_code3004 = 'DES_BOX'.
     PERFORM instance_alv_emp.
     CALL SCREEN 3004.
   WHEN 'BT_ADE'."---------------------------------VIEW EMPLOYEES-----------------
     CALL TRANSACTION 'ZHR_VIEW_EMPS'.
   WHEN 'BT_ASS_HIS'."----------------------------ASSIGNMENT HISTORY-------------
     CALL TRANSACTION 'ZHR_ASSIG_HISTORY'.
   WHEN 'BT_TRA_PROG'."---------------------------MANAGE TRAINING----------------
     CALL SCREEN 3009.
   WHEN 'BT_ENR_TRA_PRO'."------------------------ENROLL IN A TRAINING PROGRAM---
     CALL SCREEN 3101.
   WHEN 'BT_LEA_VAC'."----------------------------LEAVE AND VACATION MANAGEMENT--
     call TRANSACTION 'ZHR_LEAVE_VACATION'.
   WHEN 'BT_PAY_REC'. "---------------------------PAYROLL RECORD-----------------
     gv_code = 'ACT_LIST'.
     CALL SCREEN 3200.
   WHEN 'BT_PAY_REC_HIS'."------------------------PAYROLL RECORD HISTORY---------
     gv_code = 'ACT_LIST'.
     CALL SCREEN 3201.
   WHEN ''.

 ENDCASE.

* ELSE.
*
*    MESSAGE 'The username is not correct' TYPE 'S'.
*
* ENDIF.

ENDMODULE.

*MODULE user_command_2000 INPUT.
*
* ok_code = sy-ucomm.
*
* DATA(lv_clear_SCRREN) = |CLEAR_SCREEN_{ sy-dynnr }|.
* PERFORM (lv_clear_SCRREN) IN PROGRAM (sy-repid) IF FOUND.
*
* CASE ok_code.
*   WHEN 'CANCEL' OR 'BACK' OR 'EXIT'.     "----------------CANCEL----------------------
*      LEAVE PROGRAM.
*   WHEN 'BT_ADD_EMP'. "----------------ADD EMPLOYEE----------------
*      PERFORM call_add_employee.
*   WHEN 'BT_JOB_POS'.  "---------------JOB POSITION---------------
*      CLEAR: lv_txt_id_emp, za23_empleados.
*      PERFORM clear_screen_3003.
*      lv_boolact = abap_true.
*      gv_code = 'ACT_JOB'.
*      CALL SCREEN 3003.
*   WHEN 'BT_UPD_EMP'.  "---------------UPDATE EMPLOYEE------------
*      CREATE OBJECT go_validate.
*      CLEAR: lv_txt_id_emp, za23_empleados-id_empleado.
*      PERFORM instance_alv_emp.
*      CALL SCREEN 3004.
*   WHEN 'BT_ADE'.      "---------------SHOW EMPLOYEES--------------
*      gv_code = 'SRCH_FOR_ALL_DATA'.
*      CALL SCREEN 3005.
*   WHEN 'BT_LAY'.      "-----------------LAYOFF----------------------------------
*      CALL SCREEN 3006.
*   WHEN 'BT_SW_EMP'.   "-----------------SHOW EMPLOYEE---------------------------
*      gv_code3004 = 'DES_BOX'.
*      CREATE OBJECT go_validate.
*      PERFORM instance_alv_emp.
*      CALL SCREEN 3004.
*    WHEN 'BT_ASS_HIS'.  "-----------------ASSIGNMENT HISTORY----------------------
*      CALL SCREEN 3007.
*    WHEN 'BT_TRA_PROG'. "-----------------ADD TRAINING----------------------------
*      CALL SCREEN 3009.
*    WHEN 'BT_ENR_TRA_PRO'. "--------------ENROLL IN A TRAINING PROGRAM------------
*      CALL SCREEN 3101.
*    WHEN 'BT_LEA_VAC'. "------------------LEAVE AND VACATION MANAGEMENT-----------
*      gv_tabname = 'ZA23V_EMP_VAC'.
*      CALL SCREEN 3300.
*    WHEN 'BT_PAY_REC'. "------------------PAYROLL RECORD--------------------------
*      gv_code = 'ACT_LIST'.
*      CALL SCREEN 3200.
*    WHEN 'BT_PAY_REC_HIS'. "-------------PAYROLL RECORD HISTORY-------------------
*      gv_code = 'ACT_LIST'.
*      CALL SCREEN 3201.
*    WHEN ''.
*  ENDCASE.
*
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3000 INPUT.
DATA subr_clear TYPE c LENGTH 17.

subr_clear = |CLEAR_SCREEN_{ sy-dynnr }|.
  ok_code = sy-ucomm.
*  DATA(lv_clear) = |CLEAR_SCREEN_{ SY-DYNNR }|.
**  PERFORM navigation.
*  PERFORM release_resources_employee.
  CASE ok_code.
    WHEN 'BACK'.
      PERFORM (subr_clear) IN PROGRAM (sy-repid) IF FOUND.

CALL FUNCTION 'DEQUEUE_EZA23_EMPLEADOS'
 EXPORTING
   mode_za23_empleados       = 'E'
   mandt                     = sy-mandt.


      LEAVE TO SCREEN 0.
*    WHEN 'CANCEL'.
**       SET SCREEN 0.
**      PERFORM (lv_refresh) IN PROGRAM (sy-repid) IF FOUND.
*      PERFORM (lv_clear) IN PROGRAM (sy-repid) IF FOUND.
*      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3001 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'CANCEL' .
      CLEAR: ls_family.
      LEAVE TO SCREEN 0.
    WHEN 'BACK'.
      CLEAR: ls_family.
      LEAVE TO SCREEN 0.
*      SET CURSOR FIELD 'BOX_5'.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
 SET SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3003  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3003 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'EXIT'.
      PERFORM clear_screen_3003.
      PERFORM (lv_refresh) IN PROGRAM (sy-repid) IF FOUND.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      PERFORM clear_screen_3003.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_EXIT_COMMAND_3000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_exit_command_3000 INPUT.
  ok_code = sy-ucomm.
  DATA(lv_clear) = |CLEAR_SCREEN_{ sy-dynnr }|.
*  PERFORM navigation.

*  DATA: l_tcode TYPE SHKONTEXT-TCODE.
*PARA SABER EN QUE TRANSACCION ESTAMOS
*CALL 'GET_PARAM_TCOD' ID 'PTCOD' FIELD l_tcode.

  CASE ok_code.
    WHEN 'BACK'.
*      CLEAR lv_txt_id_emp.
*      PERFORM clear_screen_3003.
*
      PERFORM release_user_lock.

      CLEAR gv_code3004.
      PERFORM release_resources_employee. "

*      PERFORM (lv_clear) IN PROGRAM (sy-repid) IF FOUND.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      CLEAR gv_code3004.
      PERFORM release_user_lock.
      PERFORM release_resources_employee.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      CLEAR gv_code3004.
      PERFORM release_user_lock.
      PERFORM release_resources_employee.
*       SET SCREEN 0.
*      PERFORM (lv_refresh) IN PROGRAM (sy-repid) IF FOUND.
      PERFORM (lv_clear) IN PROGRAM (sy-repid) IF FOUND.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3004  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3004 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
*    WHEN 'BACK'.

    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_EMPLOYEE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_employee INPUT.

   DATA: lcl_search_data_emp TYPE REF TO zcl_hr_data_emp_alfa02,
         ls_employee LIKE LINE OF zcl_hr_data_emp_alfa02=>gt_employee,
         ls_data_emp TYPE za23_empleados,
         lv_bool TYPE abap_bool.

   CREATE OBJECT lcl_search_data_emp.

   CLEAR: gt_skill, gt_family.

   CALL METHOD lcl_search_data_emp->search_employee "EMPLOYEE INFORMATION SEARCH CLASS
     EXPORTING
       id_employee = za23_empleados-id_empleado
     IMPORTING
       ls_employee = ls_employee
       lv_bool     = lv_bool.

   IF lv_bool EQ abap_true. "CHECK IF THE RECORD EXISTS
      PERFORM lock_obj_employee USING ls_employee. " BLOCK DATA
   ELSE.
     gv_rec_check = abap_false.
     CLEAR: za23_empleados, gt_skill[], gt_family[]. " DATA CLEANING
     PERFORM refresh_alv_fam.
     PERFORM refresh_alv_skill.
     MESSAGE s024(zemp_alfa02) WITH TEXT-003 DISPLAY LIKE 'W'."THE USER YOU ARE TRYING TO SEARCH DOES NOT EXIST
  ENDIF.

  IF lcl_search_data_emp IS BOUND.
    CLEAR: lcl_search_data_emp. "DATA CLEANING
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_EXIT_COMMAND_3005  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_exit_command_3005 INPUT.

  ok_code = sy-ucomm.
*  DATA(lv_refresh) = |CLEAR_SCREEN_{ sy-dynnr }|.
  CASE ok_code.
    WHEN 'BACK'.
      clear: cond,gv_tab_where[].
        PERFORM clear_container_ade.
*      PERFORM (lv_clear) IN PROGRAM (sy-repid) IF FOUND.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      clear: cond,gv_tab_where[].
      CLEAR: gs_employee.
      PERFORM clear_container_ade.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      clear: cond,gv_tab_where[].
      CLEAR: gs_employee.
      PERFORM clear_container_ade.
      LEAVE PROGRAM.
*       SET SCREEN 0.
*      PERFORM (lv_refresh) IN PROGRAM (sy-repid) IF FOUND.
*      PERFORM (lv_clear) IN PROGRAM (sy-repid) IF FOUND.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SEARCH_EMPLOYEE_ID  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE search_employee_id INPUT.

  SELECT SINGLE id_empleado FROM za23_empleados INTO @gs_employee
    WHERE id_empleado = @gs_employee-id_empleado AND status EQ 'ACT'.

  IF sy-subrc EQ 0.
    gv_code = 'SRCH_FOR_DATA'.
    clear cond.
    cond = 'ID_EMPLEADO = @GS_EMPLOYEE-ID_EMPLEADO'.
    APPEND cond TO gv_tab_where.
    PERFORM get_salv_data.
  ELSE.
    MESSAGE w024(zemp_alfa02).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_EXIT_COMMAND_3006  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_exit_command_3006 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'BACK'.
      PERFORM clear_screen_3006.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      PERFORM clear_screen_3006.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      PERFORM clear_screen_3006.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SEARCH_EMP_ID  INPUT
*&---------------------------------------------------------------------*
*       text
*  DATA: lcl_search_emp TYPE REF TO zcl_hr_data_emp_alfa02,

*        lv_flag TYPE abap_bool. "'ZHRV_S_E_ALFA02'
*ls_zhrv      TYPE zhrv_s_e_alfa02, "VIEW DATABASE
**----------------------------------------------------------------------*
MODULE search_emp_id INPUT.

  DATA: lv_tab_name  TYPE string,
        ls_zhrv      TYPE ZHRV_EMP_ALFA02, "VIEW DATABASE
        name         TYPE string.
  FIELD-SYMBOLS: <lt_history_reports> TYPE ANY TABLE.
  lv_tab_name = 'ZHRV_EMP_ALFA02'.

  SELECT SINGLE * FROM (lv_tab_name) INTO @ls_zhrv
    WHERE id_empleado = @za23_bajas_emp-id_empleado .

  IF sy-subrc EQ 0.

    IF sy-subrc EQ 0.
      za23_empleados-fecha_baja = sy-datum.
      name = |{ ls_zhrv-nombre } { ls_zhrv-apellido_paterno
      } { ls_zhrv-apellido_materno }|.
      box_employee_name = name.
      box_position_name = ls_zhrv-nombre_puesto.
      box_name_area = ls_zhrv-nombre_area.
      gv_flag_emp = abap_true.
    ELSE.
      CLEAR: za23_bajas_emp, box_employee_name,box_name_area,
             box_position_name, za23_bajas_emp-id_empleado.
      MESSAGE s025(zemp_alfa02) DISPLAY LIKE 'W'.
    ENDIF.

  ELSE.
    CLEAR: za23_bajas_emp, box_employee_name,box_name_area,
           box_position_name, za23_bajas_emp-id_empleado.
    MESSAGE w025(zemp_alfa02).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3007  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3007 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      PERFORM free_emp_hist_rep.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      PERFORM free_emp_hist_rep.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3009  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3009 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'BACK'.
      PERFORM free_training.
      PERFORM free_container.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      PERFORM free_training.
      PERFORM free_container.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      PERFORM free_training.
      PERFORM free_container.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3100 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'CANCEL'.
      CLEAR za23_capac.
      LEAVE TO SCREEN 0.
    WHEN 'BACK'.
      CLEAR za23_capac.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND3009  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command3009 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'CREATEENTRY'.
      CALL SCREEN 3100 STARTING AT 10 05 ENDING AT 143 15.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND3101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command3101 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'CREATEENTRY'.
      gv_code = 'DES_UPD'.
      CLEAR: za23_empleados, za23_capac.
      CALL SCREEN 3102 STARTING AT 10 05 ENDING AT 141 17.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3101 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'EXIT'.
      PERFORM free_container.
      PERFORM free_training.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      PERFORM free_container.
      PERFORM free_training.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3102 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'CANCEL' OR 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SEARCH_ID_ASIG  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE search_id_asig INPUT.

  gv_flag_emp = abap_false.

  SELECT SINGLE * FROM za23_empleados INTO @DATA(ls_searchid) WHERE id_empleado EQ @za23_empleados-id_empleado
    AND status EQ 'ACT'.

    IF sy-subrc EQ 0.
      SELECT * FROM za23_asigemp WHERE id_empleado EQ @za23_empleados-id_empleado AND
        status = 'ACT' ORDER BY id_asignacion INTO @DATA(ls_asig) UP TO 1 ROWS.
      ENDSELECT.
      IF sy-subrc EQ 0.
        gv_flag_emp = abap_true.
        DATA(lv_name) = |{ ls_searchid-nombre } { ls_searchid-apellido_paterno } { ls_searchid-apellido_materno }|.
      za23_emp_cap-id_empleado = ls_asig-id_empleado.
      za23_emp_cap-id_asignacion = ls_asig-id_asignacion.
      za23_empleados-nombre = lv_name.
      ELSE.
        CLEAR: za23_empleados, za23_capac,za23_emp_cap-id_asignacion.
        MESSAGE s019(zemp_alfa02) DISPLAY LIKE 'W'.
      ENDIF.
    ELSE.
      CLEAR:za23_empleados, za23_capac,za23_emp_cap-id_asignacion.
      MESSAGE s018(zemp_alfa02) DISPLAY LIKE 'W'.
    ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3200 INPUT.

 ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'EXIT'.
      PERFORM free_cont_payroll.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      PERFORM free_cont_payroll.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3201  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3201 INPUT.

*  DATA: lo_query_builder TYPE REF TO cl_sql_query_builder.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'EXIT'.
      PERFORM free_container_pay_rec_his.
      LEAVE TO SCREEN 0.
     WHEN 'CANCEL'.
      PERFORM free_container_pay_rec_his.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3203  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3203 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3300 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'EXIT'.
      PERFORM free_cont_vac_perm_emp.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      PERFORM free_cont_vac_perm_emp.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3301  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3301 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'CANCEL'.
      PERFORM clear_data_vac_perm.
      LEAVE TO SCREEN 0.
    WHEN 'BACK'.
      PERFORM clear_data_vac_perm.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SEARCH_ID_VAC_PERM_EMP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE search_id_vac_perm_emp INPUT.

  IF za23_empleados-id_empleado IS NOT INITIAL.

    gv_code = 'SRCH_FOR_DATA'.
    clear: cond, gv_tab_where[],gv_tab_where.
    cond = 'id_empleado eq @za23_empleados-id_empleado'.
    APPEND cond TO gv_tab_where.

    PERFORM get_data_lea_vac.
*    PERFORM get_data_lea_vac_emp.
    IF go_events_receiver IS NOT BOUND.
      PERFORM go_container_lea_vac.
    ELSE.
      PERFORM refresh_container.
    ENDIF.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3010  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3010 INPUT.

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'BACK'.
      CLEAR: za23_empleados.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      CLEAR: za23_empleados.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ACT_EMPLOYEE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE act_employee INPUT.

  SELECT SINGLE * FROM za23_empleados WHERE id_empleado EQ @za23_empleados-id_empleado AND status EQ 'DES' INTO @DATA(ls_act_emp).

  IF sy-subrc EQ 0.
    za23_empleados-nombre = |{ ls_act_emp-nombre } { ls_act_emp-apellido_paterno } { ls_act_emp-apellido_materno }|.
    MODIFY SCREEN.
  ELSE.
    CLEAR za23_empleados.
    MESSAGE 'the user not exists' TYPE 'W'.
  ENDIF.

ENDMODULE.
