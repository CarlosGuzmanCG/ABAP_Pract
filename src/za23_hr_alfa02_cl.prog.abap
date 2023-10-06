*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_CL
*&---------------------------------------------------------------------*
*INCLUDE ZA23_HR_ALFA02_CLRGX.
CLASS lcl_events_receivers DEFINITION.

  PUBLIC SECTION.

*   events employee

  METHODS handle_hotspot_click_fam FOR EVENT hotspot_click
                                OF cl_gui_alv_grid
                                IMPORTING e_column_id
                                          e_row_id
                                          es_row_no.

  METHODS handle_hotspot_click_skill FOR EVENT hotspot_click
                                OF cl_gui_alv_grid
                                IMPORTING e_column_id
                                          e_row_id
                                          es_row_no.


  METHODS handle_hotspot_click_fam_upd FOR EVENT hotspot_click
                                    OF cl_gui_alv_grid
                                    IMPORTING e_column_id
                                              e_row_id
                                              es_row_no.

  METHODS handle_hotspot_click_skill_upd FOR EVENT hotspot_click
                                    OF cl_gui_alv_grid
                                    IMPORTING e_column_id
                                              e_row_id
                                              es_row_no.

*  events training

  METHODS handle_data_changed FOR EVENT data_changed
                           OF cl_gui_alv_grid
                           IMPORTING er_data_changed
                                     e_onf4
                                     e_onf4_before
                                     e_onf4_after
                                     e_ucomm.

  METHODS handle_data_changed_finish FOR EVENT data_changed_finished
                                     OF cl_gui_alv_grid
                                     IMPORTING e_modified
                                               et_good_cells.

  METHODS handle_toolbar FOR EVENT toolbar
                         OF cl_gui_alv_grid
                         IMPORTING  e_interactive
                                    e_object.

  METHODS handle_user_command FOR EVENT user_command
                             OF cl_gui_alv_grid
                             IMPORTING e_ucomm.


  "REGISTER TRAINING

  METHODS handle_hotspot_click_training FOR EVENT hotspot_click
                                    OF cl_gui_alv_grid
                                    IMPORTING e_column_id
                                              e_row_id
                                              es_row_no.


  "
  METHODS handle_onf4 FOR EVENT onf4
                      OF cl_gui_alv_grid
                      IMPORTING e_fieldname   "name column
                                e_fieldvalue
                                es_row_no
                                er_event_data " data modification standard
                                et_bad_cells
                                e_display.

  METHODS handle_data_changed_t FOR EVENT data_changed" name of method in the local class
                           OF cl_gui_alv_grid " name of event
                           IMPORTING er_data_changed
                                     e_onf4
                                     e_onf4_before
                                     e_onf4_after
                                     e_ucomm.

  METHODS handle_data_changed_finish_t FOR EVENT data_changed_finished
                                     OF cl_gui_alv_grid
                                     IMPORTING e_modified
                                               et_good_cells.

  METHODS handle_toolbar_t FOR EVENT toolbar
                         OF cl_gui_alv_grid
                         IMPORTING  e_interactive
                                    e_object.

  METHODS handle_user_command_t FOR EVENT user_command
                             OF cl_gui_alv_grid
                             IMPORTING e_ucomm.

  " EVENTS PAYROLL

  METHODS handle_toolbar_payroll FOR EVENT toolbar
                         OF cl_gui_alv_grid
                         IMPORTING  e_interactive
                                    e_object.

  METHODS handle_data_changed_payroll FOR EVENT data_changed" name of method in the local class
                           OF cl_gui_alv_grid " name of event
                           IMPORTING er_data_changed
                                     e_onf4
                                     e_onf4_before
                                     e_onf4_after
                                     e_ucomm.

  METHODS handle_data_chan_fish_payroll FOR EVENT data_changed_finished
                                     OF cl_gui_alv_grid
                                     IMPORTING e_modified
                                               et_good_cells.

  METHODS handle_user_command_payroll FOR EVENT user_command
                             OF cl_gui_alv_grid
                             IMPORTING e_ucomm.

  "EVENTS VACATIONS
  METHODS handle_hotspot_click_vac_perm FOR EVENT hotspot_click
                                    OF cl_gui_alv_grid
                                    IMPORTING e_column_id
                                              e_row_id
                                              es_row_no.

  PRIVATE SECTION.

  CLASS-METHODS genrate_id IMPORTING num_index TYPE i.

ENDCLASS.

CLASS lcl_events_receivers IMPLEMENTATION.

  METHOD handle_hotspot_click_fam.

    FIELD-SYMBOLS: <ls_data> TYPE any.
    gv_code = 'ACT_DEL'.
    READ TABLE gt_family ASSIGNING <ls_data> INDEX es_row_no-row_id.
    MOVE-CORRESPONDING <ls_data>  TO ls_family.
    gv_value_row = ls_family-id_familiar.
    CALL SCREEN 3001 STARTING AT 10 03 ENDING AT 155 16.

  ENDMETHOD.

  METHOD handle_hotspot_click_skill.

    FIELD-SYMBOLS: <ls_data> TYPE any. " symbold field
    gv_code = 'ACT_DEL'.
    READ TABLE gt_skill ASSIGNING <ls_data> INDEX es_row_no-row_id.
    MOVE-CORRESPONDING <ls_data> TO gs_skill.
    gv_value_row = gs_skill-id_habilidad.
    CALL SCREEN 3002 STARTING AT 10 05 ENDING AT 90 15.

  ENDMETHOD.

  METHOD handle_hotspot_click_fam_upd.

    FIELD-SYMBOLS: <ls_data> TYPE any.
    gv_code = 'ACT_DEL_FAM'.
    DATA(lv_num_rows) = lines( gt_family ).
    IF lv_num_rows >= es_row_no-row_id.
      READ TABLE gt_family ASSIGNING <ls_data> INDEX es_row_no-row_id.
      MOVE-CORRESPONDING <ls_data> TO ls_family.
      gv_value_row = ls_family-id_familiar.
      CALL SCREEN 3001 STARTING AT 10 03 ENDING AT 155 16.
    ENDIF.

  ENDMETHOD.

  METHOD handle_hotspot_click_skill_upd.

    FIELD-SYMBOLS: <ls_data> TYPE any. " symbold field
    gv_code = 'ACT_DEL_SKILL'.
    DATA(lv_num_rows) = lines( gt_skill ).
    IF lv_num_rows >= es_row_no-row_id.
      READ TABLE gt_skill ASSIGNING <ls_data> INDEX es_row_no-row_id.
      MOVE-CORRESPONDING <ls_data> TO gs_skill.
      gv_value_row = gs_skill-id_habilidad.
      CALL SCREEN 3002 STARTING AT 10 05 ENDING AT 90 15.
    ENDIF.

  ENDMETHOD.

  METHOD handle_data_changed.

    DATA: ls_data_changet TYPE lvc_s_modi,
          lv_valid TYPE abap_bool.

    LOOP AT er_data_changed->mt_good_cells INTO ls_data_changet.
      CASE ls_data_changet-fieldname.
        WHEN 'NOMBRE_CAPACITACION' OR 'DESCRIPCION' OR 'HORAS' OR 'NOMBRE_INSTITUCION' OR
             'FECHA_INICIO_CAP' OR 'FECHA_FINALIZACION_CAP'.

          er_data_changed->get_cell_value(
            EXPORTING
              i_row_id    = ls_data_changet-row_id                 " Row ID
              i_fieldname = ls_data_changet-fieldname ).   " Field Name

          CHECK ls_data_changet-value IS INITIAL. " verifica si el valor no es nulo
            lv_valid = abap_true.
            er_data_changed->add_protocol_entry(
              EXPORTING
                i_msgid     = 'ZEMP_ALFA02'                  " Message ID
                i_msgty     = 'E'                 " Message Type
                i_msgno     = '007'                " Message No.
                i_fieldname = ls_data_changet-fieldname                   " Field Name
                i_row_id    = ls_data_changet-row_id     ).               " RowID

        WHEN ''.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD handle_data_changed_finish.

    FIELD-SYMBOLS <ls_cap> TYPE gty_cap.
    DATA ls_good_cells TYPE lvc_s_modi.

    CHECK e_modified EQ abap_true.

    LOOP AT et_good_cells INTO ls_good_cells.
      READ TABLE gt_cap ASSIGNING <ls_cap> INDEX ls_good_cells-row_id.
      CHECK sy-subrc EQ 0.
        <ls_cap>-bbdd = abap_true.

    ENDLOOP.

  ENDMETHOD.


  METHOD handle_toolbar.

    DATA ls_toolbar TYPE stb_button.

    ls_toolbar-function = 'T_SAVE'.
    ls_toolbar-quickinfo = 'SAVE'.
    ls_toolbar-icon = icon_modify.
    ls_toolbar-text = TEXT-018.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR: ls_toolbar.

    ls_toolbar-function = 'T_DELETE'.
    ls_toolbar-quickinfo = 'DELETE'.
    ls_toolbar-icon = icon_delete.
    ls_toolbar-text = TEXT-019.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.

  METHOD handle_user_command.

    DATA: lt_bbdd_cap TYPE TABLE OF za23_capac,
          ls_bddd_cap TYPE za23_capac,
          ls_cap      TYPE gty_cap,
          ls_selec TYPE lvc_s_roid.

            DATA: lv_msg TYPE string.

    CASE e_ucomm.
      WHEN 'T_SAVE'.


MESSAGE e039(zemp_alfa02) INTO lv_msg.
CALL FUNCTION 'POPUP_TO_CONFIRM'
  EXPORTING
   titlebar                    = TEXT-002
    text_question               = lv_msg
   text_button_1               = TEXT-001
   text_button_2               = 'No'
   display_cancel_button       = 'X'
 IMPORTING
   answer                      = gv_answ
 EXCEPTIONS
   text_not_found              = 1
   OTHERS                      = 2
          .
  CLEAR lv_msg.

  IF gv_answ eq '1'.

        LOOP AT gt_cap INTO ls_cap WHERE bbdd EQ abap_true.
          MOVE-CORRESPONDING ls_cap TO ls_bddd_cap.
          APPEND ls_bddd_cap TO lt_bbdd_cap.
        ENDLOOP.

        LOOP AT lt_bbdd_cap ASSIGNING FIELD-SYMBOL(<lf_field>).
          CASE <lf_field>.
            WHEN <lf_field>-nombre_capacitacion.
              CONDENSE <lf_field>-nombre_capacitacion.
            WHEN <lf_field>-descripcion.
              CONDENSE <lf_field>-descripcion.
            WHEN <lf_field>-nombre_institucion.
              CONDENSE <lf_field>-nombre_institucion.
            WHEN OTHERS.
          ENDCASE.
        ENDLOOP.

        CHECK sy-subrc EQ 0.

          MODIFY za23_capac FROM TABLE lt_bbdd_cap.
          CHECK sy-subrc EQ 0.
            COMMIT WORK.
            PERFORM get_catalog_data USING 'SC_TRAG'.
            PERFORM regresh_Catalo_alv.
            MESSAGE s008(zemp_alfa02).
ENDIF.

      WHEN 'T_DELETE'.


MESSAGE e040(zemp_alfa02) INTO lv_msg.
CALL FUNCTION 'POPUP_TO_CONFIRM'
  EXPORTING
   titlebar                    = TEXT-002
    text_question               = lv_msg
   text_button_1               = TEXT-001
   text_button_2               = 'No'
   display_cancel_button       = 'X'
 IMPORTING
   answer                      = gv_answ
 EXCEPTIONS
   text_not_found              = 1
   OTHERS                      = 2
          .
  CLEAR lv_msg.

  IF gv_answ eq '1'.


        DATA: lt_roid TYPE lvc_t_roid,
              lv_opt  TYPE c.

        go_catalog_alv->get_selected_rows(
          IMPORTING
            et_row_no     = lt_roid                " Numeric IDs of Selected Rows
        ).
        IF lt_roid IS INITIAL.
          "MENSAJE DE QUE SELECCIONE LOS DATOS
          EXIT.
        ENDIF.

        "POPUP_TO_CONFIRM

        CHECK lt_roid IS NOT INITIAL.
          LOOP AT lt_roid INTO ls_selec.
            READ TABLE gt_cap ASSIGNING FIELD-SYMBOL(<ls_cap_d>) INDEX ls_selec-row_id.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING <ls_cap_d> TO ls_bddd_cap.
              APPEND ls_bddd_cap TO lt_bbdd_cap.
            ENDIF.
          ENDLOOP.

          IF lt_bbdd_cap IS NOT INITIAL.
             DELETE za23_capac FROM TABLE lt_bbdd_cap.
             COMMIT WORK.
             PERFORM get_catalog_data USING 'SC_TRAG'.
             PERFORM regresh_Catalo_alv.
             MESSAGE s009(zemp_alfa02) DISPLAY LIKE 'S'.
          ELSE.
*            MESSAGE S009(ZEMP_ALFA02). MENSAJE DE DATOS NO ELIMINADOS
          ENDIF.
 ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD handle_hotspot_click_training.


    FIELD-SYMBOLS: <ls_data> TYPE any. " symbold field
    gv_code = 'ACT_UPD'.
    READ TABLE gt_train ASSIGNING <ls_data> INDEX es_row_no-row_id.
    MOVE-CORRESPONDING <ls_data> TO gs_train.
    gv_value_row = gs_train-id_empleado.

    MOVE-CORRESPONDING gs_train TO gs_train_upd.

    SELECT SINGLE emp~id_empleado, emp~nombre, emp~apellido_paterno, emp~apellido_materno,
     tra~nombre_capacitacion, tra~descripcion, tra~horas, tra~nombre_institucion,
     tra~fecha_inicio_cap, tra~fecha_finalizacion_cap
    FROM za23_empleados AS emp
    INNER JOIN za23_emp_cap AS emp_tra ON
      emp~id_empleado EQ emp_tra~id_empleado
    INNER JOIN za23_capac AS tra ON
      emp_tra~id_capacitacion EQ tra~id_capacitacion
    INTO @DATA(lt_data) WHERE emp_tra~id_cap_emp EQ @gs_train_upd-id_cap_emp.

    za23_empleados-id_empleado = lt_data-id_empleado.
    DATA lv_name TYPE string.
    lv_name = | { lt_data-nombre } { lt_data-apellido_paterno } { lt_data-apellido_materno } |.
    za23_empleados-nombre = lv_name.
    MOVE-CORRESPONDING lt_data TO za23_capac.

    CALL SCREEN 3102 STARTING AT 10 05 ENDING AT 141 17.

  ENDMETHOD.

  METHOD handle_onf4.

    TYPES: BEGIN OF lty_name_trag,
      nombre_capacitacion TYPE za23_nombre_cap.
    TYPES: END OF lty_name_trag.
" valores de la base de datos
    DATA: lt_name_trag TYPE TABLE OF lty_name_trag,
          ls_name_trag TYPE lty_name_trag.
" tabla de valores de la ayuda de busqueda
    DATA: lt_return_tab TYPE TABLE OF ddshretval,
          ls_return_tab TYPE ddshretval.
" tabla interna con las modificacione
    FIELD-SYMBOLS <lt_mod_data> TYPE lvc_t_modi.
    DATA: ls_mod_data TYPE lvc_s_modi.


    CASE e_fieldname.
      WHEN 'NOMBRE_CAPACITACION'.
        SELECT nombre_capacitacion FROM za23_capac
          INTO TABLE lt_name_trag WHERE nombre_capacitacion NE space.

        IF sy-subrc EQ 0.
          CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
            EXPORTING
             retfield               = 'NOMBRE_CAPACITACION'
             dynpprog               = sy-repid
             dynpnr                 = sy-dynnr
             dynprofield            = 'NOMBRE_CAPACITACION'
             value_org              = 'S'
            TABLES
              value_tab              = lt_name_trag
             return_tab             = lt_return_tab
           EXCEPTIONS
             parameter_error        = 1
             no_values_found        = 2
             OTHERS                 = 3
                    .
          IF sy-subrc <> 0.

          ELSE.
            READ TABLE lt_return_tab INTO ls_return_tab INDEX 1.
            IF sy-subrc EQ 0.
              ls_mod_data-row_id = es_row_no-row_id.
              ls_mod_data-fieldname = e_fieldname.
              ls_mod_data-value = ls_return_tab-fieldval.
              ASSIGN er_event_data->m_data->* TO <lt_mod_data>.
              APPEND ls_mod_data TO <lt_mod_data>.
              er_event_data->m_event_handled = abap_true.
            ENDIF.
          ENDIF.
        ENDIF.

      WHEN ''.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD handle_data_changed_t.
    DATA: ls_data_changet TYPE lvc_s_modi,
          lv_name_tra        TYPE za23_nombre_cap.

    LOOP AT er_data_changed->mt_good_cells INTO ls_data_changet.
      CASE ls_data_changet-fieldname.  "search in of framework
        WHEN 'NOMBRE_CAPACITACION'.

          er_data_changed->get_cell_value(
            EXPORTING
              i_row_id    = ls_data_changet-row_id                 " Row ID
              i_fieldname = ls_data_changet-fieldname    " Field Name
            IMPORTING
                 e_value     =    lv_name_tra ).

          SELECT SINGLE nombre_capacitacion FROM za23_capac INTO lv_name_tra WHERE nombre_capacitacion EQ lv_name_tra.

          CHECK sy-subrc NE 0. " verifica si el valor no es nulo

            er_data_changed->add_protocol_entry(
              EXPORTING
                i_msgid     = 'ZEMP_ALFA02'                  " Message ID
                i_msgty     = 'E'                 " Message Type
                i_msgno     = '007'                " Message No.
                i_fieldname = ls_data_changet-fieldname                   " Field Name
                i_row_id    = ls_data_changet-row_id     ).               " RowID

        WHEN ''.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD handle_data_changed_finish_t.

    FIELD-SYMBOLS <ls_cap> TYPE gty_EM_EC_C.
    DATA ls_good_cells TYPE lvc_s_modi.

    CHECK e_modified EQ abap_true.

    LOOP AT et_good_cells INTO ls_good_cells.
      READ TABLE gtv_em_ec_c ASSIGNING <ls_cap> INDEX ls_good_cells-row_id.
      CHECK sy-subrc EQ 0.
        <ls_cap>-bbdd = abap_true.
    ENDLOOP.

  ENDMETHOD.

   METHOD handle_toolbar_t.

    DATA ls_toolbar TYPE stb_button.

    ls_toolbar-function = 'TA_DELETE'.
    ls_toolbar-quickinfo = 'DELETE'.
    ls_toolbar-icon = icon_delete.
    ls_toolbar-text = TEXT-019.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.

  METHOD handle_user_command_t.

    DATA: lt_bbdd_cap TYPE TABLE OF za23v_em_ec_c,
          ls_bbdd_emc TYPE  za23v_em_ec_c,
          ls_bddd_cap TYPE za23_capac,
          ls_cap      TYPE gty_EM_EC_C,
          ls_selec TYPE lvc_s_roid.

    CASE e_ucomm.
*      WHEN 'TA_SAVE'.
*        LOOP AT gtv_em_ec_c INTO ls_cap WHERE bbdd EQ abap_true.
*          ls_bbdd_emc-nombre_capacitacion = ls_cap-nombre_capacitacion.
*          ls_bbdd_emc-id_empleado = ls_cap-id_empleado.
*          ls_bbdd_emc-id_cap_emp = ls_cap-id_cap_emp.
*        ENDLOOP.
*        select SINGLE * from za23_capac into ls_bddd_cap  where nombre_capacitacion
*          EQ ls_bbdd_emc-nombre_capacitacion.
*        IF sy-subrc EQ 0.
*          UPDATE ZA23_EMP_CAP SET id_capacitacion = ls_bddd_cap-id_capacitacion
*              where id_empleado EQ ls_bbdd_emc-id_empleado and
*                    id_cap_emp eq ls_bbdd_emc-id_cap_emp.
*          IF SY-SUBRC EQ 0.
*            COMMIT WORK.
*            PERFORM free_container.
*            PERFORM assigns_corresp_value USING 'SAV_TRAG'.
*            PERFORM go_container USING 'SAV_TRAG'.
*            MESSAGE s008(zemp_alfa02).
*          ENDIF.
*        ENDIF.
      WHEN 'TA_DELETE'.



       DATA: lt_roid TYPE lvc_t_roid,
             lv_opt  TYPE c,
             ls_cap_tem TYPE za23_emp_cap,
             lt_cap_tem TYPE TABLE OF za23_emp_cap.

        go_catalog_alv->get_selected_rows(
          IMPORTING
            et_row_no     = lt_roid                " Numeric IDs of Selected Rows
        ).

        IF lt_roid IS INITIAL.
          MESSAGE w021(zemp_alfa02).
          EXIT.
        ENDIF.

        DATA: lv_msg        TYPE string,
              lv_conf.

        PERFORM simple_delete_message.

        IF gv_answ = '1'.

          CHECK lt_roid IS NOT INITIAL.
            LOOP AT lt_roid INTO ls_selec.
              READ TABLE gt_train ASSIGNING FIELD-SYMBOL(<ls_cap_d>) INDEX ls_selec-row_id.
              IF sy-subrc EQ 0.

                ls_cap_tem-id_cap_emp = <ls_cap_d>-id_cap_emp.
                ls_cap_tem-id_empleado = <ls_cap_d>-id_empleado.
                ls_cap_tem-id_asignacion = <ls_cap_d>-id_asignacion.
                ls_cap_tem-id_capacitacion = <ls_cap_d>-id_capacitacion.
                ls_cap_tem-fecha_asignacion = sy-datum.

*                MOVE-CORRESPONDING <ls_cap_d> TO ls_bddd_cap.
                APPEND ls_cap_tem TO lt_cap_tem.
              ENDIF.
            ENDLOOP.

            IF lt_cap_tem IS NOT INITIAL.
               DELETE za23_emp_cap FROM TABLE lt_cap_tem.
               COMMIT WORK.
               DATA: lt_asig_where TYPE TABLE OF string.
               PERFORM create_where_trainier TABLES lt_asig_where.
               PERFORM regresh_Catalo_alv.
               MESSAGE s009(zemp_alfa02).
            ELSE.
              MESSAGE s020(zemp_alfa02).
            ENDIF.
          ENDIF.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  "method payroll
  METHOD handle_toolbar_payroll.

    DATA ls_toolbar TYPE stb_button.

    ls_toolbar-function = 'PAY_SAVE'.
    ls_toolbar-quickinfo = 'SAVE'.
    ls_toolbar-icon = '@F_SAVE@'.

    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.

  METHOD handle_data_changed_payroll.

    DATA: ls_data_changed TYPE lvc_s_modi,
          lv_data         TYPE string.

    LOOP AT er_data_changed->mt_good_cells INTO ls_data_changed .
      CASE ls_data_changed-fieldname.
        WHEN 'BONO_APOYO'.
          er_data_changed->get_cell_value(
            EXPORTING
                i_row_id    =  ls_data_changed-row_id
                i_fieldname = ls_data_changed-fieldname
             IMPORTING
                e_value     = lv_data  ).

          IF lv_data < '0'.
            MESSAGE s011(zemp_alfa02).
          ENDIF.

          WHEN ''.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.

  ENDMETHOD.

  METHOD handle_data_chan_fish_payroll.

    DATA: ls_good_cells TYPE lvc_s_modi,
          lv_msg        TYPE string,
          lv_conf.

    MESSAGE e012(zemp_alfa02) INTO lv_msg.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
       titlebar                    = TEXT-002
        text_question               = lv_msg
       text_button_1               = TEXT-001
       text_button_2               = 'NO'
       display_cancel_button       = 'X'
     IMPORTING
       answer                      = lv_conf
     EXCEPTIONS
       text_not_found              = 1
       OTHERS                      = 2 .

    IF e_modified EQ abap_true AND lv_conf EQ '1'.
*  check e_modified EQ abap_true.
    LOOP AT et_good_cells INTO ls_good_cells.
      READ TABLE gt_payroll ASSIGNING FIELD-SYMBOL(<ls_payroll>) INDEX ls_good_cells-row_id.
      IF sy-subrc EQ 0.
        <ls_payroll>-bbdd = abap_true.
        <ls_payroll>-total_pago = <ls_payroll>-total_pago + <ls_payroll>-bono_apoyo.
      ENDIF.
    ENDLOOP.

    ELSE.

     LOOP AT et_good_cells INTO ls_good_cells.
       READ TABLE gt_payroll ASSIGNING FIELD-SYMBOL(<ls_del_payroll>) INDEX ls_good_cells-row_id.
       IF sy-subrc EQ 0.
         <ls_del_payroll>-bono_apoyo = '0.00'.
         <ls_del_payroll>-total_pago = <ls_del_payroll>-total_pago + <ls_del_payroll>-bono_apoyo.
       ENDIF.
     ENDLOOP.

    ENDIF.

    PERFORM refresh_container.

  ENDMETHOD.

  METHOD handle_user_command_payroll.

    DATA: ls_payroll_record  TYPE za23_reg_nominas.

    CASE e_ucomm.
      WHEN 'PAY_SAVE'.

                DATA: lv_conf,
              lv_msg        TYPE string.

    MESSAGE e042(zemp_alfa02) INTO lv_msg.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
       titlebar                    = TEXT-002
        text_question               = lv_msg
       text_button_1               = TEXT-001
       text_button_2               = 'NO'
       display_cancel_button       = 'X'
     IMPORTING
       answer                      = lv_conf
     EXCEPTIONS
       text_not_found              = 1
       OTHERS                      = 2 .

    IF lv_conf EQ '1'.

        IF za23_reg_nominas-forma_pago IS NOT INITIAL.

        DATA(lv_num_rows) = lines( gt_payroll ).

        DO lv_num_rows TIMES.
          DATA(lv_num_index) = sy-index.
          DATA: lv_number_id TYPE i.

          CALL METHOD genrate_id( num_index = lv_number_id ).

          MOVE-CORRESPONDING gt_payroll[ lv_num_index ] TO ls_payroll_record.
          ls_payroll_record-mandt = sy-mandt.
          ls_payroll_record-id_pag_nomina = lv_number_id.
          ls_payroll_record-fecha_inicio_pago = gv_date-low.
          ls_payroll_record-fecha_fin_pago = gv_date-high.
          ls_payroll_record-fecha_pago = '20230621'."sy-datum'.
          ls_payroll_record-forma_pago = 'CASH'."za23_reg_nominas-forma_pago.
          ls_payroll_record-pago_usuario = sy-uname.
          INSERT INTO za23_reg_nominas VALUES ls_payroll_record.
          IF sy-subrc EQ 0.
            COMMIT WORK.
          ELSE.
            ROLLBACK WORK.
          ENDIF.
          CLEAR ls_payroll_record.
        ENDDO.
        ELSE.
          MESSAGE s024(zemp_alfa02) DISPLAY LIKE 'E'.
        ENDIF.
        ENDIF.
      WHEN ''.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD genrate_id.

    DATA: lv_number_id TYPE numc10.

    CALL FUNCTION 'NUMBER_GET_NEXT'
            EXPORTING
              nr_range_nr                   = '01'
              object                        = 'ZNI_PAY_A2'
           IMPORTING
             number                        = lv_number_id
           EXCEPTIONS
             interval_not_found            = 1
             number_range_not_intern       = 2
             object_not_found              = 3
             quantity_is_0                 = 4
             quantity_is_not_1             = 5
             interval_overflow             = 6
             buffer_overflow               = 7
             OTHERS                        = 8 .
          IF sy-subrc <> 0.

          ENDIF.

  ENDMETHOD.

  METHOD handle_hotspot_click_vac_perm.

    FIELD-SYMBOLS: <ls_data> TYPE any.

    READ TABLE gt_emp_cap ASSIGNING <ls_data> INDEX es_row_no-row_id.
    MOVE-CORRESPONDING <ls_data> TO gs_emp_cap.
    CONCATENATE gs_emp_cap-nombre gs_emp_cap-apellido_paterno gs_emp_cap-apellido_materno INTO za23_empleados-nombre.
    MOVE-CORRESPONDING gs_emp_cap TO za23_vac_perm.
    gv_act = 'ACT_UPD'.
    CALL SCREEN 3301 STARTING AT 10 05 ENDING AT 80 14.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_transaction DEFINITION.

  PUBLIC SECTION.

  CLASS-METHODS on_transaction_reg_emp FOR EVENT transaction_finished
                OF cl_system_transaction_state IMPORTING kind.

  PRIVATE SECTION.

  CLASS-METHODS: insert_family IMPORTING num_index TYPE i,
                 insert_skill  IMPORTING num_index TYPE i.

  CLASS-METHODS: call_screen_job_assignment.

ENDCLASS.

CLASS lcl_generate_id DEFINITION.

  PUBLIC SECTION.

  METHODS: id_fam   RETURNING VALUE(value_id_fam) TYPE i,
           id_skill RETURNING VALUE(value_id_skill) TYPE i.

ENDCLASS.

CLASS lcl_generate_id IMPLEMENTATION.

  METHOD id_fam.
   DATA: lv_number_id_fam TYPE numc10.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr                   = '01'
        object                        = 'ZNI_FAM_A2'
     IMPORTING
       number                        = lv_number_id_fam
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
      value_id_fam = 0.
    ELSE.
      value_id_fam = lv_number_id_fam.
    ENDIF.

 ENDMETHOD.

 METHOD id_skill.

   DATA: lv_number_id_skill TYPE numc10.

   CALL FUNCTION 'NUMBER_GET_NEXT'
     EXPORTING
       nr_range_nr                   = '01'
       object                        = 'ZNI_SKI_A2'
    IMPORTING
      number                        = lv_number_id_skill
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
     value_id_skill = 0.
   ELSE.
     value_id_skill = lv_number_id_skill.
   ENDIF.


 ENDMETHOD.

ENDCLASS.

CLASS lcl_transaction IMPLEMENTATION.

METHOD on_transaction_reg_emp.

  IF kind EQ cl_system_transaction_state=>commit_work .

    IF sy-subrc EQ 0.
      DATA(lv_numf_rows) = lines( gt_family ).
      DATA(lv_nums_rows) = lines( gt_skill ).
      CREATE OBJECT go_generate_id.

      DO lv_numf_rows  TIMES.
        DATA(lv_num_index) = sy-index.
        CALL METHOD insert_family
          EXPORTING
            num_index = lv_num_index.
      ENDDO.

      DO lv_nums_rows TIMES.
        DATA(lv_nums_index) = sy-index.
        CALL METHOD insert_skill
          EXPORTING
            num_index = lv_nums_index.
      ENDDO.

    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDIF.

  IF kind EQ cl_system_transaction_state=>rollback_work.
    MESSAGE s036(zemp_alfa02) DISPLAY LIKE 'E'.
  ENDIF.

ENDMETHOD.

  METHOD insert_family.

    DATA(lv_value_id) = go_generate_id->id_fam( ).
    IF lv_value_id NE 0.
      gt_family[ num_index ]-id_familiar = lv_value_id.
      gt_family[ num_index ]-id_empleado = za23_empleados-id_empleado.
      IF sy-subrc EQ 0.
        DATA: lt_fam TYPE TABLE OF za23_familiares.
        APPEND gt_family[ num_index ] TO lt_fam.
        INSERT za23_familiares FROM TABLE lt_fam.
      ELSE.
         ROLLBACK WORK.
         EXIT.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
      EXIT.
    ENDIF.

  ENDMETHOD.

  METHOD insert_skill.

    DATA(lv_value_skill_id) = go_generate_id->id_skill( ).
    IF lv_value_skill_id NE 0.
      gt_skill[ num_index ]-id_habilidad = lv_value_skill_id.
      gt_skill[ num_index ]-id_empleado = za23_empleados-id_empleado.
      IF sy-subrc EQ 0.
        DATA: ls_skill TYPE TABLE OF za23_habilidades.
        APPEND gt_skill[ num_index ] TO ls_skill.
        INSERT za23_habilidades FROM TABLE ls_skill.
      ELSE.
        ROLLBACK WORK.
        EXIT.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
      EXIT.
    ENDIF.

  ENDMETHOD.

  METHOD call_screen_job_assignment.

  ENDMETHOD.

ENDCLASS.


CLASS lcl_validate_data DEFINITION.

  PUBLIC SECTION.

  METHODS: regex_name IMPORTING name TYPE string
    RETURNING VALUE(value_name) TYPE abap_bool.

  METHODS: regex_address IMPORTING address TYPE string
    RETURNING VALUE(value_adress) TYPE abap_bool.

  METHODS: regex_phone IMPORTING phone TYPE string
    RETURNING VALUE(value_phone) TYPE abap_bool.

  METHODS: regex_email IMPORTING email TYPE string
    RETURNING VALUE(value_email) TYPE abap_bool.

  METHODS: regex_curp IMPORTING curp TYPE string
    RETURNING VALUE(value_curp) TYPE abap_bool.

  METHODS: regex_rfc IMPORTING rfc TYPE string
    RETURNING VALUE(value_rfc) TYPE abap_bool.

  METHODS: regex_imss IMPORTING imss TYPE string
    RETURNING VALUE(value_imss) TYPE abap_bool.
*
*  METHODS: regex_zop_cd IMPORTING zip_code TYPE string
*      RETURNING VALUE(value_zip_cd) TYPE abap_bool.

*   check if this data is not already stored
  METHODS: check_data_not_already_stored.

  PRIVATE SECTION.

  CONSTANTS:
   rgx_name   TYPE string VALUE '^[a-zA-ZÑñ]+([ ]?[a-zA-ZÑñ]+)*$',
   rgx_street TYPE string VALUE '^[a-zA-ZÑñ0-9.,\s]+$',
   rgx_phone  TYPE string VALUE '^(?![0])([0-9]){10,10}$',
   rgx_email  TYPE string VALUE '^(?![\.\-\_\*\d])([a-zA-Z0-9]+)@([a-zA-Z]{2,20})(\.)([a-zA-Z]{2,7}).*$',
   rgx_curp   TYPE string VALUE '^(?=[A-ZÑ&]{4})([A-ZÑ&])([AEIOUX]{1})([A-ZÑ&]{2})([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])([HM]{1})([A-ZÑ&]{2})([B-DF-HJ-NP-TV-Z]{3})([0-9A-Z]{1})([0-9]{1})$',
   rgx_rfc    TYPE string VALUE '^([A-Z&Ñ]{4})(\d{2})((0[1-9])|(1[0-2]))(([0-2][1-9])|(3[0-1]))[A-Z\d]{3}$|^([A-Z&Ñ]{4})((\d{2}(0[1-9]|1[0-2])([0-2][1-9]|3[0-1])))((\w*[^\s\w]{1}\w*[^\s\w?])|(X{1}))(\d{3})$',
   rgx_imss   TYPE string VALUE '[0-9]{11,11}$',
   rgx_zip_cd TYPE string VALUE '[0-9]{5,5}$'.

ENDCLASS.


CLASS lcl_validate_data IMPLEMENTATION.


  METHOD regex_name.

    FIND REGEX rgx_name IN name.

    value_name = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

  ENDMETHOD.

  METHOD regex_address.

    FIND REGEX rgx_street IN address.

    value_adress = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

  ENDMETHOD.

  METHOD regex_phone.

    FIND REGEX rgx_phone IN phone.

    value_phone = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

  ENDMETHOD.

  METHOD regex_email.

    DATA lv_pos.

    FIND REGEX rgx_email IN email IGNORING CASE MATCH OFFSET lv_pos.

    value_email = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

    CLEAR lv_pos.

  ENDMETHOD.

  METHOD regex_curp.

    DATA lv_pos.

    FIND REGEX rgx_curp IN curp IGNORING CASE MATCH OFFSET lv_pos.

    value_curp = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

    CLEAR lv_pos.

  ENDMETHOD.

  METHOD regex_rfc.

    FIND REGEX rgx_rfc IN rfc.

    value_rfc = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

  ENDMETHOD.

  METHOD regex_imss.

  FIND REGEX rgx_imss IN imss.

  IF sy-subrc EQ 0 AND imss <> '00000000000'.

    value_imss = abap_true.

  ELSE.
    value_imss = abap_false.
  ENDIF.

  ENDMETHOD.

  METHOD  check_data_not_already_stored.  "check if this data is not already stored

    DATA: lv_flag_emp TYPE abap_bool.
    lv_flag_emp = abap_true.

    SELECT curp, rfc, n_reg_patronal FROM za23_empleados
      WHERE curp = @za23_empleados-curp OR
      rfc =  @za23_empleados-rfc OR
      n_reg_patronal =  @za23_empleados-n_reg_patronal
      INTO @DATA(ls_check_data).

    IF sy-subrc EQ 0.

      lv_flag_emp = abap_false.

      IF ls_check_data-curp EQ za23_empleados-curp.
        warning_light16 = icon_incomplete.
        PERFORM notification_curp.
      ENDIF.

      IF ls_check_data-rfc EQ za23_empleados-rfc.
        warning_light17 = icon_incomplete.
        PERFORM notification_rfc.
      ENDIF.

      IF ls_check_data-n_reg_patronal EQ za23_empleados-n_reg_patronal.
        warning_light18 = icon_incomplete.
        PERFORM notification_imss.
      ENDIF.

    ENDIF.

  ENDSELECT.

  IF lv_flag_emp EQ abap_false.
    gv_flag_emp = abap_false.
    MESSAGE w014(zemp_alfa02) DISPLAY LIKE 'E'.
  ENDIF.

  ENDMETHOD.

ENDCLASS.
