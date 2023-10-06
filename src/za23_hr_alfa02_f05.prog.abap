*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_F05
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_3300
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text ZA23V_EMP_VAC
*&---------------------------------------------------------------------*
FORM init_3300 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'EXECUTE' OR 'BT_SH_DATA'.
      clear: za23_empleados-id_empleado, gv_tab_where, gv_tab_where[].
      PERFORM get_data_lea_vac.
      IF go_events_receiver IS NOT BOUND.
        PERFORM go_container_lea_vac.
      ELSE.
        PERFORM refresh_container.
      ENDIF.
    WHEN 'CREATEENTRY'.
      gv_act = 'DES_UPD'.
      CALL SCREEN 3301 STARTING AT 10 05 ENDING AT 80 14.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3301
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3301 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'SAVE'.
      PERFORM save_upd_data_assig_lea_vac.
    WHEN 'BT_DEL'.
*      data: lt_vac_emp type table of za23_vac_perm.
*      MOVE-CORRESPONDING gt_emp_cap to lt_vac_emp.
      DELETE za23_vac_perm from za23_vac_perm.
      clear: gt_emp_cap, za23_vac_perm.
      PERFORM get_data_lea_vac.
      PERFORM refresh_container.
      leave TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_upd_data_assig_lea_vac
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_upd_data_assig_lea_vac .

  DATA: lv_flag TYPE abap_bool.

    CASE gv_act.
      WHEN 'DES_UPD'.

        PERFORM check_registration_dates USING lv_flag . "CHECK IF YOU HAVE NO REGISTRATION ON THESE DATES

        IF lv_flag EQ abap_false.
           PERFORM generate_id_vac. " USING lv_id. "id generator
           PERFORM save_data_vac_perm.
        ELSE.
          CLEAR: za23_empleados-nombre, za23_vac_perm.
          MESSAGE s032(zemp_alfa02) DISPLAY LIKE 'E'.
          leave to SCREEN 0.
        ENDIF.

      WHEN 'ACT_UPD'.

        PERFORM upd_data_vac_perm.

      WHEN ''.
      WHEN ''.
      WHEN OTHERS.
    ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_REGISTRATION_DATES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_FLAG ZA23V_EMP_VAC
*&---------------------------------------------------------------------*
FORM check_registration_dates  CHANGING p_lv_flag TYPE abap_bool.

  SELECT  SINGLE * FROM za23_vac_perm
    WHERE id_empleado EQ @za23_vac_perm-id_empleado AND
   fecha_inicio eq ( SELECT fecha_inicio FROM za23_vac_perm
    WHERE fecha_inicio EQ @za23_vac_perm-fecha_inicio AND id_empleado EQ @za23_vac_perm-id_empleado )
     AND fecha_fin eq ( SELECT fecha_fin FROM za23_vac_perm
    WHERE fecha_fin EQ @za23_vac_perm-fecha_fin
     AND id_empleado EQ @za23_vac_perm-id_empleado ) INTO @DATA(lv_v_emp_cap).

  IF sy-subrc EQ 0 and lv_v_emp_cap-id_empleado eq za23_vac_perm-id_empleado
    and lv_v_emp_cap-fecha_inicio < lv_v_emp_cap-fecha_fin.

    p_lv_flag = abap_true.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form generate_id_vac SUBMIT ZA23_GENERATE_ID_VAC.
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_ID     id_vac_perm
*&---------------------------------------------------------------------*
FORM generate_id_vac."  CHANGING lv_num TYPE numc10 .

  DATA lv_num TYPE numc10.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr                   = '01'
      object                        = 'ZRH_ID_VAC' "NUMBER RANGE OBJECT
   IMPORTING
     number                        = lv_num
   EXCEPTIONS
     interval_not_found            = 1
     number_range_not_intern       = 2
     object_not_found              = 3
     quantity_is_0                 = 4
     quantity_is_not_1             = 5
     interval_overflow             = 6
     buffer_overflow               = 7
     OTHERS                        = 8 .

  IF sy-subrc EQ 0.
    za23_vac_perm-mandt = sy-mandt.
    za23_vac_perm-id_vac_perm = lv_num. " ID
    CONDENSE za23_vac_perm-periodo. "SPACE CLEANER __NAME__ = NAME
    EXPORT za23_vac_perm FROM za23_vac_perm TO SHARED MEMORY indx(aa) ID 'VAC_PERM'. " EXPORT THE DATA OF THE INTERNAL TABLE
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data_vac_perm
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data_vac_perm .

  DATA: ls_vac_perm TYPE za23_vac_perm.

  IMPORT za23_vac_perm TO ls_vac_perm FROM SHARED MEMORY indx(aa) ID 'VAC_PERM'. "IMPORT THE DATA OF THE INTERNAL TABLE
  INSERT za23_vac_perm FROM ls_vac_perm.

  IF sy-subrc EQ 0.
    COMMIT WORK.
    MESSAGE s029(zemp_alfa02).
    IF go_catalog_alv IS BOUND.
      PERFORM get_data_lea_vac.
      PERFORM regresh_Catalo_alv.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
    MESSAGE s025(zemp_alfa02) DISPLAY LIKE 'W'.
  ENDIF.

  FREE MEMORY ID 'VAC_PERM'. " DELETE MEMORY DATA

  PERFORM clear_data_vac_perm.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form clear_data_vac_perm
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM clear_data_vac_perm .

  CLEAR: za23_vac_perm, za23_empleados-nombre, gs_emp_cap.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form go_container_lea_vac
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM go_container_lea_vac .

  PERFORM create_catalog_container.
  PERFORM create_cat_fieldcat_lea_vac.
  PERFORM create_catalog_alv.
  PERFORM set_events.
  PERFORM display_catalog_alv_lea_vac.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_cat_fieldcat_lea_vac
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_cat_fieldcat_lea_vac .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
   EXPORTING
     i_structure_name             = gv_tabname
    CHANGING
      ct_fieldcat                  = gt_catalog_fieldcat
   EXCEPTIONS
     inconsistent_interface       = 1
     program_error                = 2
     OTHERS                       = 3 .

  LOOP AT gt_catalog_fieldcat ASSIGNING FIELD-SYMBOL(<lt_field_symbol>).
    CASE <lt_field_symbol>-fieldname.
      WHEN ''.
      WHEN ''.
      WHEN OTHERS.
        <lt_field_symbol>-hotspot = abap_true.
    ENDCASE.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_catalog_alv_lea_vac
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_catalog_alv_lea_vac .

  go_catalog_alv->set_table_for_first_display(
    CHANGING
      it_outtab                     = gt_emp_cap        " Output Table
      it_fieldcatalog               = gt_catalog_fieldcat                 " Field Catalog
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_lea_vac
*&---------------------------------------------------------------------*
*& text
*  DATA: lv_tab_name  TYPE string.
*  FIELD-SYMBOLS: <lt_emp_cap> TYPE ANY TABLE.
*  lv_tab_name = 'ZHRV_EMPV_ALFA02'.
*  ASSIGN gt_emp_cap TO <lt_emp_cap>.
*
*  SELECT * FROM (lv_tab_name)
*    INTO CORRESPONDING FIELDS OF TABLE <lt_emp_cap>.
*
*  SORT gt_emp_cap by fecha_fin DESCENDING.
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_lea_vac .

  SELECT * FROM ZHRV_EMPV_ALFA02 where (gv_tab_where)
    INTO CORRESPONDING FIELDS OF TABLE @gt_emp_cap.

  SORT gt_emp_cap by fecha_fin DESCENDING.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_events .

  IF go_events_receiver IS NOT BOUND.
    CREATE OBJECT go_events_receiver.
    SET HANDLER: go_events_receiver->handle_hotspot_click_vac_perm FOR go_catalog_alv.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form clear_data_lea_vac
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM clear_data_lea_vac .

  CLEAR: za23_vac_perm-fecha_fin, za23_vac_perm-fecha_inicio, za23_vac_perm-dias_vacaciones,
         za23_vac_perm-periodo.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form upd_data_vac_perm
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text PERFORM check_upd_data_vac_perm USING lv_flag.
*  SELECT  SINGLE * FROM za23_vac_perm WHERE id_empleado EQ @za23_vac_perm-id_empleado AND
*    fecha_inicio IN ( SELECT fecha_inicio FROM za23_vac_perm
*    WHERE fecha_inicio EQ @za23_vac_perm-fecha_inicio AND id_empleado EQ @za23_vac_perm-id_empleado )
*      AND fecha_fin IN ( SELECT fecha_fin FROM za23_vac_perm
*    WHERE fecha_fin EQ @za23_vac_perm-fecha_fin
*      AND id_empleado EQ @za23_vac_perm-id_empleado ) INTO @DATA(lt_search).
*&---------------------------------------------------------------------*
FORM upd_data_vac_perm .

  CONDENSE za23_vac_perm-periodo.

  SELECT  SINGLE * FROM za23_vac_perm WHERE id_empleado EQ @za23_vac_perm-id_empleado AND
    fecha_inicio IN ( SELECT fecha_inicio FROM za23_vac_perm
    WHERE fecha_inicio EQ @za23_vac_perm-fecha_inicio AND id_empleado EQ @za23_vac_perm-id_empleado )
      AND fecha_fin IN ( SELECT fecha_fin FROM za23_vac_perm
    WHERE fecha_fin EQ @za23_vac_perm-fecha_fin
      AND id_empleado EQ @za23_vac_perm-id_empleado ) INTO @DATA(lt_search).


  IF sy-subrc NE 0 and lt_search-fecha_inicio < lt_search-fecha_fin.

    UPDATE za23_vac_perm SET fecha_inicio = @za23_vac_perm-fecha_inicio, fecha_fin = @za23_vac_perm-fecha_fin,
       dias_vacaciones = @za23_vac_perm-dias_vacaciones, periodo = @za23_vac_perm-periodo
     WHERE id_vac_perm EQ @za23_vac_perm-id_vac_perm.

    IF sy-subrc EQ 0.
      COMMIT WORK.
      MESSAGE s031(zemp_alfa02).
      PERFORM get_data_lea_vac.
      PERFORM regresh_Catalo_alv.
    ELSE.
      ROLLBACK WORK.
      MESSAGE s033(zemp_alfa02) DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    IF za23_vac_perm-fecha_inicio < za23_vac_perm-fecha_fin.

    IF lt_search-dias_vacaciones NE za23_vac_perm-dias_vacaciones OR lt_search-periodo NE za23_vac_perm-periodo.

      perform update_data_vac_perm.

*      UPDATE za23_vac_perm SET fecha_inicio = @za23_vac_perm-fecha_inicio, fecha_fin = @za23_vac_perm-fecha_fin,
*       dias_vacaciones = @za23_vac_perm-dias_vacaciones, periodo = @za23_vac_perm-periodo
*     WHERE id_vac_perm EQ @za23_vac_perm-id_vac_perm.
*
*      IF sy-subrc EQ 0.
*        COMMIT WORK.
*        MESSAGE s031(zemp_alfa02).
*        PERFORM get_data_lea_vac.
*        PERFORM regresh_Catalo_alv.
*      ELSE.
*        ROLLBACK WORK.
*        MESSAGE s033(zemp_alfa02) DISPLAY LIKE 'E'.
*      ENDIF.
    ELSE.
      MESSAGE s034(zemp_alfa02) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
  ENDIF.

  PERFORM clear_data_vac_perm.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_lea_vac_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_lea_vac_emp .

  DATA: lv_tab_name  TYPE string.
  FIELD-SYMBOLS: <lt_emp_cap> TYPE ANY TABLE.
  lv_tab_name = 'ZHRV_EMPV_ALFA02'.
  ASSIGN gt_emp_cap TO <lt_emp_cap>.

  SELECT * FROM (lv_tab_name)
    INTO CORRESPONDING FIELDS OF TABLE <lt_emp_cap>
    where id_empleado eq za23_empleados-id_empleado.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form free_cont_vac_perm_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_cont_vac_perm_emp .

  IF go_catalog_container IS BOUND.
    go_catalog_container->free(
      EXCEPTIONS
        cntl_error        = 1                " CNTL_ERROR
        cntl_system_error = 2                " CNTL_SYSTEM_ERROR
        OTHERS            = 3
    ).
    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CLEAR go_catalog_container.

  ENDIF.

  IF go_catalog_alv IS BOUND.
    CLEAR go_catalog_alv.
  ENDIF.

  IF go_events_receiver IS BOUND.
    clear: go_events_receiver.
  ENDIF.

  clear: za23_vac_perm, za23_empleados, gt_emp_cap, gs_emp_cap, gv_tabname,gt_catalog_fieldcat.

ENDFORM.
