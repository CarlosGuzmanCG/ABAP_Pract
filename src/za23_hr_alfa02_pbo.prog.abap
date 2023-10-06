*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_2000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_2000 OUTPUT.

 SET PF-STATUS 'STATUS_2000'.
 SET TITLEBAR 'TITLE_2000'.
* clear: ok_code.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SEARCH_ID_NAME_CURD_RFC OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE search_criteria OUTPUT.

  DATA: lcl_search TYPE REF TO zcl_search_criteria.

  CREATE OBJECT lcl_search.

  CALL METHOD lcl_search->search.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3000 OUTPUT.
  CLEAR: ok_code.
 SET PF-STATUS 'STATUS_3000'." EXCLUDING gv_ui_func.
 SET TITLEBAR 'TITLE_3000'.
 IF gv_init IS INITIAL. "AND gv_code3004 IS NOT INITIAL.
*   PERFORM set_list-box.
     PERFORM set_handlers.
     gv_init = 'X'.
 ENDIF.

* IF gv_code3004 = 'DES_BOX'.
*   PERFORM set_handlers_edit.
* ENDIF.



ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3001 OUTPUT.

  IF gv_code3004 <> 'DES_BOX'.
    SET PF-STATUS 'RH_STATUS_3001'.
  ENDIF.

  IF gv_code3004 EQ 'DES_BOX'.
    SET PF-STATUS 'SHOW_EMP_STS_3004'.
    LOOP AT SCREEN.
      IF screen-group1 = 'ABC'.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
      IF screen-name = 'BTN_DLT_FAM'.
        screen-active = 0.
        MODIFY SCREEN.
        EXIT.
      ENDIF.
    ENDLOOP.
*      SET PF-STATUS 'SHOW_STATUS_3004'.
  ENDIF.

  CASE gv_code.
    WHEN 'ACT_DEL' or 'ACT_DEL_FAM'.
      LOOP AT SCREEN.
        IF screen-name = 'BTN_DLT_FAM'.
          screen-active = 1.
          MODIFY SCREEN.
          EXIT.
        ENDIF.
      ENDLOOP.
    WHEN 'DES_DEL' or 'DES_DEL_FAM'.
       LOOP AT SCREEN.
         IF screen-name = 'BTN_DLT_FAM'.
          screen-active = 0.
          MODIFY SCREEN.
          EXIT.
         ENDIF.
       ENDLOOP.
    WHEN OTHERS.
  ENDCASE.

 SET TITLEBAR 'TITLE_3001'.
ENDMODULE.

*  IF gv_code3004 <> 'DES_BOX'.
*    SET PF-STATUS 'RH_STATUS_3001'.
*  ENDIF.
*
*  IF gv_code3004 EQ 'DES_BOX'.
*    SET PF-STATUS 'SHOW_EMP_STS_3004'.
*    LOOP AT SCREEN.
*      IF screen-group1 = 'ABC'.
*        screen-input = 1.
*      ENDIF.
*      MODIFY SCREEN.
*      IF screen-name = 'BTN_DLT_FAM'.
*        screen-active = 0.
*        MODIFY SCREEN.
*        EXIT.
*      ENDIF.
*    ENDLOOP.
**      SET PF-STATUS 'SHOW_STATUS_3004'.
*  ELSEIF gv_code3004 NE 'DES_BOX'.
*    LOOP AT SCREEN.
*      IF screen-group1 = 'ABC'.
*        screen-input = 0.
*      ENDIF.
*      MODIFY SCREEN.
*      IF screen-name = 'BTN_DLT_FAM'.
*        screen-active = 0.
*        MODIFY SCREEN.
*        EXIT.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*
*
*  CASE gv_code.
*    WHEN 'ACT_DEL'.
*      LOOP AT SCREEN.
*        IF screen-name = 'BTN_DLT_FAM'.
*          screen-active = 1.
*          MODIFY SCREEN.
*          EXIT.
*        ENDIF.
*      ENDLOOP.
*    WHEN 'DES_DEL'.
*       LOOP AT SCREEN.
*         IF screen-name = 'BTN_DLT_FAM'.
*          screen-active = 0.
*          EXIT.
*          MODIFY SCREEN.
*         ENDIF.
*       ENDLOOP.
*
*    WHEN 'DES_DEL_FAM'.
*      LOOP AT SCREEN.
*        IF screen-name = 'BTN_DLT_FAM'.
*          screen-active = 0.
*          MODIFY SCREEN.
*          EXIT.
*        ENDIF.
*      ENDLOOP.
*    WHEN 'ACT_DEL_FAM'.
*      LOOP AT SCREEN.
*        IF screen-name = 'BTN_DLT_FAM'.
*          screen-active = 1.
*          MODIFY SCREEN.
*          EXIT.
*        ENDIF.
*      ENDLOOP.
*    WHEN OTHERS.
*  ENDCASE.
*
* SET TITLEBAR 'TITLE_3001'.
*ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3000 OUTPUT.
  PERFORM init_3000.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  START_ALV_3000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE start_alv_3000 INPUT.
*  PERFORM instance_alv.
*ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3001 OUTPUT.
  PERFORM init_3001.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3002 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3002 OUTPUT.

  CASE gv_code.
    WHEN 'ACT_DEL'.
      LOOP AT SCREEN.
        IF screen-name = 'BTN_DLT_SKIL'.
          screen-active = 1.
          MODIFY SCREEN.
          EXIT.
        ENDIF.
      ENDLOOP.
    WHEN 'DES_DEL'.
      LOOP AT SCREEN.
        IF screen-name = 'BTN_DLT_SKLL'.
          screen-active = 0.
          MODIFY SCREEN.
          EXIT.
        ENDIF.
      ENDLOOP.
    WHEN 'DES_DEL_SKILL'.
      LOOP AT SCREEN.
        IF screen-name = 'BTN_DLT_SKLL'.
          screen-active = 0.
          MODIFY SCREEN.
          EXIT.
        ENDIF.
      ENDLOOP.
    WHEN 'ACT_DEL_SKILL'.
      LOOP AT SCREEN.
        IF screen-name = 'BTN_DLT_SKIL'.
          screen-active = 1.
          MODIFY SCREEN.
          EXIT.
        ENDIF.
      ENDLOOP.
    WHEN OTHERS.
  ENDCASE.

  IF gv_code3004 = 'DES_BOX'.
    SET PF-STATUS 'SHOW_EMP_STS_3004'.
    LOOP AT SCREEN.
      IF screen-group1 = 'ABC'.
        screen-input = 0.
      ENDIF.
      IF screen-name = 'BTN_DLT_SKLL'.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.

  IF gv_code3004 <> 'DES_BOX'.
    SET PF-STATUS 'RH_STATUS_3002'.
  ENDIF.

 SET TITLEBAR 'TITLE_3002'.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3002 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3002 OUTPUT.
 PERFORM init_3002.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3003 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3003 OUTPUT.

  CASE gv_code.
    WHEN 'ACT_JOB' .
      IF gv_id_emp IS NOT INITIAL OR lv_boolact EQ abap_true.
        lv_boolact = abap_true.
        SELECT SINGLE * FROM za23_empleados INTO @DATA(lv_data_emp)
         WHERE id_empleado = @gv_id_emp.
        za23_empleados-id_empleado = lv_data_emp-id_empleado.
        box_employee_name = | { lv_data_emp-nombre } | & | { lv_data_emp-apellido_paterno } | & | { lv_data_emp-apellido_materno } |.
        PERFORM set_list-box.
        za23_empleados-nombre = box_employee_name.
        lv_txt_id_emp = za23_empleados-id_empleado.
        gv_init = 'X'.
*      WHEN 'DES_JOB'.
*        perform set_id_emp.
*    WHEN
      ENDIF.

  ENDCASE.

  DATA: lv_num TYPE c.
  IF gv_act_button NE 'DES_UPD'.
    lv_num = 1.
    PERFORM disable_display_element USING lv_num.
  ELSE.
    lv_num = 1.
    PERFORM disable_display_element USING lv_num.
  ENDIF.

 SET TITLEBAR 'TITLE_3003'.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3003 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3003 OUTPUT.
  PERFORM init_3003.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_2300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_2300 OUTPUT.
 SET PF-STATUS 'STATUS_2300'.
* SET TITLEBAR 'xxx'.  AGREGAR
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3004 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3004 OUTPUT.

 IF gv_code3004 <> 'DES_BOX'.
   SET PF-STATUS 'STATUS_3004'.
   SET TITLEBAR 'TITLE_3004'.
 ENDIF.

 PERFORM set_handlers_edit.

 IF gv_rec_check EQ abap_false.
   gv_init = 'X'.
   LOOP AT SCREEN.
     IF screen-name = 'ADD_FAMILY' OR  screen-name = 'ADD_SKILL' .
       screen-active = 0.
     ENDIF.
     MODIFY SCREEN.
   ENDLOOP.
 ENDIF.

 IF gv_code3004 = 'DES_BOX'.
   LOOP AT SCREEN.
     IF screen-group1 = 'ABC'.
       screen-input = 0.
     ELSEIF screen-name = 'ADD_FAMILY' OR screen-name = 'ADD_SKILL'.
       screen-active = 0.
     ENDIF.
     MODIFY SCREEN.
   ENDLOOP.
   SET PF-STATUS 'SHOW_EMP_STS'.
   SET TITLEBAR 'TITLE_3004_1'.
 ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3004 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3004 OUTPUT.
  PERFORM init_3004.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3005 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3005 OUTPUT.
 SET PF-STATUS 'STATUS_3005'.
 SET TITLEBAR 'TITLE_3005'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3005 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3005 OUTPUT.
  PERFORM init_3005.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3006 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3006 OUTPUT.
 SET PF-STATUS 'STATUS_3006'.
 SET TITLEBAR 'TITLE_3006'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3006 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3006 OUTPUT.
  PERFORM init_3006.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3007 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3007 OUTPUT.
 SET PF-STATUS 'STATUS_3007'.
 SET TITLEBAR 'TITLE_3007'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3007 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3007 OUTPUT.
  PERFORM init_3007.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3009 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3009 OUTPUT.
 SET PF-STATUS 'STATUS_3009'.
 SET TITLEBAR 'TITLE_3009'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3009 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3009 OUTPUT.
  PERFORM init_3009.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3100 OUTPUT.
 SET PF-STATUS 'STATUS_3100'.
 SET TITLEBAR 'TITLE_3100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3100 OUTPUT.
  PERFORM init_3100.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3101 OUTPUT.
 SET PF-STATUS 'STATUS_3101'.
 SET TITLEBAR 'TITLE_3101'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3101 OUTPUT.
  PERFORM init_3101.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3102 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3102 OUTPUT.

    CASE gv_code.
      WHEN 'DES_UPD' OR 'ACT_UPD'.
        PERFORM set_list_training-box.
        gv_init = 'X'.
      WHEN OTHERS.
    ENDCASE.

    IF gv_code = 'ACT_UPD'.
      LOOP AT SCREEN.
        IF screen-name = 'ZA23_EMPLEADOS-ID_EMPLEADO'.
          screen-input = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.

      MOVE-CORRESPONDING gs_train TO gs_train_upd.
      PERFORM find_data_emp_assig_course.
    ELSE.
      LOOP AT SCREEN.
        IF screen-name = 'ZA23_EMPLEADOS-ID_EMPLEADO'.
          screen-input = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.

 SET PF-STATUS 'STATUS_3102'.
 SET TITLEBAR 'TITLE_3102'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3102 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3102 OUTPUT.
  PERFORM init_3102.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3200 OUTPUT.
 SET PF-STATUS 'STATUS_3200'.
 SET TITLEBAR 'TITLE_3200'.


 CASE gv_code.
 	WHEN 'ACT_LIST'.
    PERFORM set_list_area-box.
    gv_init = 'X'.
 	WHEN ''.
 	WHEN OTHERS.
 ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3200 OUTPUT.
  PERFORM init_3200.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3201 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3201 OUTPUT.
 SET PF-STATUS 'STATUS_3201'.
 SET TITLEBAR 'TITLE_3201'.
  CASE gv_code.
 	WHEN 'ACT_LIST'.
    PERFORM set_list_area-box.
    gv_init = 'X'.
 	WHEN ''.
 	WHEN OTHERS.
 ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3201 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3201 OUTPUT.
  PERFORM init_3201.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3203 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3203 OUTPUT.
 SET PF-STATUS 'STATUS_3203'.
* SET TITLEBAR 'xxx'.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3203 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3203 OUTPUT.
 PERFORM init_3203.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3300 OUTPUT.
 gv_tabname = 'ZA23V_EMP_VAC'.
 SET PF-STATUS 'STATUS_3300'.
 SET TITLEBAR 'TITLE_3300'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3300 OUTPUT.
  PERFORM init_3300.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3301 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3301 OUTPUT.
 SET PF-STATUS 'STATUS_330_1'.
 SET TITLEBAR 'TITLE_3301'.

 IF za23_vac_perm-id_empleado IS NOT INITIAL.

   SELECT SINGLE nombre, apellido_paterno, apellido_materno FROM za23_empleados
     WHERE id_empleado EQ @za23_vac_perm-id_empleado INTO @DATA(ls_emp).

   IF sy-subrc EQ 0.
     CONCATENATE ls_emp-nombre ls_emp-apellido_paterno ls_emp-apellido_materno INTO za23_empleados-nombre SEPARATED BY space.
   ELSE.
     CLEAR: za23_empleados, za23_vac_perm.
     MESSAGE s024(zemp_alfa02) DISPLAY LIKE 'W'.
   ENDIF.

 ENDIF.

 IF gv_act = 'DES_UPD'.
   LOOP AT SCREEN.
     IF screen-name EQ 'BT_DEL'.
       screen-invisible = 1.
       MODIFY SCREEN.
       EXIT.
     ENDIF.
   ENDLOOP.
 ELSEIF gv_act = 'ACT_UPD'.
   LOOP AT SCREEN.
     IF screen-name EQ 'BT_DEL'.
       screen-invisible = 0.
       MODIFY SCREEN.
     ENDIF.
     IF screen-name EQ 'ZA23_VAC_PERM-ID_EMPLEADO'.
       screen-input = 0.
       MODIFY SCREEN.
     ENDIF.
   ENDLOOP.
 ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3301 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3301 OUTPUT.
  PERFORM init_3301.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3010 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3010 OUTPUT.
 SET PF-STATUS 'STATUS_3010'.
 SET TITLEBAR 'STATUS_3010'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_3010 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_3010 OUTPUT.
 PERFORM init_3010.
ENDMODULE.
