*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_F02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_3009
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3009 .

  ok_code = sy-ucomm.

  IF ok_code <> 'EXECUTE'.
    PERFORM free_training.
    PERFORM free_container.
    PERFORM call_container_tra.
  ELSE.
    IF go_catalog_container IS BOUND.
      PERFORM get_catalog_data USING 'SC_TRAG'.
      PERFORM refresh_container.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form assigns_corresp_value
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- SCREEN_3009
*&---------------------------------------------------------------------*
FORM assigns_corresp_value CHANGING assig_value TYPE c.

  CASE assig_value.
    WHEN 'SC_TRAG'.
      gv_tabname = 'ZA23_CAPAC'."'ZA23_CAP_ALFA02'.
    WHEN 'SAV_TRAG'.
      gv_tabname = 'ZHR_EMP_ASI_CAP'."'ZA23V_EMP_CAP_V'.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3100 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'SAVE'.
      PERFORM save_training.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form go_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM go_container CHANGING l_asig TYPE c.

    PERFORM create_catalog_container.     " OK
    PERFORM create_catalog_fieldcat USING l_asig.      " OK
    PERFORM create_catalog_alv.           " OK

    PERFORM handle_event USING l_asig.                 "

    PERFORM conf_catalog_layout USING l_asig CHANGING gs_layout.  "ok
    PERFORM register_events USING l_asig.              " ok
    PERFORM set_display_alv.
    PERFORM exclude_catalog_functions.

    PERFORM display_catalog_alv USING l_asig.          " OK

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_catalog_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_catalog_container .

  CREATE OBJECT go_catalog_container
    EXPORTING
      container_name              = 'ALV_CONTAINER'  " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      cntl_error                  = 1                " CNTL_ERROR
      cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
      create_error                = 3                " CREATE_ERROR
      lifetime_error              = 4                " LIFETIME_ERROR
      lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
      OTHERS                      = 6
    .
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_catalog_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_catalog_alv .

  CREATE OBJECT go_catalog_alv
    EXPORTING
      i_parent                = go_catalog_container                 " Parent Container
    EXCEPTIONS
      error_cntl_create       = 1                " Error when creating the control
      error_cntl_init         = 2                " Error While Initializing Control
      error_cntl_link         = 3                " Error While Linking Control
      error_dp_create         = 4                " Error While Creating DataProvider Control
      OTHERS                  = 5
    .
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_catalog_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_catalog_fieldcat CHANGING lv_cat_fd TYPE c.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
   EXPORTING
     i_structure_name             =  gv_tabname
   CHANGING
      ct_fieldcat                  = gt_catalog_fieldcat
   EXCEPTIONS
     inconsistent_interface       = 1
     program_error                = 2
     OTHERS                       = 3
            .

  CASE lv_cat_fd.
    WHEN 'SAV_TRAG'.
      LOOP AT gt_catalog_fieldcat ASSIGNING FIELD-SYMBOL(<ls_field>).
        CASE <ls_field>-fieldname.
          WHEN 'ID_ASIGNACION' OR 'ID_PUESTO' OR 'ID_AREA' OR 'ID_HORARIO' OR 'ID_CAP_EMP' OR 'ID_CAPACITACION' OR 'TURNO'.
            <ls_field>-no_out = abap_true.
          WHEN OTHERS .
            <ls_field>-hotspot = abap_true.
            <ls_field>-no_out = abap_false.
        ENDCASE.
      ENDLOOP.
    WHEN 'SC_TRAG'.
*      LOOP AT gt_catalog_fieldcat ASSIGNING FIELD-SYMBOL(<ls_cat_field>).
*        CASE <ls_cat_field>-fieldname.
*          <ls_cat_field>-edit = abap_false.
*        WHEN OTHERS.
*          <ls_cat_field>-edit = abap_true.
*        ENDCASE.
*      ENDLOOP.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_event
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM handle_event CHANGING levent TYPE c.

  DATA: lt_f4 TYPE lvc_t_f4,
        ls_f4 TYPE lvc_s_f4.

  CASE levent.
    WHEN ''.
    WHEN 'SAV_TRAG'.
*      ls_f4-fieldname = 'NOMBRE_CAPACITACION'.
*      ls_f4-register = abap_true.
*      APPEND ls_f4 TO lt_f4.
*      go_catalog_alv->register_f4_for_fields( it_f4 = lt_f4  ).
*
*      CALL METHOD go_catalog_alv->register_edit_event
*        EXPORTING
*          i_event_id = cl_gui_alv_grid=>mc_evt_enter                 " Event ID
*        EXCEPTIONS
*          error      = 1                " Error
*          OTHERS     = 2
*        .
*      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_catalog_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_catalog_data CHANGING lwhere TYPE c .

  CASE lwhere.
    WHEN 'SC_TRAG'.

      SELECT * FROM za23_capac
        INTO CORRESPONDING FIELDS OF
         TABLE gt_cap WHERE (gv_tab_where)
        ORDER BY fecha_finalizacion_cap DESCENDING .


    WHEN 'SAV_TRAG'.

      PERFORM catalog_layout.

      SELECT * FROM zhrv_cemp_alfa02
        WHERE (gv_tab_where)
        INTO CORRESPONDING FIELDS OF TABLE @gt_train.

      SORT gt_train BY fecha_finalizacion_cap DESCENDING.

    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.

*      SELECT emp~id_empleado, emp~nombre, emp~apellido_paterno, emp~apellido_materno, asig~id_asignacion,
*        job~id_puesto, job~nombre_puesto, area~id_area, area~nombre_area, sched~id_horario, emp_tra~id_cap_emp,
*        trai~id_capacitacion, trai~nombre_capacitacion, trai~descripcion, trai~horas,    trai~nombre_institucion,
*        trai~fecha_inicio_cap, trai~fecha_finalizacion_cap
*        FROM za23_empleados AS emp
*        INNER JOIN za23_asigemp AS asig ON emp~id_empleado EQ asig~id_empleado
*        INNER JOIN za23_puestos AS job ON asig~id_puesto EQ job~id_puesto
*        INNER JOIN za23_areas AS area ON job~id_area EQ area~id_area
*        INNER JOIN za23_horarios AS sched ON asig~id_horario EQ sched~id_horario
*        INNER JOIN za23_emp_cap AS emp_tra ON emp_tra~id_empleado EQ emp~id_empleado
*        INNER JOIN za23_capac AS trai ON trai~id_capacitacion EQ emp_tra~id_capacitacion
*        INTO CORRESPONDING FIELDS OF TABLE @gt_train
*          WHERE asig~id_asignacion EQ emp_tra~id_asignacion ORDER BY emp_tra~id_cap_emp DESCENDING.
*&---------------------------------------------------------------------*
*& Form conf_catalog_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM conf_catalog_layout CHANGING ls_cat_lay TYPE c ls_layout TYPE lvc_s_layo.

  DATA: ls_style TYPE lvc_s_styl,
        lv_id TYPE string.

  ls_layout-edit = abap_true.   " ACTIVE EDITION IN ALV
  ls_layout-zebra = abap_true.  " DEFINE AND CONFIGURE THE LAYOUT
  ls_layout-cwidth_opt = abap_true. " OPTIMIZE THE INFORMATION OF THE CONTENT
  ls_layout-stylefname = 'FIELD_STYLE'.
  ls_layout-cwidth_opt = abap_true. " NEW PROPERTY COLUMN OPTIMIZATION

  CASE ls_cat_lay.
    WHEN 'SC_TRAG'.
      lv_id = 'ID_CAPACITACION'.
      LOOP AT gt_cap ASSIGNING FIELD-SYMBOL(<ls_Cap>).
      ls_style-fieldname = lv_id.
      ls_style-style = cl_gui_alv_grid=>mc_style_disabled.
      INSERT ls_style INTO TABLE <ls_Cap>-field_style.
      ENDLOOP.
    WHEN 'SAV_TRAG'.
      LOOP AT gtv_em_ec_c ASSIGNING FIELD-SYMBOL(<ls_em_ec>).
        LOOP AT lt_name2 ASSIGNING FIELD-SYMBOL(<ls_name_row>).
          ls_style-fieldname = <ls_name_row>-name.
          ls_style-style = cl_gui_alv_grid=>mc_style_disabled.
          INSERT ls_style INTO TABLE <ls_em_ec>-field_style.
        ENDLOOP.
      ENDLOOP.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form register_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_events  CHANGING lv_regi.

  CASE lv_regi.
    WHEN 'SC_TRAG'.
      IF go_events_receiver IS NOT BOUND .

        CREATE OBJECT go_events_receiver.
        SET HANDLER: go_events_receiver->handle_toolbar FOR go_catalog_alv,
                     go_events_receiver->handle_user_command FOR go_catalog_alv,
                     go_events_receiver->handle_data_changed FOR go_catalog_alv,
                     go_events_receiver->handle_data_changed_finish FOR go_catalog_alv.
      ENDIF.
    WHEN 'SAV_TRAG'.
      IF go_events_receiver IS NOT BOUND.
        CREATE OBJECT go_events_receiver.
         SET HANDLER: go_events_receiver->handle_hotspot_click_training FOR go_catalog_alv,
                       go_events_receiver->handle_onf4 FOR go_catalog_alv,
                       go_events_receiver->handle_data_changed_t FOR go_catalog_alv,
                       go_events_receiver->handle_data_changed_finish_t FOR go_catalog_alv,
                       go_events_receiver->handle_toolbar_t FOR go_catalog_alv,
                       go_events_receiver->handle_user_command_t FOR go_catalog_alv.

      ENDIF.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form exclude_catalog_functions
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM exclude_catalog_functions .

  DATA lv_exclude TYPE ui_func.

  lv_exclude = cl_gui_alv_grid=>mc_fc_print.
  APPEND lv_exclude TO gt_excluding.
  CLEAR: lv_exclude.

  lv_exclude = cl_gui_alv_grid=>mc_fc_pc_file.
  APPEND lv_exclude TO gt_excluding.
  CLEAR: lv_exclude.

  lv_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND lv_exclude TO gt_excluding.

  lv_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND lv_exclude TO gt_excluding.
  CLEAR: lv_exclude.

  lv_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND lv_exclude TO gt_excluding.
  CLEAR: lv_exclude.

  lv_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND lv_exclude TO gt_excluding.
  CLEAR: lv_exclude.

  lv_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND lv_exclude TO gt_excluding.
  CLEAR: lv_exclude.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_display_alv .



ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_catalog_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_catalog_alv CHANGING as_lt_data TYPE c.

  FIELD-SYMBOLS <lt_data> TYPE ANY TABLE.

  CASE as_lt_data.
    WHEN 'SC_TRAG'.
      ASSIGN gt_cap TO <lt_data>.
    WHEN 'SAV_TRAG'.
      ASSIGN gt_train TO <lt_data>.
    WHEN OTHERS.
  ENDCASE.

  go_catalog_alv->set_table_for_first_display(
    EXPORTING
      i_save                        = 'U'
      is_layout                     = gs_layout                 " Layout
      it_toolbar_excluding          = gt_excluding                 " Excluded Toolbar Standard Functions
    CHANGING
      it_outtab                     =  <lt_data>                " Output Table
      it_fieldcatalog               =  gt_catalog_fieldcat                 " Field Catalog
*      it_sort                       =                  " Sort Criteria
*      it_filter                     =                  " Filter Criteria
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
*& Form regresh_Catalo_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM regresh_Catalo_alv .

  go_catalog_alv->refresh_table_display(
    EXCEPTIONS
      finished       = 1                " Display was Ended (by Export)
      OTHERS         = 2
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form generate_id_td
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_ID
*&---------------------------------------------------------------------*
FORM generate_id_td  CHANGING d_td TYPE numc10.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr                   = '01'
      object                        = 'ZTP_EMP_A2'
   IMPORTING
     number                        = d_td
   EXCEPTIONS
     interval_not_found            = 1
     number_range_not_intern       = 2
     object_not_found              = 3
     quantity_is_0                 = 4
     quantity_is_not_1             = 5
     interval_overflow             = 6
     buffer_overflow               = 7
     OTHERS                        = 8
            .
  IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
     EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_training
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_training .

  DATA: lt_td TYPE za23_capac,
        lv_id TYPE numc10.

  PERFORM generate_id_td CHANGING lv_id.
  IF za23_capac-fecha_inicio_cap < za23_capac-fecha_finalizacion_cap.
  lt_td-mandt = sy-mandt.
  lt_td-id_capacitacion = lv_id.
  lt_td-nombre_capacitacion = za23_capac-nombre_capacitacion.
  lt_td-descripcion = za23_capac-descripcion.
  lt_td-horas = za23_capac-horas.
  lt_td-nombre_institucion = za23_capac-nombre_institucion.
  lt_td-fecha_inicio_cap = za23_capac-fecha_inicio_cap.
  lt_td-fecha_finalizacion_cap = za23_capac-fecha_finalizacion_cap.
  CONDENSE lt_td-nombre_capacitacion.
  CONDENSE lt_td-descripcion.
  CONDENSE lt_td-nombre_institucion.

  INSERT za23_capac FROM lt_td.

  IF sy-subrc EQ 0.
    COMMIT WORK.
    CLEAR: lt_td, za23_capac.
    IF go_catalog_alv IS BOUND.
      PERFORM get_catalog_data USING 'SC_TRAG'.
      PERFORM refresh_container.
    ENDIF.
*    PERFORM  regresh_Catalo_alv.
    LEAVE TO SCREEN 0.
  ELSE.
    ROLLBACK WORK.
    MESSAGE w020(zemp_alfa02).
  ENDIF.
  ELSE.
    MESSAGE S041(zemp_alfa02) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form free_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_container .

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

  IF go_events_receiver IS BOUND.
    CLEAR go_events_receiver.
  ENDIF.

  IF go_catalog_alv IS BOUND.
    CLEAR go_catalog_alv.
  ENDIF.

  CLEAR: za23_capac, gt_cap, gt_train, gv_tabname, gt_catalog_fieldcat, gt_excluding,gs_layout, gtv_em_ec_c,gv_id,
         gt_catalog_fieldcat, gt_excluding.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_3101
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3101 .

  ok_code = sy-ucomm.


  CASE ok_code.
    WHEN 'EXECUTE'.

      IF za23_empleados-id_empleado IS NOT INITIAL AND gv_date IS NOT INITIAL.
        CLEAR: za23_empleados-id_empleado, gv_date, gv_date[].
        "AGREGAR MENSAJE DE QUE SE PUEDE HACER SOLAMENTE UNA BUSQUEDA DE UN CAMPO
     ENDIF.
*
     IF go_catalog_container IS BOUND.
       PERFORM free_container.
     ENDIF.

     DATA: lt_asig_where TYPE TABLE OF string.
     PERFORM create_where_trainier TABLES lt_asig_where.

     IF go_catalog_container IS NOT BOUND.
       PERFORM assigns_corresp_value USING 'SAV_TRAG'.
       PERFORM call_container_assig_tra.
     ELSE.
       PERFORM regresh_Catalo_alv.
     ENDIF.
  ENDCASE.

*  IF ok_code <> 'EXECUTE'.
*    PERFORM assigns_corresp_value USING 'SAV_TRAG'.
*    PERFORM call_container_assig_tra.
*  ENDIF.



*  IF ok_code <> 'EXECUTE'.
*    PERFORM assigns_corresp_value USING 'SAV_TRAG'.
*    PERFORM call_container_assig_tra.
*  ELSE.
*
*    PERFORM free_container.
*
*
*    DATA: lt_asig_where TYPE TABLE OF string.
*    PERFORM create_where_trainier TABLES lt_asig_where.
*
*    PERFORM assigns_corresp_value USING 'SAV_TRAG'.
*    PERFORM call_container_assig_tra.
*
**    PERFORM free_container.
**
**    DATA: lt_asig_where TYPE TABLE OF string.
**    PERFORM create_where_trainier TABLES lt_asig_where.
**
**    PERFORM assigns_corresp_value USING 'SAV_TRAG'.
**    PERFORM call_container_assig_tra.
*
*
*
*  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form catalog_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM catalog_layout .

  ls_name2-name = 'ID_EMPLEADO'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'NOMBRE'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'APELLIDO_PATERNO'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'APELLIDO_MATERNO'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'NOMBRE_INSTITUCION'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'NOMBRE_AREA'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'NOMBRE_PUESTO'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'TURNO'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'NOMBRE_CAPACITACION'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'DESCRIPCION'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'HORAS'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'FECHA_INICIO_CAP'.
  APPEND ls_name2 TO lt_name2.
  ls_name2-name = 'FECHA_FINALIZACION_CAP'.
  APPEND ls_name2 TO lt_name2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3102
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3102 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'COD_TRAI'.
      PERFORM get_data_training.
    WHEN 'SAVE'.
      PERFORM assign_training.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form assign_training
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM assign_training .

  CASE gv_code.
    WHEN 'DES_UPD'.
      PERFORM confirmation_save.
      IF gv_answ EQ '1' AND gv_flag_emp EQ abap_true AND gv_flag_tra EQ abap_true.
        PERFORM register_user_training.
      ELSE.
        MESSAGE TEXT-004 TYPE 'W'.
      ENDIF.
    WHEN 'ACT_UPD'.
      PERFORM update_message.
      IF gv_answ EQ '1'.
        PERFORM update_user_training.
      ELSE.
        MESSAGE TEXT-004 TYPE 'W'.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form register_user_training
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_user_training .

  DATA: lv_id_tr TYPE numc10.

  CASE gv_code.
    WHEN 'DES_UPD'.

      SELECT SINGLE * FROM za23_emp_cap WHERE id_capacitacion IN ( SELECT id_capacitacion
        FROM za23_emp_cap WHERE id_capacitacion EQ za23_emp_cap-id_capacitacion AND
        id_empleado EQ za23_emp_cap-id_empleado ) AND id_empleado EQ za23_emp_cap-id_empleado.

      IF sy-subrc NE 0.
        PERFORM generate_id_training USING lv_id_tr.
        za23_emp_cap-mandt = sy-mandt.
        za23_emp_cap-id_cap_emp = lv_id_tr.
        za23_emp_cap-fecha_asignacion = sy-datum.
        INSERT za23_emp_cap.
        IF sy-subrc EQ 0.
          PERFORM free_training.
          DATA: lt_asig_where TYPE TABLE OF string.
          IF go_catalog_container IS BOUND.
            PERFORM create_where_trainier TABLES lt_asig_where.
            PERFORM refresh_container.
          ENDIF.
          MESSAGE i027(zemp_alfa02).
          LEAVE TO SCREEN 0.
        ENDIF.
     ELSE.
       PERFORM free_training.
       MESSAGE i028(zemp_alfa02) DISPLAY LIKE 'W'.
     ENDIF.

    WHEN 'ACT_UPD'.
    WHEN OTHERS.
    ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_list_training-box
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_list_training-box .

  DATA ls_tra TYPE za23_capac.

  SELECT * FROM za23_capac INTO TABLE @DATA(lt_tra)
    WHERE fecha_finalizacion_cap GE @sy-datum.

  LOOP AT lt_tra INTO ls_tra.
    gs_values-key = ls_tra-nombre_capacitacion.
    APPEND gs_values TO gt_values.
    CLEAR gs_values.
  ENDLOOP.

  SORT gt_values BY key.
  DELETE ADJACENT DUPLICATES FROM gt_values COMPARING key.
  gv_id = 'ZA23_CAPAC-NOMBRE_CAPACITACION'.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id                    = gv_id
      values                = gt_values
   EXCEPTIONS
     id_illegal_name       = 1
     OTHERS                = 2.

  CLEAR: gt_values[], gs_values.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_training
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_training .

  gv_flag_tra = abap_false.
  SELECT SINGLE * FROM za23_capac INTO @DATA(lt_val_tra) WHERE nombre_capacitacion EQ @za23_capac-nombre_capacitacion.

  IF sy-subrc EQ 0.
    gv_flag_tra = abap_true.
    za23_capac-descripcion = lt_val_tra-descripcion.
    za23_capac-horas = lt_val_tra-horas.
    za23_capac-nombre_institucion = lt_val_tra-nombre_institucion.
    za23_capac-fecha_inicio_cap = lt_val_tra-fecha_inicio_cap.
    za23_capac-fecha_finalizacion_cap = lt_val_tra-fecha_finalizacion_cap.
    za23_emp_cap-id_capacitacion = lt_val_tra-id_capacitacion.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form free_training
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_training .

  CLEAR: za23_emp_cap,za23_capac,za23_empleados,gv_value_row,gv_value_id_assig,
         za23_emp_cap,gv_flag_emp,gv_flag_tra,gv_id,gv_value_id_emp, gv_date[].

  CLEAR: za23_capac, gt_cap, gt_train, gv_tabname, gt_catalog_fieldcat, gt_excluding,gs_layout, gtv_em_ec_c,gv_id.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form generate_id_training
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_ID_TR
*&---------------------------------------------------------------------*
FORM generate_id_training  CHANGING   lv_id.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr                   = '01'
      object                        = 'ZTR_EMP_A2'
   IMPORTING
     number                        = lv_id
   EXCEPTIONS
     interval_not_found            = 1
     number_range_not_intern       = 2
     object_not_found              = 3
     quantity_is_0                 = 4
     quantity_is_not_1             = 5
     interval_overflow             = 6
     buffer_overflow               = 7
     OTHERS                        = 8
            .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_where_trainier
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_where_trainier TABLES t_asig_where TYPE STANDARD TABLE.

DATA: lt_hrcond TYPE TABLE OF hrcond,
      ls_cond TYPE hrcond.

  IF gv_date-low IS NOT INITIAL .
    ls_cond-field = 'FECHA_INICIO_CAP'.
    ls_cond-opera = gv_date-option.
    ls_cond-low   = gv_date-low.
    ls_cond-high  = gv_date-high.
    APPEND ls_cond TO lt_hrcond.
  ENDIF.

  CLEAR ls_cond.

  IF gv_date-high IS NOT INITIAL .
    ls_cond-field = 'FECHA_FINALIZACION_CAP'.
    ls_cond-opera = gv_date-option.
    ls_cond-low   = gv_date-low.
    ls_cond-high  = gv_date-high.
    APPEND ls_cond TO lt_hrcond.
  ENDIF.

  CLEAR ls_cond.

  IF lt_hrcond IS NOT INITIAL.

    CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
      EXPORTING
        dbtable               = 'ZA23_CAPAC'
      TABLES
        condtab               = lt_hrcond
        where_clause          = t_asig_where
     EXCEPTIONS
       empty_condtab         = 1
       no_db_field           = 2
       unknown_db            = 3
       wrong_condition       = 4
       OTHERS                = 5 .

  ENDIF.

  PERFORM get_report_data_tra  TABLES t_asig_where.
*  PERFORM get_catalog_data USING l_asig.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_report_data_tra
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> T_ASIG_WHERE
*&      --> TYPE
*&      --> STANDARD
*&      --> TABLE
*&---------------------------------------------------------------------*
FORM get_report_data_tra  TABLES p_t_asig_where TYPE STANDARD TABLE.

  IF za23_empleados-id_empleado IS NOT INITIAL.

  SELECT emp~id_empleado, emp~nombre, emp~apellido_paterno, emp~apellido_materno, asig~id_asignacion,
    job~id_puesto, job~nombre_puesto, area~id_area, area~nombre_area, sched~id_horario, emp_tra~id_cap_emp,
    trai~id_capacitacion, trai~nombre_capacitacion, trai~descripcion, trai~horas, trai~nombre_institucion,
    trai~fecha_inicio_cap, trai~fecha_finalizacion_cap
      FROM za23_empleados AS emp
      INNER JOIN za23_asigemp AS asig ON emp~id_empleado EQ asig~id_empleado
      INNER JOIN za23_puestos AS job ON asig~id_puesto EQ job~id_puesto
      INNER JOIN za23_areas AS area ON job~id_area EQ area~id_area
      INNER JOIN za23_horarios AS sched ON asig~id_horario EQ sched~id_horario
      INNER JOIN za23_emp_cap AS emp_tra ON emp_tra~id_empleado EQ emp~id_empleado
      INNER JOIN za23_capac AS trai ON trai~id_capacitacion EQ emp_tra~id_capacitacion
      INTO CORRESPONDING FIELDS OF TABLE @gt_train
         WHERE asig~id_asignacion EQ emp_tra~id_asignacion AND emp~id_empleado = @za23_empleados-id_empleado
           ORDER BY trai~fecha_finalizacion_cap DESCENDING.

  ELSE.

  SELECT emp~id_empleado, emp~nombre, emp~apellido_paterno, emp~apellido_materno, asig~id_asignacion,
    job~id_puesto, job~nombre_puesto, area~id_area, area~nombre_area, sched~id_horario, emp_tra~id_cap_emp,
    trai~id_capacitacion, trai~nombre_capacitacion, trai~descripcion, trai~horas, trai~nombre_institucion,
    trai~fecha_inicio_cap, trai~fecha_finalizacion_cap
      FROM za23_empleados AS emp
      INNER JOIN za23_asigemp AS asig ON emp~id_empleado EQ asig~id_empleado
      INNER JOIN za23_puestos AS job ON asig~id_puesto EQ job~id_puesto
      INNER JOIN za23_areas AS area ON job~id_area EQ area~id_area
      INNER JOIN za23_horarios AS sched ON asig~id_horario EQ sched~id_horario
      INNER JOIN za23_emp_cap AS emp_tra ON emp_tra~id_empleado EQ emp~id_empleado
      INNER JOIN za23_capac AS trai ON trai~id_capacitacion EQ emp_tra~id_capacitacion
      INTO CORRESPONDING FIELDS OF TABLE @gt_train
         WHERE asig~id_asignacion EQ emp_tra~id_asignacion AND (p_t_asig_where)
           ORDER BY trai~fecha_finalizacion_cap DESCENDING.

  ENDIF.

*  clear: za23_empleados-id_empleado.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form call_container_tra
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM call_container_assig_tra .

  PERFORM go_container USING 'SAV_TRAG'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form call_container_tra
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM call_container_tra .

  PERFORM assigns_corresp_value USING 'SC_TRAG'.
  PERFORM go_container USING 'SC_TRAG'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_container .

  go_catalog_alv->refresh_table_display(
    EXCEPTIONS
      finished       = 1                " Display was Ended (by Export)
      OTHERS         = 2
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form find_data_emp_assig_course
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM find_data_emp_assig_course .

*  SELECT SINGLE emp~id_empleado, emp~nombre, emp~apellido_paterno, emp~apellido_materno,
*    tra~nombre_capacitacion, tra~descripcion, tra~horas, tra~nombre_institucion,
*    tra~fecha_inicio_cap, tra~fecha_finalizacion_cap
*    FROM za23_empleados AS emp
*    INNER JOIN za23_emp_cap AS emp_tra ON
*      emp~id_empleado EQ emp_tra~id_empleado
*    INNER JOIN za23_capac AS tra ON
*      emp_tra~id_capacitacion EQ tra~id_capacitacion
*    INTO @DATA(lt_data) WHERE emp_tra~id_cap_emp EQ @gs_train_upd-id_cap_emp.
*
*    za23_empleados-id_empleado = lt_data-id_empleado.
*    DATA lv_name TYPE string.
*    lv_name = | { lt_data-nombre } { lt_data-apellido_paterno } { lt_data-apellido_materno } |.
*    za23_empleados-nombre = lv_name.
*    MOVE-CORRESPONDING lt_data TO za23_capac.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_user_training
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_user_training .

*  data(lv_id_tra) = gs_train_upd-id_capacitacion.

  SELECT SINGLE * FROM za23_emp_cap
    WHERE id_capacitacion IN ( SELECT id_capacitacion
        FROM za23_emp_cap WHERE id_capacitacion
      EQ @za23_emp_cap-id_capacitacion
      AND id_empleado EQ @gs_train_upd-id_empleado )
      AND id_empleado EQ @gs_train_upd-id_empleado
    INTO @DATA(datails).

  IF sy-subrc NE 0.

    UPDATE za23_emp_cap SET id_capacitacion = @za23_emp_cap-id_capacitacion, fecha_asignacion = @sy-datum
      WHERE id_cap_emp EQ @gs_train_upd-id_cap_emp.

   IF sy-subrc EQ 0.
     COMMIT WORK.
     MESSAGE TEXT-006 TYPE 'W'.
     CLEAR: za23_empleados, za23_capac.
     DATA: lt_asig_where TYPE TABLE OF string.
     PERFORM create_where_trainier TABLES lt_asig_where.
     PERFORM refresh_container.
     LEAVE TO SCREEN 0.
   ELSE.
     CLEAR: za23_empleados, za23_capac.
   ENDIF.

  ELSE.

  ENDIF.

ENDFORM.
