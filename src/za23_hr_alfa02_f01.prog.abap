*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_F01
*&ZA23_HR_ALFA02_CLRGX
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CALL_ADD_EMPLOYEE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM call_add_employee .

  CLEAR: gt_family, ls_family, za23_empleados.
*  CREATE OBJECT: go_register_emp.
  PERFORM instance_alv_emp.
  CALL SCREEN 3000.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form NAVIGATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM navigation .

  lv_refresh = |CLEAR_SCREEN_{ sy-dynnr }|.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3000 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'SAVE'.
      PERFORM confirmation_save.
      IF gv_answ = '1'.
        PERFORM employee_data.
        PERFORM check_record_emp.
      ENDIF.
    WHEN 'ADD_FAM'.
      CLEAR: ls_family.
      SET CURSOR FIELD 'BOX_5'.
      gv_code = 'DES_DEL'.
      CALL SCREEN 3001 STARTING AT 10 05 ENDING AT 155 16.
    WHEN 'ADD_SKI'.
      CLEAR: gs_skill.
      gv_code = 'DES_DEL'.
      CALL SCREEN 3002 STARTING AT 10 05 ENDING AT 90 15.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3001
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3001 .
  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'SAVE'.
        PERFORM temporary_data_family.
    WHEN 'DELT_FAM'.
      PERFORM simple_delete_message.
      IF gv_answ = '1'.
        PERFORM delete_data_family.
      ENDIF.
    WHEN 'BACK'.
      CLEAR: ls_family.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      CLEAR: ls_family.
      LEAVE TO SCREEN 0.
    WHEN 'OPT1'.
      CLEAR: ls_family.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form employee_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM employee_data.

  gv_flag_emp = abap_true.

  IF go_validate->regex_name( name = CONV string(  za23_empleados-nombre ) ) = abap_true.
    warning_light1 = icon_checked.
   ELSE.
     warning_light1 = icon_incomplete.
     gv_flag_emp = abap_false.
  ENDIF.

  PERFORM notification_name.

  IF go_validate->regex_name( name = CONV string(  za23_empleados-apellido_paterno ) ) = abap_true.
    warning_light2 = icon_checked.
   ELSE.
     warning_light2 = icon_incomplete.
     gv_flag_emp = abap_false.
  ENDIF.

  PERFORM nofitication_data_pat.

  IF go_validate->regex_name( name = CONV string(  za23_empleados-apellido_materno ) ) = abap_true.
    warning_light3 = icon_checked.
  ELSE.
     warning_light3 = icon_incomplete.
     gv_flag_emp = abap_false.
  ENDIF.

  IF rb1_gn_male EQ abap_true.
    za23_empleados-genero = 'M'.
  ELSE.
    za23_empleados-genero = 'F'.
  ENDIF.

  PERFORM nofitication_data_mat.

  CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
    EXPORTING
      date                            = za23_empleados-fecha_nacimiento
   EXCEPTIONS
     plausibility_check_failed       = 1
     OTHERS                          = 2
            .
  IF sy-subrc <> 0.
    warning_light4 = icon_incomplete.
    gv_flag_emp = abap_false.
  ELSE.

    DATA lr_cx_root TYPE REF TO cx_root.

    TRY.
      DATA lv_bth_date TYPE begda.
      DATA lv_curr_date TYPE endda.
      DATA lv_handler_hrpa TYPE REF TO  if_hrpa_message_handler.
      DATA lv_age TYPE num2.

      lv_bth_date = za23_empleados-fecha_nacimiento.
      lv_curr_date = sy-datum.

      CALL FUNCTION 'HR_ECM_GET_PERIOD_BETW_DATES'
        EXPORTING
          begda           = lv_bth_date
          endda           = lv_curr_date
          message_handler = lv_handler_hrpa
        IMPORTING
          num_years       = lv_age.

    CATCH cx_root INTO lr_cx_root.
      DATA(l_c_message) = lr_cx_root->if_message~get_longtext( ).
      MESSAGE l_c_message TYPE 'E'.
    ENDTRY.

    IF lv_age GE 18.
      warning_light4 = icon_checked.
    ELSE.
      warning_light4 = icon_incomplete.
      gv_flag_emp = abap_false.
    ENDIF.
    CLEAR: lv_bth_date, lv_curr_date, lv_handler_hrpa, lv_age.
  ENDIF.

  PERFORM nofitication_data_dat.

  IF za23_empleados-estado_civil IS NOT INITIAL.
    warning_light5 = icon_checked.
  ELSE.
    warning_light5 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

  PERFORM nofitication_marial_status.

  IF go_validate->regex_address( address = CONV string( za23_empleados-calle ) ) = abap_true.
    warning_light6 = icon_checked.
  ELSE.
    warning_light6 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

  PERFORM nofitication_address.

  IF go_validate->regex_address( address = CONV string( za23_empleados-colonia ) ) = abap_true.
    warning_light7 = icon_checked.
  ELSE.
    warning_light7 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

  PERFORM nofitication_address2.

  IF go_validate->regex_name( name = CONV string( za23_empleados-municipio ) ) = abap_true.
    warning_light8 = icon_checked.
  ELSE.
    warning_light8 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

  PERFORM nofitication_municipality.

  IF go_validate->regex_name( name = CONV string( za23_empleados-estado ) ).
    warning_light11 = icon_checked.
  ELSE.
    warning_light11 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

  IF za23_empleados-no_interior IS INITIAL.
    warning_light9 = icon_incomplete.
    gv_flag_emp = abap_false.
  ELSE.
    warning_light9 = icon_checked.
  ENDIF.

  PERFORM nofitication_int_entry.


  IF za23_empleados-no_exterior IS NOT INITIAL.
    warning_light10 = icon_checked.
  ENDIF.

  PERFORM nofitication_ext_entry.

  PERFORM nofitication_state.

  IF za23_empleados-cp IS INITIAL.
    warning_light12 = icon_incomplete.
    gv_flag_emp = abap_false.
  ELSE.
    warning_light12 = icon_checked.
  ENDIF.

  PERFORM notification_postal_code.

  IF go_validate->regex_phone( phone = CONV string( za23_empleados-n_telefono1 ) ) = abap_true AND ( za23_empleados-n_telefono1 NE '0000000000' ).
    warning_light13 = icon_checked.
  ELSE.
    warning_light13 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

  PERFORM notification_phone.

  IF za23_empleados-n_telefono2 NE '0000000000'.
    IF go_validate->regex_phone( phone = CONV string( za23_empleados-n_telefono2 ) ) = abap_true.
      warning_light14 = icon_checked.
    ELSE.
      warning_light14 = icon_incomplete.
      gv_flag_emp = abap_false.
    ENDIF.

    PERFORM notification_phone2.

  ENDIF.

  IF go_validate->regex_email( email = CONV string( za23_empleados-correo_elec ) ) = abap_true.
    warning_light15 = icon_checked.
  ELSE.
    warning_light15 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

  PERFORM notification_email.

  IF go_validate->regex_curp( curp = CONV string( za23_empleados-curp ) ) = abap_true.
    warning_light16 = icon_checked.
  ELSE.
    warning_light16 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

" warning_light16 = go_validate->regex_curp( curp = CONV string( za23_empleados-curp ) ) = abap_true ? icon_checked : icon_incomplete.
*lv_flag = warning_light16 = icon_checked.

  PERFORM notification_curp.

  IF go_validate->regex_rfc( rfc = CONV string( za23_empleados-rfc ) ) = abap_true.
    warning_light17 = icon_checked.
  ELSE.
    warning_light17 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

  PERFORM notification_rfc.

  IF go_validate->regex_imss( imss = CONV string( za23_empleados-n_reg_patronal ) )  = abap_true.
    warning_light18 = icon_checked.
  ELSE.
    warning_light18 = icon_incomplete.
    gv_flag_emp = abap_false.
  ENDIF.

  PERFORM notification_imss.

  MODIFY SCREEN.

ENDFORM.

"--------
*&---------------------------------------------------------------------*
*& Form instance_alv_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_alv_emp.

  CLEAR: lv_txt_id_emp, za23_empleados.
  CREATE OBJECT: go_register_emp.

  CHECK ok_code IS NOT INITIAL.

  PERFORM instance_custom_container USING 'FAMILY'.
  PERFORM create_fieldcat USING 'FAMILY'.
  PERFORM instance_exe_alv USING 'FAMILY'.
  PERFORM display_alv USING 'FAMILY'.

  PERFORM instance_custom_container USING 'SKILLS'.
  PERFORM create_fieldcat USING 'SKILLS'.
  PERFORM instance_exe_alv USING 'SKILLS'.
  PERFORM display_alv USING 'SKILLS'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_in_out_fcat
*&---------------------------------------------------------------------*
*& CUSTOM CONTAINER
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_custom_container CHANGING cont_name TYPE c.

  CASE cont_name.
    WHEN 'FAMILY'.
      CREATE OBJECT go_cust_cont_emerg
        EXPORTING
          container_name              = 'CONT_EMERG'                 " Name of the Screen CustCtrl Name to Link Container To
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

    WHEN 'SKILLS'.
      CREATE OBJECT go_cust_cont_skill
        EXPORTING
          container_name              = 'CONT_SKILL'                " Name of the Screen CustCtrl Name to Link Container To
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

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_fieldcat CHANGING struc_name TYPE c.

CASE struc_name.

  WHEN 'FAMILY'.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
     EXPORTING
       i_structure_name             = 'ZA23_FAMILIARES'
      CHANGING
        ct_fieldcat                  = gt_fieldcat_emerg
     EXCEPTIONS
       inconsistent_interface       = 1
       program_error                = 2
       OTHERS                       = 3.

  IF sy-subrc EQ 0.

    LOOP AT gt_fieldcat_emerg ASSIGNING FIELD-SYMBOL(<ls_fielcat_emerg>).

      CASE <ls_fielcat_emerg>-fieldname.
        WHEN 'NOMBRE' OR 'APELLIDO_PATERNO' OR 'APELLIDO_PATERNO' OR 'PARENTESCO' OR 'N_TELEFONO1'.
          <ls_fielcat_emerg>-hotspot = abap_true.
          <ls_fielcat_emerg>-no_out = abap_false.
        WHEN OTHERS.
          <ls_fielcat_emerg>-no_out = abap_true.
      ENDCASE.
    ENDLOOP.
   ENDIF.

  WHEN 'SKILLS'.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
     EXPORTING
       i_structure_name             = 'ZA23_HABILIDADES'
      CHANGING
        ct_fieldcat                  = gt_fieldcat_skill
     EXCEPTIONS
       inconsistent_interface       = 1
       program_error                = 2
       OTHERS                       = 3
              .
    IF sy-subrc EQ 0.
      LOOP AT gt_fieldcat_skill ASSIGNING FIELD-SYMBOL(<ls_fielcat_skill>).
        CASE <ls_fielcat_skill>-fieldname.
          WHEN 'ID_HABILIDAD' OR 'ID_EMPLEADO'.
            <ls_fielcat_skill>-no_out = abap_true.
          WHEN OTHERS.
            <ls_fielcat_skill>-no_out = abap_false.
            <ls_fielcat_skill>-hotspot = abap_true.
        ENDCASE.
      ENDLOOP.
    ENDIF.


ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

"  DATA: gT_ADD_FAM TYPE TABLE OF gty_EMP_FAMILY,
" LS_ADD_FAM TYPE gty_EMP_FAMILY.

  ls_family-id_familiar = 0.
  ls_family-id_empleado = 0.
  ls_family-nombre = 'CARLOS'.
  ls_family-apellido_paterno = 'GUZMAN'.

  APPEND ls_family TO gt_family.
  CLEAR ls_family.

  ls_family-id_familiar = 0.
  ls_family-id_empleado  = 0.
  ls_family-nombre = 'CARLOS'.
  ls_family-apellido_paterno = 'CG'.
*
  APPEND ls_family TO gt_family.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form instance_exe_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_exe_alv CHANGING parent_name TYPE c.

  CASE parent_name.
    WHEN 'FAMILY'.
      CREATE OBJECT go_alv_grid_emerg
        EXPORTING
          i_parent                = go_cust_cont_emerg                 " Parent Container
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

    WHEN 'SKILLS'.
      CREATE OBJECT go_alv_grid_skill
        EXPORTING
          i_parent                = go_cust_cont_skill                 " Parent Container
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
    WHEN OTHERS.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv CHANGING parent_name TYPE c.

  CASE parent_name.
    WHEN 'FAMILY'.
      go_alv_grid_emerg->set_table_for_first_display(
    CHANGING
      it_outtab                     = gt_family           " Output Table
      it_fieldcatalog               = gt_fieldcat_emerg                 " Field Catalog
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

    WHEN 'SKILLS'.
      go_alv_grid_skill->set_table_for_first_display(
        CHANGING
          it_outtab                     = gt_skill                 " Output Table
          it_fieldcatalog               = gt_fieldcat_skill                 " Field Catalog
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
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
"------ICON
*&---------------------------------------------------------------------*
*& Form notification_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM notification_name .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light1
   IMPORTING
     result                      = icon_1
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_data_pat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_data_pat .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light2
   IMPORTING
     result                      = icon_2
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_data_mat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_data_mat .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light3
   IMPORTING
     result                      = icon_3
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_data_dat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_data_dat .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light4
   IMPORTING
     result                      = icon_4
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_marial_status
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_marial_status .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light5
   IMPORTING
     result                      = icon_5
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_address
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_address .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light6
   IMPORTING
     result                      = icon_6
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_address2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_address2 .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light7
   IMPORTING
     result                      = icon_7
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_municipality
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_municipality .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light8
   IMPORTING
     result                      = icon_8
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_int_entry
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_int_entry .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light9
   IMPORTING
     result                      = icon_9
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_ext_entry
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_ext_entry .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light10
   IMPORTING
     result                      = icon_10
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form nofitication_state
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM nofitication_state .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light11
   IMPORTING
     result                      = icon_11
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form notification_postal_code
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM notification_postal_code .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light12
   IMPORTING
     result                      = icon_12
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form notification_phone
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM notification_phone .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light13
   IMPORTING
     result                      = icon_13
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form notification_phone2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM notification_phone2 .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light14
   IMPORTING
     result                      = icon_14
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form notification_email
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM notification_email .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light15
   IMPORTING
     result                      = icon_15
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form notification_curp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM notification_curp .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light16
   IMPORTING
     result                      = icon_16
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form notification_rfc
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM notification_rfc .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light17
   IMPORTING
     result                      = icon_17
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form notification_imss
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM notification_imss .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = warning_light18
   IMPORTING
     result                      = icon_18
   EXCEPTIONS
     icon_not_found              = 1
     outputfield_too_short       = 2
     OTHERS                      = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form temporary_data_family
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM temporary_data_family .

  DATA lv_val_regex TYPE abap_bool.
  PERFORM validate_data_regex USING lv_val_regex.

  IF lv_val_regex EQ abap_true.
   CASE gv_code.
     WHEN 'DES_DEL'.
       PERFORM normal_save_confirmation.
       IF gv_answ = '1'.
         PERFORM save_family_data_temporary_emp.
       ENDIF.
   	 WHEN 'ACT_DEL'.
       PERFORM update_message.
       IF gv_answ = '1'.
         PERFORM upd_family_data_temporary_emp.
       ENDIF.
     WHEN 'DES_DEL_FAM'.
       PERFORM confirmation_save.
       IF gv_answ = '1'.
         PERFORM add_new_family_member_employee.
       ENDIF.
     WHEN 'ACT_DEL_FAM'.
       PERFORM update_message.
       IF gv_answ = '1'.
         PERFORM upd_family_member_employee.
       ENDIF.
   	 WHEN OTHERS.
   ENDCASE.
  ELSE.
    MESSAGE s037(zemp_alfa02) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form validate_data_regex
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM validate_data_regex USING valid_regex.

  DATA(lv_name) = CONV string( ls_family-nombre ).
  DATA(lv_apellido_paterno) = CONV string( ls_family-apellido_paterno ).
  DATA(lv_apellido_materno) = CONV string( ls_family-apellido_materno ).
  DATA(lv_parentesco) = CONV string( ls_family-parentesco ).
  DATA(lv_calle) = CONV string( ls_family-calle ).
  DATA(lv_colonia) = CONV string( ls_family-colonia ).
  DATA(lv_municipio) = CONV string( ls_family-municipio ).
  DATA(lv_estado) = CONV string( ls_family-estado ).
  DATA(lv_n_telefono1) = CONV string( ls_family-n_telefono1 ).

   IF go_validate->regex_name( name = lv_name ) = abap_true
   AND go_validate->regex_name( name = lv_apellido_paterno ) = abap_true
   AND go_validate->regex_name( name = lv_apellido_materno ) = abap_true
   AND go_validate->regex_name( name = lv_parentesco ) = abap_true
   AND go_validate->regex_address( address = lv_calle ) = abap_true
   AND go_validate->regex_address( address = lv_colonia ) = abap_true
   AND ls_family-no_interior IS NOT INITIAL
   AND go_validate->regex_address( address = lv_municipio ) = abap_true
   AND go_validate->regex_name( name = lv_estado ) = abap_true
   AND go_validate->regex_phone( phone = lv_n_telefono1 ) = abap_true.

     valid_regex = abap_true.

   ENDIF.

   CLEAR: lv_name, lv_apellido_paterno, lv_apellido_materno, lv_parentesco, lv_calle, lv_colonia, lv_municipio,
         lv_municipio, lv_n_telefono1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_alv_fam
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv_fam.

    go_alv_grid_emerg->refresh_table_display(
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
*& Form set_list-box
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_list-box .

  gv_code = 'DES_JOB'.
  SELECT * FROM za23_areas INTO CORRESPONDING FIELDS OF TABLE gt_areas.
  SORT gt_areas BY nombre_area.

  LOOP AT gt_areas INTO gs_areas.
    gs_values-key = gs_areas-nombre_area.
    APPEND gs_values TO gt_values.
    CLEAR gs_areas.
  ENDLOOP.

  gv_id = 'GS_AREAS-NOMBRE_AREA'.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id                    = gv_id
      values                = gt_values
   EXCEPTIONS
     id_illegal_name       = 1
     OTHERS                = 2
            .
  CLEAR: gt_values[], gs_values.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form confirmation_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM confirmation_save .

DATA: lv_msg TYPE string.

MESSAGE e000(zemp_alfa02) INTO lv_msg.
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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form normal_save_confirmation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM normal_save_confirmation.

  DATA: lv_msg TYPE string.

  MESSAGE e001(zemp_alfa02) INTO lv_msg.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     titlebar                    = TEXT-002
      text_question               = lv_msg
     text_button_1               = TEXT-001
     icon_button_2               = 'No'
     display_cancel_button       = 'X'
   IMPORTING
     answer                      = gv_answ
   EXCEPTIONS
     text_not_found              = 1
     OTHERS                      = 2
     .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form normal_save_confirmation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM simple_delete_message.

  DATA: lv_msg TYPE string.

  MESSAGE e002(zemp_alfa02) INTO lv_msg.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     titlebar                    = TEXT-002
      text_question               = lv_msg
     text_button_1               = TEXT-001
     icon_button_2               = 'NO'
     display_cancel_button       = 'X'
   IMPORTING
     answer                      = gv_answ
   EXCEPTIONS
     text_not_found              = 1
     OTHERS                      = 2
     .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form normal_save_confirmation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_message.

  DATA: lv_msg TYPE string.

  MESSAGE e003(zemp_alfa02) INTO lv_msg.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     titlebar                    = TEXT-002
      text_question               = lv_msg
     text_button_1               = TEXT-001
     icon_button_2               = 'NO'
     display_cancel_button       = 'X'
   IMPORTING
     answer                      = gv_answ
   EXCEPTIONS
     text_not_found              = 1
     OTHERS                      = 2
     .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form normal_save_confirmation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM warning_message.

  DATA: lv_msg TYPE string.

  MESSAGE e004(zemp_alfa02) INTO lv_msg.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     titlebar                    = TEXT-003
      text_question               = lv_msg
     text_button_1               = TEXT-001
     icon_button_2               = 'NO'
     display_cancel_button       = 'X'
   IMPORTING
     answer                      = gv_answ
   EXCEPTIONS
     text_not_found              = 1
     OTHERS                      = 2
     .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form normal_save_confirmation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM termination_employment_message.

  DATA: lv_msg TYPE string.

  MESSAGE e006(zemp_alfa02) INTO lv_msg.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     titlebar                    = TEXT-003
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

ENDFORM.

FORM ACTIVE_EMPLOYEE.

  DATA: lv_msg TYPE string.

  MESSAGE e038(zemp_alfa02) INTO lv_msg.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     titlebar                    = TEXT-003
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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_handlers
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_handlers .

  CREATE OBJECT: go_events_receiver,
                 go_validate.

  SET HANDLER: go_events_receiver->handle_hotspot_click_fam FOR go_alv_grid_emerg,
               go_events_receiver->handle_hotspot_click_skill FOR go_alv_grid_skill,
               go_register_emp->on_transaction_reg_emp.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_data_family
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_data_family .

  CASE gv_code.
    WHEN 'ACT_DEL'.
      PERFORM delete_family_temp.
*      READ TABLE gt_family WITH KEY id_familiar = gv_value_row  INTO DATA(ls_entry).
*      IF sy-subrc = 0.
*        DELETE gt_family INDEX sy-tabix.
*        PERFORM refresh_alv_fam.
*        LEAVE TO SCREEN 0.
*      ENDIF.
    WHEN 'ACT_DEL_FAM'.

      PERFORM delete_fam_member_emp.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form insert_fam_member_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_fam_member_emp .

  DATA lcl_hr_delete_family TYPE REF TO zcl_hr_family_alfa02.
  CREATE OBJECT lcl_hr_delete_family.

  CALL METHOD lcl_hr_delete_family->delete_family_member
   EXPORTING
    id_family   = ls_family-id_familiar
    id_employee = gv_id_emp
   IMPORTING
    lt_family   = gt_family .

  PERFORM create_fieldcat USING 'FAMILY'.
  PERFORM refresh_alv_fam.
  IF lcl_hr_delete_family IS BOUND.
    CLEAR: lcl_hr_delete_family.
  ENDIF.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_record_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text go_validate->check_data_not_already_stored( ).IF gv_flag_emp NE abap_false.
*&---------------------------------------------------------------------*
FORM check_record_emp .

  IF gv_flag_emp EQ abap_true AND gt_family[] IS NOT INITIAL AND gt_skill[] IS NOT INITIAL.
    PERFORM generate_id_emp.
    IF gv_gent_id_emp EQ abap_true.
      za23_empleados-status = 'ACT'.
      za23_empleados-fecha_registro = sy-datum.
      za23_empleados-creado_usuario = sy-uname.
      za23_empleados-hora_registro = sy-uzeit.
      INSERT INTO za23_empleados VALUES za23_empleados.
      COMMIT WORK.
      MESSAGE i029(zemp_alfa02) WITH | ID: { za23_empleados-id_empleado } |.
      PERFORM release_resources_employee.
      LEAVE TO SCREEN 0.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form generate_id_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM generate_id_emp .

  gv_gent_id_emp = abap_true.
  DATA: lv_number_id_emp TYPE numc10.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr                   = '01'
      object                        = 'ZNI_EMP_A2'
   IMPORTING
     number                        = lv_number_id_emp
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
    gv_gent_id_emp = abap_false.
  ELSE.
    za23_empleados-id_empleado = lv_number_id_emp.
    gv_id_emp = lv_number_id_emp.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3002
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3002 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'SAVE'.
      PERFORM temporary_data_skill.
    WHEN 'DELT_SKI'.
      PERFORM simple_delete_message.
      IF gv_answ = '1'.
        PERFORM delete_data_skill.
      ENDIF.
    WHEN 'CANCEL' .
      CLEAR: ls_family.
      LEAVE TO SCREEN 0.
    WHEN 'BACK'.
      CLEAR: ls_family.
      LEAVE TO SCREEN 0.
    WHEN 'OPT1'.
      CLEAR: ls_family.
      LEAVE TO SCREEN 0.
   ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form temporary_data_skill
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM temporary_data_skill .

  IF gs_skill-nombre_hab_comp IS NOT INITIAL AND
     gs_skill-nivel_habilidad IS NOT INITIAL AND
     gs_skill-certificacion IS NOT INITIAL.

    CASE gv_code.
      WHEN 'DES_DEL'.
        PERFORM normal_save_confirmation.
        IF gv_answ = '1'.
          PERFORM save_temporary_skill_data.
        ENDIF.
      WHEN 'ACT_DEL'.
        PERFORM update_message.
        IF gv_answ = '1'.
          PERFORM upd_temporary_skill_data.
        ENDIF.
      WHEN 'DES_DEL_SKILL'.
        PERFORM confirmation_save.
        IF gv_answ = '1'.
          PERFORM add_new_skill_db.
        ENDIF.
      WHEN 'ACT_DEL_SKILL'.
        PERFORM update_message.
        IF gv_answ = '1'.
          PERFORM upd_new_skill_db.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_alv_skill
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv_skill .

  go_alv_grid_skill->refresh_table_display(
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
*& Form DELETE_dATA_SKILL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_data_skill .

  CASE gv_code.
    WHEN 'ACT_DEL'.
      READ TABLE gt_skill WITH KEY id_habilidad = gv_value_row  INTO DATA(ls_entry).
      IF sy-subrc = 0.
        DELETE gt_skill INDEX sy-tabix.
        PERFORM refresh_alv_skill.
        LEAVE TO SCREEN 0.
      ENDIF.
    WHEN 'ACT_DEL_SKILL'.
      DELETE FROM za23_habilidades WHERE id_habilidad = gs_skill-id_habilidad.
      IF sy-subrc EQ 0.
        CLEAR gt_skill.
        SELECT * FROM za23_habilidades INTO TABLE @gt_skill WHERE id_empleado EQ @gv_id_emp.
        PERFORM refresh_alv_skill.
        CLEAR gs_skill.
        LEAVE TO SCREEN 0.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3003
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3003 .

  ok_code = sy-ucomm.

  DATA(lv_id) = za23_empleados-id_empleado.

  CASE ok_code.
    WHEN 'COD_AREA_ASIG'.
      IF gv_code = 'ACT_JOB' OR gv_code = 'DES_JOB_SEARCH'.
        gv_code = 'DES_JOB'.
      ENDIF.
      PERFORM get_job_title.
      za23_empleados-nombre = box_employee_name.
*    WHEN 'SEARCH_JOB_TITLE'.
*      PERFORM set_job_title.
    WHEN 'SEARCH_EMP'.
      gv_code = 'ACT_JOB'.
      IF za23_asigemp-fecha_inicio IS INITIAL.
        PERFORM clear_screen_3003.
         za23_empleados-id_empleado = lv_id.
      ELSEIF za23_empleados-id_empleado IS NOT INITIAL AND za23_asigemp-fecha_inicio IS NOT INITIAL.
        PERFORM clear_screen_3003.
        za23_empleados-id_empleado = lv_id.
      ENDIF.
      PERFORM get_id_emp.
    WHEN 'SAVE'.
      PERFORM normal_save_confirmation.
      IF gv_answ EQ '1'.
        PERFORM record_work_assignment.
      ENDIF.
    WHEN 'BT_UPDATE'.
      PERFORM update_message.
      IF gv_answ EQ '1'.
        PERFORM update_work_assignment.
      ENDIF.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_job_title
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_job_title .

  SELECT SINGLE * FROM za23_areas INTO @DATA(lv_test)
    WHERE nombre_area = @gs_areas-nombre_area.

  SELECT * FROM za23_puestos INTO TABLE gt_puestos
    WHERE id_area = lv_test-id_area.

  LOOP AT gt_puestos  INTO gs_puestos.
    gs_values-key = gs_puestos-nombre_puesto.
    APPEND gs_values TO gt_values.
    CLEAR gs_values.
  ENDLOOP.

  SORT gt_values BY key.
  DELETE ADJACENT DUPLICATES FROM gt_values COMPARING key.

  gv_id = 'GS_PUESTOS-NOMBRE_PUESTO'.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id                    = gv_id
      values                = gt_values
   EXCEPTIONS
     id_illegal_name       = 1
     OTHERS                = 2.

  CLEAR: gs_values, gt_values[].

  DATA: lv_num TYPE c.

  IF gv_flag_emp EQ abap_true.
    lv_num = 0.
  ELSE.
    lv_num = 1.
  ENDIF.
  PERFORM disable_display_element USING lv_num.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form release_resources_employee
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM release_resources_employee .

  IF go_cust_cont_emerg IS BOUND.

  go_cust_cont_emerg->free(
    EXCEPTIONS
      cntl_error        = 1                " CNTL_ERROR
      cntl_system_error = 2                " CNTL_SYSTEM_ERROR
      OTHERS            = 3
  ).

  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CLEAR go_cust_cont_emerg.

  ENDIF.

  IF go_cust_cont_skill IS BOUND.

  go_cust_cont_skill->free(
    EXCEPTIONS
      cntl_error        = 1                " CNTL_ERROR
      cntl_system_error = 2                " CNTL_SYSTEM_ERROR
      OTHERS            = 3
  ).

  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CLEAR go_cust_cont_skill.

  ENDIF.

  CLEAR: za23_empleados, gv_flag_emp, gv_gent_id_emp, go_validate, gv_answ, gt_fieldcat_emerg, gt_fieldcat_skill, gv_code3004,
         gv_code, gt_family, gt_skill, gv_value_row, gv_count_fam, gv_count_skill, rb1_gn_male, rb2_gn_female,
         go_events_receiver, go_register_emp, go_generate_id, gv_init, icon_1, icon_2, icon_3, icon_4, icon_5,
         icon_6, icon_7, icon_8, icon_9, icon_10, icon_11, icon_12, icon_13, icon_14, icon_15, icon_16,
         icon_17, icon_18.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form record_work_assignment
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM record_work_assignment .

  DATA lv_valid_rec TYPE abap_bool.

  PERFORM validate_initial_data_rec USING lv_valid_rec.

  IF lv_valid_rec EQ ABAP_true.
      PERFORM number_get_za23_assig.
  ELSE.
    MESSAGE TEXT-004 TYPE 'W'.
    PERFORM confirmation_clear_data.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form call_add_place_job
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM call_add_place_job .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_id_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text" IF sy-subrc EQ 0 AND lt_zasig-id_puesto IS NOT INITIAL AND lt_zasig-fecha_fin EQ space OR lt_zasig-fecha_fin EQ '00000000' AND lt_zasig-fecha_inicio NE '00000000'.
*&---------------------------------------------------------------------*
FORM get_id_emp .

  CLEAR gv_flag_emp. gv_act_button = 'DES_UPD'.

  DATA: lv_num TYPE c,
        lcl_search_data_emp TYPE REF TO zcl_hr_data_emp_alfa02,
        ls_employee LIKE LINE OF zcl_hr_data_emp_alfa02=>gt_employee,
        lv_bool TYPE abap_bool.

  CREATE OBJECT lcl_search_data_emp.

  CALL METHOD lcl_search_data_emp->search_employee"EMPLOYEE INFORMATION SEARCH CLASS
    EXPORTING
      id_employee = za23_empleados-id_empleado
    IMPORTING
      ls_employee = ls_employee
      lv_bool     = lv_bool.

  IF lv_bool EQ abap_true.

    PERFORM get_job_information.

    za23_empleados-nombre = | { ls_employee-nombre } { ls_employee-apellido_paterno
    } { ls_employee-apellido_materno } |.
    box_employee_name = za23_empleados-nombre.

  ELSE.
    PERFORM clear_screen_3003.
    SET PF-STATUS 'STATUS_3003_1'.
    lv_num = 1.
    PERFORM disable_display_element USING lv_num.
    MESSAGE s024(zemp_alfa02) WITH TEXT-003 DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

"*  SELECT SINGLE nombre, apellido_paterno, apellido_materno FROM za23_empleados INTO @DATA(lt_zemp)
*    WHERE id_empleado EQ @za23_empleados-id_empleado AND status EQ 'ACT'.

*    za23_empleados-nombre = | { lt_zemp-nombre } { lt_zemp-apellido_paterno } { lt_zemp-apellido_materno } |.
*    box_employee_name = za23_empleados-nombre.

*&---------------------------------------------------------------------*
*& Form search_data_id
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM search_reg_data_assig CHANGING lv_num TYPE numc10.

  SELECT SINGLE * FROM za23_puestos INTO @DATA(lt_zpuesto)
    WHERE nombre_puesto = @gs_puestos-nombre_puesto.
  SELECT SINGLE * FROM za23_horarios INTO @DATA(lt_horarios)
    WHERE turno = @za23_horarios-turno.

  za23_asigemp-mandt = sy-mandt.
  za23_asigemp-id_asignacion = lv_num.
  za23_asigemp-id_empleado = lv_txt_id_emp.
  za23_asigemp-id_puesto = lt_zpuesto-id_puesto.
  za23_asigemp-id_horario = lt_horarios-id_horario.
  za23_asigemp-salario = za23_asigemp-salario.
  za23_asigemp-moneda = 'MXN'.
  za23_asigemp-status = 'ACT'.
  za23_asigemp-fecha_inicio = za23_asigemp-fecha_inicio.
  za23_asigemp-fecha_fin = space.

  INSERT za23_asigemp.
  IF sy-subrc EQ 0.
    COMMIT WORK.
    PERFORM clear_screen_3003.
    MESSAGE s029(zemp_alfa02).
    LEAVE TO SCREEN 0.
  ELSE.
    ROLLBACK WORK.
    MESSAGE s025(zemp_alfa02) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_assignment
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_ZASIG
*&---------------------------------------------------------------------*
FORM get_assignment CHANGING p_lt_zasig TYPE za23_asigemp.

  SELECT SINGLE * FROM za23_horarios INTO @DATA(lt_horarios) WHERE id_horario = @p_lt_zasig-id_horario.

  SELECT SINGLE a~*, b~* FROM ( za23_areas AS a INNER JOIN za23_puestos AS b ON a~id_area = b~id_area )
    WHERE b~id_puesto = @p_lt_zasig-id_puesto INTO @DATA(lt_area_puesto).

  za23_asigemp-fecha_inicio = p_lt_zasig-fecha_inicio.
  gs_areas-nombre_area = lt_area_puesto-a-nombre_area.
  gs_puestos-nombre_puesto = lt_area_puesto-b-nombre_puesto.
  za23_horarios-turno = lt_horarios-turno.

  DATA: lv_num TYPE c.
  lv_num = 0.
  PERFORM disable_display_element USING lv_num.

  SET PF-STATUS 'STATUS_3003_1'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form clear_screen_3003
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM clear_screen_3003 .

  CLEAR: za23_asigemp-fecha_inicio,
         za23_asigemp-fecha_fin,
         lv_txt_id_emp,
         box_employee_name,
         gs_areas-nombre_area,
         gs_puestos-nombre_puesto,
         za23_horarios-turno,
         za23_empleados-id_empleado,
         za23_empleados-nombre,
         gv_flag_emp,
         gv_id_emp,
         lv_boolact,
         za23_asigemp-salario,
         za23_empleados,
         gv_act_button,
         rbt_act,
         rbt_des.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3004
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3004 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'SAVE'.
      IF gv_rec_check EQ abap_true.
      PERFORM confirmation_save.
      IF gv_answ = '1'.
        PERFORM employee_data.
        IF gv_flag_emp EQ abap_true.
          PERFORM upd_emp_data.
        ENDIF.
        " agregar actualizacion
*       PERFORM check_record_emp.
      ENDIF.
    ELSE.
      MESSAGE s005(zemp_alfa02) WITH TEXT-003 DISPLAY LIKE 'W'.
    ENDIF.
    WHEN 'ADD_FAM_UPD'.
      CLEAR ls_family.
      gv_code = 'DES_DEL_FAM'.
      CALL SCREEN 3001 STARTING AT 10 05 ENDING AT 155 16.
    WHEN 'ADD_SKI_UPD'.
      CLEAR gs_skill.
      gv_code = 'DES_DEL_SKILL'.
      CALL SCREEN 3002 STARTING AT 10 05 ENDING AT 90 15.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form lock_obj_employee
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_EMPLOYEE_ID_EMPLEADO
*&---------------------------------------------------------------------*
FORM lock_obj_employee CHANGING ls_employee LIKE LINE OF zcl_hr_data_emp_alfa02=>gt_employee.

  CALL FUNCTION 'ENQUEUE_EZA23_EMPLEADOS' "add lock employee
   EXPORTING
      mode_za23_empleados       = 'E'
      mandt                     = sy-mandt
      id_empleado               = ls_employee-id_empleado
   EXCEPTIONS
      foreign_lock              = 1
      system_failure            = 2
   OTHERS                       = 3 .

   IF sy-subrc EQ 1. " WE ARE CHECKING IF THE USER IS BEING EDITED
     PERFORM read_lock_entries_emp CHANGING ls_employee. " READ CLOCK ENTRIES FROM LOCK TABLE
   ELSE.
     PERFORM emp_data_upload CHANGING ls_employee. " employee data upload in screen
   ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form read_lock_entries_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ls_employee
*&---------------------------------------------------------------------*
FORM read_lock_entries_emp  CHANGING ls_employee LIKE LINE OF zcl_hr_data_emp_alfa02=>gt_employee.

  CONCATENATE sy-mandt ls_employee-id_empleado INTO gv_msg.

  CALL FUNCTION 'ENQUEUE_READ'
   EXPORTING
    gclient                     = sy-mandt
    gname                       = 'ZA23_EMPLEADOS'
    garg                        = gv_garg
   TABLES
    enq                         = gt_seqg3
   EXCEPTIONS
    communication_failure       = 1
    system_failure              = 2
   OTHERS                       = 3.

  READ TABLE gt_seqg3 INDEX 1.
  CONCATENATE TEXT-016 gt_seqg3-guname INTO gv_msg SEPARATED BY space.

  MESSAGE gv_msg TYPE 'S'. "lock information message
  SET SCREEN 0. "starting screen

ENDFORM.
*&---------------------------------------------------------------------*
*& Form emp_data_upload
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_EMPLOYEE
*&---------------------------------------------------------------------*
FORM emp_data_upload  CHANGING ls_employee LIKE LINE OF zcl_hr_data_emp_alfa02=>gt_employee.

  gv_id_emp = ls_employee-id_empleado.
  gv_rec_check = abap_true.
  za23_empleados = ls_employee. "LOADING DATA ON THE SCREEN
  IF ls_employee-genero EQ 'M'.
    rb2_gn_female = abap_false.
    rb1_gn_male = abap_true.
  ELSE.
    rb1_gn_male = abap_false.
    rb2_gn_female = abap_true.
  ENDIF.

  CALL METHOD lcl_search_data_emp->search_data_emp
      EXPORTING
        id_employee = ls_employee-id_empleado
      IMPORTING
        gt_skill    = gt_skill
        gt_family   = gt_family .

  PERFORM refresh_alv_fam.
  PERFORM refresh_alv_skill.
  PERFORM activate_button_emp.
  CREATE OBJECT go_generate_id.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form activate_button_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM activate_button_emp .

   LOOP AT SCREEN.
     IF screen-name = 'ADD_FAMILY' OR  screen-name = 'ADD_SKILL' .
       screen-active = 1.
     ENDIF.
     MODIFY SCREEN.
   ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_handlers_edit
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_handlers_edit .
  CREATE OBJECT: go_events_receiver,
                 go_validate.

  SET HANDLER: go_events_receiver->handle_hotspot_click_fam_upd   FOR go_alv_grid_emerg,
               go_events_receiver->handle_hotspot_click_skill_upd FOR go_alv_grid_skill.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_family_data_temporary_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_family_data_temporary_emp .

  ADD 1 TO gv_count_fam.
  ls_family-mandt = sy-mandt.
  ls_family-id_familiar = gv_count_fam.
  ls_family-id_empleado = 0.
  APPEND ls_family TO gt_family.
  CLEAR ls_family.
  PERFORM refresh_alv_fam.
  LEAVE TO SCREEN 0.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form upd_family_data_temporary_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM upd_family_data_temporary_emp.

  READ TABLE gt_family WITH KEY id_familiar = gv_value_row  INTO DATA(ls_entry).
  IF sy-subrc = 0.
    MODIFY gt_family FROM ls_family INDEX sy-tabix.
    CLEAR ls_family.
    PERFORM refresh_alv_fam.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_new_family_member_employee
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_new_family_member_employee.


  DATA(lv_num_id) = go_generate_id->id_fam( ).
  DATA: lcl_hr_insert_fam TYPE REF TO zcl_hr_family_alfa02.
  CREATE OBJECT lcl_hr_insert_fam.

  ls_family-mandt = sy-mandt.
  ls_family-id_familiar = lv_num_id.
  ls_family-id_empleado = gv_id_emp.

  CALL METHOD lcl_hr_insert_fam->insert_family_member
    EXPORTING
      ls_family   = ls_family
    IMPORTING
      lt_family   = gt_family .

  CLEAR: ls_family.
  PERFORM refresh_alv_fam.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form upd_family_member_employee
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM upd_family_member_employee.

  DATA: lcl_upd_member_fam TYPE REF TO zcl_hr_family_alfa02.
  CREATE OBJECT lcl_upd_member_fam.

  CALL METHOD lcl_upd_member_fam->update_family_member
    EXPORTING
      id_empleado = gv_id_emp
      ls_family   = ls_family
    IMPORTING
      lt_family   = gt_family .

  PERFORM refresh_alv_fam.
  CLEAR ls_family.
  LEAVE TO SCREEN 0.

*  lt_temp_fam = ls_family.
*  UPDATE za23_familiares FROM lt_temp_fam.
*  CLEAR ls_family.
*  IF sy-subrc EQ 0.
*    CLEAR gt_family.
*    SELECT  * FROM za23_familiares INTO @DATA(lt_fam) WHERE id_empleado EQ @gv_id_emp.
*      ls_family = lt_fam.
*      APPEND ls_family TO gt_family.
*    ENDSELECT.
*  PERFORM refresh_alv_fam.
*  CLEAR ls_family.
*  LEAVE TO SCREEN 0.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_temporary_skill_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_temporary_skill_data .

  ADD 1 TO gv_count_skill.
  gs_skill-mandt = sy-mandt.
  gs_skill-id_empleado = 0.
  gs_skill-id_habilidad = gv_count_skill.
  CONDENSE gs_skill-nombre_hab_comp.
  CONDENSE gs_skill-certificacion.
  APPEND gs_skill TO gt_skill.
  CLEAR gs_skill.
  PERFORM refresh_alv_skill.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form upd_temporary_skill_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM upd_temporary_skill_data .

  READ TABLE gt_skill WITH KEY id_habilidad = gv_value_row INTO DATA(ls_entry).
  IF sy-subrc = 0.
    CONDENSE gs_skill-nombre_hab_comp.
    CONDENSE gs_skill-certificacion.
    MODIFY gt_skill FROM gs_skill INDEX sy-tabix.
    CLEAR gs_skill.
    PERFORM refresh_alv_skill.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_new_skill_db
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_new_skill_db .

  DATA(lv_num_id) = go_generate_id->id_skill( ).
  gs_skill-mandt = sy-mandt.
  gs_skill-id_habilidad = lv_num_id.
  gs_skill-id_empleado = gv_id_emp.
  CONDENSE gs_skill-nombre_hab_comp.
  CONDENSE gs_skill-certificacion.
  CLEAR gt_skill.
  APPEND gs_skill TO gt_skill.
  INSERT za23_habilidades FROM TABLE gt_skill.
  IF sy-subrc EQ 0.
    SELECT * FROM za23_habilidades INTO TABLE gt_skill WHERE id_empleado EQ gv_id_emp.
    PERFORM refresh_alv_skill.
    CLEAR: gs_skill.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form upd_new_skill_db
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM upd_new_skill_db .

  CONDENSE gs_skill-nombre_hab_comp.
  CONDENSE gs_skill-certificacion.
  UPDATE za23_habilidades FROM gs_skill.
  IF sy-subrc EQ 0.
    CLEAR gs_skill.
    SELECT * FROM za23_habilidades INTO TABLE gt_skill WHERE id_empleado EQ gv_id_emp.
    PERFORM refresh_alv_skill.
    CLEAR gs_skill.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3005
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3005 .

  ok_code = sy-ucomm.

   CHECK ok_code IS NOT INITIAL.

  CASE ok_code.
    WHEN 'ADE'.

      gv_code = 'SRCH_FOR_ALL_DATA'.
      CLEAR: gs_employee.

      IF go_custom_cont_ade IS BOUND.
        PERFORM clear_container_ade.
      ENDIF.

      PERFORM area_department_employee.
      MODIFY SCREEN.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form show_reports_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_reports_emp .

  PERFORM area_department_employee.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form area_department_employee
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text " *  PERFORM create_alv_ade.
*  PERFORM create_fieldcat_ade.
*&---------------------------------------------------------------------*
FORM area_department_employee .

  IF go_salv_tree IS NOT BOUND.

    PERFORM create_container_ade.
    PERFORM create_inst_salv_tree.
    PERFORM build_salv_tree_header.
    PERFORM get_salv_data.
    PERFORM salv_tree_data_modeling.
    PERFORM configure_salv_tree_columns.

  ENDIF.

  PERFORM display_salv_tree.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_container_ade
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_container_ade .

  CHECK go_custom_cont_ade IS NOT BOUND.

  CREATE OBJECT go_custom_cont_ade
    EXPORTING
      container_name              = 'ALV_SHOW_EMP'                 " Name of the Screen CustCtrl Name to Link Container To
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
*& Form create_inst_salv_tree
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_inst_salv_tree .

  TRY.
  cl_salv_tree=>factory(
    EXPORTING
      r_container = go_custom_cont_ade                 " Abstract Container for GUI Controls
    IMPORTING
      r_salv_tree = go_salv_tree                 " ALV: Tree Model
    CHANGING
      t_table     = gt_ade_temp_tree
  ).
  CATCH cx_salv_error. " ALV: General Error Class (Checked in Syntax Check)
    MESSAGE S035(zemp_alfa02) DISPLAY LIKE 'E'.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_salv_tree
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_salv_tree .

  go_salv_tree->display( ).

      cl_gui_cfw=>flush(
    EXCEPTIONS
      cntl_system_error = 1                " cntl_system_error
      cntl_error        = 2                " cntl_error
      OTHERS            = 3
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_salv_tree_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_salv_tree_header .

  DATA: lv_langu_header   TYPE salv_de_tree_text,
        lv_langu_tooltip  TYPE salv_de_tree_text.

  " SPANISH LENGUAJE OR ENGLISH LANGUAGE
    lv_langu_header  = 'AREA'.
    lv_langu_tooltip = 'DEPLOY THE NODES'.


  DATA lo_settings TYPE REF TO cl_salv_tree_settings. " CREATION OBJECT
  lo_settings = go_salv_tree->get_tree_settings( ).  " SAVE VALUE THE INSTANCE
  lo_settings->set_hierarchy_header( value = lv_langu_header ).
  lo_settings->set_hierarchy_tooltip( value = lv_langu_tooltip ).
  lo_settings->set_hierarchy_size( value = 50 ). " set size

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_salv_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_salv_data .

 DATA: lv_tab_name  TYPE string.

 lv_tab_name = 'ZHRV_EMP_ALFA02'.

  CASE gv_code.
    WHEN 'SRCH_FOR_ALL_DATA'.

      SELECT * FROM (lv_tab_name) INTO CORRESPONDING FIELDS OF TABLE @gt_ade_tree.

    WHEN 'SRCH_FOR_DATA'.

      PERFORM container_reconfg.

      SELECT * FROM (lv_tab_name) INTO CORRESPONDING FIELDS OF TABLE @gt_ade_tree
        where (gv_tab_where).

      PERFORM display_tree.

    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*  CASE gv_code.
*    WHEN 'SRCH_FOR_ALL_DATA'.
*
*      SELECT area~nombre_area, job_title~nombre_puesto, employee~id_empleado,
*         employee~nombre, employee~apellido_paterno, employee~apellido_materno,
*         employee~calle, employee~colonia, employee~municipio, employee~estado,
*         employee~no_interior, employee~n_telefono1, employee~correo_elec
*        FROM za23_empleados AS employee
*          INNER JOIN za23_asigemp AS assignment
*                  ON employee~id_empleado EQ assignment~id_empleado
*          INNER JOIN za23_puestos AS job_title
*                  ON assignment~id_puesto EQ job_title~id_puesto
*          INNER JOIN za23_areas AS area
*                  ON job_title~id_area EQ area~id_area
*        WHERE employee~status EQ 'ACT'
*        ORDER BY area~nombre_area
*        INTO CORRESPONDING FIELDS OF TABLE @gt_ade_tree BYPASSING BUFFER  .
*
*        PERFORM clear_data_dats.
*
*
*    WHEN 'SRCH_FOR_DATA'.
**
*      PERFORM clear_container_ade.
*      PERFORM create_container_ade.
*      PERFORM create_inst_salv_tree.
*      PERFORM build_salv_tree_header.
*
*      SELECT area~nombre_area, job_title~nombre_puesto, employee~id_empleado,
*         employee~nombre, employee~apellido_paterno, employee~apellido_materno,
*         employee~calle, employee~colonia, employee~municipio, employee~estado,
*         employee~no_interior, employee~n_telefono1, employee~correo_elec
*        FROM za23_empleados AS employee
*          INNER JOIN za23_asigemp AS assignment
*                  ON employee~id_empleado EQ assignment~id_empleado
*          INNER JOIN za23_puestos AS job_title
*                  ON assignment~id_puesto EQ job_title~id_puesto
*          INNER JOIN za23_areas AS area
*                  ON job_title~id_area EQ area~id_area
*        WHERE employee~status EQ 'ACT' AND
*                    employee~id_empleado EQ  @gs_employee-id_empleado
*        ORDER BY area~nombre_area, job_title~nombre_puesto, assignment~id_horario DESCENDING
*        INTO CORRESPONDING FIELDS OF TABLE @gt_ade_tree BYPASSING BUFFER.
*
*      PERFORM clear_data_dats.
*      PERFORM salv_tree_data_modeling.
*      PERFORM configure_salv_tree_columns.
*      PERFORM display_salv_tree.
*
*        MODIFY SCREEN.
*
*    WHEN OTHERS.
*  ENDCASE.
*&---------------------------------------------------------------------*
*& Form salv_tree_data_modeling
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM salv_tree_data_modeling .

  DATA: lo_nodes         TYPE REF TO cl_salv_nodes, " all nodes
        lo_node          TYPE REF TO cl_salv_node,   "just one node

        lv_text          TYPE lvc_value,
        lv_key_area      TYPE salv_de_node_key,
        lv_key_job_title TYPE salv_de_node_key.

  lo_nodes = go_salv_tree->get_nodes( ).

  SORT gt_ade_tree BY nombre_area nombre_puesto.

  LOOP AT gt_ade_tree ASSIGNING FIELD-SYMBOL(<ls_ade_tree>).

    ON CHANGE OF <ls_ade_tree>-nombre_area. " new area, we add it to the node
      lv_text = <ls_ade_tree>-nombre_area. " we pass the name of the area
      TRY.
      lo_node = lo_nodes->add_node( " new node parent
        EXPORTING
          related_node   = space                 " Key to Related Node
          relationship   = if_salv_c_node_relation=>parent "Node Relation in Tree
          text           = lv_text                 " ALV Control: Cell Content
          expander       = abap_true                 " Boolean Variable (X=True, Space=False)
          folder         = abap_true                  " Boolean Variable (X=True, Space=False)
      ).

      lv_key_area = lo_node->get_key( ). " get the key of the parent node

      CATCH cx_salv_msg. " ALV: General Error Class with Message
      ENDTRY.
    ENDON.

    ON CHANGE OF <ls_ade_tree>-nombre_puesto. "changing the value of jobs
      lv_text = <ls_ade_tree>-nombre_puesto.
      TRY.
      lo_node = lo_nodes->add_node( "new nodel child
          EXPORTING
            related_node   =  lv_key_area                " Key to Related Node
            relationship   = if_salv_c_node_relation=>last_child "Node Relation in Tree
            text           = lv_text                 " ALV Control: Cell Content
            expander       = abap_true                " Boolean Variable (X=True, Space=False)
            folder         = abap_true                 " Boolean Variable (X=True, Space=False)
        ).

      lv_key_job_title = lo_node->get_key( ). " get the key

      CATCH cx_salv_msg. " ALV: General Error Class with Message
      ENDTRY.
    ENDON.

    lv_text = <ls_ade_tree>-id_empleado.

    TRY.
    lo_node = lo_nodes->add_node(
      EXPORTING
        related_node   = lv_key_job_title "lv_key_job_title                " Key to Related Node
        relationship   = if_salv_c_node_relation=>last_child "Node Relation in Tree
        text           = lv_text                " ALV Control: Cell Content
    ).
    lo_node->set_data_row( value = <ls_ade_tree> ).
    CATCH cx_salv_msg. " ALV: General Error Class with Message
    ENDTRY.

  ENDLOOP.

  lo_nodes->expand_all( ). " expand all nodes

ENDFORM.
*&---------------------------------------------------------------------*
*& Form configure_salv_tree_columns
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM configure_salv_tree_columns .

  DATA: lo_columns TYPE REF TO cl_salv_columns_tree,
        lo_column  TYPE REF TO cl_salv_column.

  lo_columns = go_salv_tree->get_columns( ).
  lo_columns->set_optimize( abap_true ).
  TRY.
  lo_column = lo_columns->get_column( columnname = 'NOMBRE_AREA' ).
  lo_column->set_visible( abap_false ).
  lo_column = lo_columns->get_column( columnname = 'NOMBRE_PUESTO' ).
  lo_column->set_visible( abap_false ).
  lo_column = lo_columns->get_column( columnname = 'ID_EMPLEADO' ).
  lo_column->set_visible( abap_false ).
  CATCH cx_salv_not_found.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form clear_container_ade
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM clear_container_ade .

  IF go_custom_cont_ade IS BOUND.

  go_custom_cont_ade->free(
    EXCEPTIONS
      cntl_error        = 1                " CNTL_ERROR
      cntl_system_error = 2                " CNTL_SYSTEM_ERROR
      OTHERS            = 3
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  ENDIF.

  CLEAR: go_custom_cont_ade.

*  clear:  go_custom_cont_ade, go_salv_tree, gt_ade_temp_tree, gt_ade_tree, go_alv_grid_ade.
   IF go_salv_tree IS BOUND.
     CLEAR go_salv_tree.
   ENDIF.

   CLEAR:gt_ade_temp_tree, gt_ade_tree,gt_ade_temp_tree[], gt_ade_tree[].

    cl_gui_cfw=>flush(
    EXCEPTIONS
      cntl_system_error = 1                " cntl_system_error
      cntl_error        = 2                " cntl_error
      OTHERS            = 3
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CLEAR: gt_ade_temp_tree.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_alv_ade
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_alv_ade .

  CREATE OBJECT go_alv_grid_ade
    EXPORTING
      i_parent                = go_custom_cont_ade                 " Parent Container
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
*& Form refresh_alv_ade
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv_ade .

  go_alv_grid_ade->refresh_table_display(
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
*& Form create_fieldcat_ade
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_fieldcat_ade .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
   EXPORTING
     i_structure_name             = 'ZHR_DE_AR_EMP_TREE_ALFA02'
    CHANGING
      ct_fieldcat                  = gt_fieldcat_emerg
   EXCEPTIONS
     inconsistent_interface       = 1
     program_error                = 2
     OTHERS                       = 3.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3006
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3006 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'SAVE'.
      PERFORM termination_employment_message.
      IF gv_answ EQ '1' AND gv_flag_emp EQ abap_true.
        PERFORM termination_employment.
      ENDIF.
    WHEN 'ACTIVEEMPLOYEE'.
      CALL SCREEN 3010 STARTING AT 10 05 ENDING AT 70 12.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form change_history
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_history .
*  DATA lt_ass TYPE ZA23_ASIGEMP.
*  DATA lt_assig TYPE ZA23_ASIGEMP.
*
*  SELECT SINGLE id_asignacion, id_empleado, id_puesto FROM ZA23_ASIGEMP BYPASSING BUFFER INTO @lt_assig
*    WHERE id_empleado EQ @lv_txt_id_emp .
*
*  gv_objecttid = lt_assig.
*  CONDENSE gv_objecttid.
*
*  CALL FUNCTION 'ZA23_ASIGEMP_WRITE_DOCUMENT'
*    EXPORTING
*      objectid                         = gv_objecttid
*      tcode                            = sy-tcode
*      utime                            = sy-uzeit
*      udate                            = sy-datum
*      username                         = sy-uname
*     object_change_indicator          = 'U'
*     n_ZA23_ASIGEMP                = ZA23_ASIGEMP
*     o_ZA23_ASIGEMP                = lt_assig
*     upd_ZA23_ASIGEMP              = 'U'
*    TABLES
*      icdtxt_ZA23_ASIGEMP           = gt_cdtxt.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form termination_employment
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM termination_employment .

  IF za23_bajas_emp-descripcion IS NOT INITIAL AND za23_empleados-fecha_baja IS NOT INITIAL.

    za23_empleados = za23_empleados-fecha_baja.
    UPDATE za23_empleados SET fecha_baja = @sy-datum,  status = 'DES'
      WHERE id_empleado = @za23_bajas_emp-id_empleado.

    za23_bajas_emp-id_empleado = za23_bajas_emp-id_empleado.
    za23_bajas_emp-mandt = sy-mandt.
    za23_bajas_emp-usuario = sy-uname.
    INSERT za23_bajas_emp.

    SELECT  single * FROM za23_asigemp INTO @DATA(lt_assig)
      WHERE id_empleado = @za23_bajas_emp-id_empleado.

    DATA(lv_value) = lt_assig-fecha_fin.
      IF lv_value IS NOT INITIAL.
        UPDATE za23_asigemp SET fecha_fin = @za23_empleados-fecha_baja, status = 'DES'
          WHERE id_empleado = @za23_bajas_emp-id_empleado.
        IF sy-subrc EQ 0.
          COMMIT WORK.
          MESSAGE w022(zemp_alfa02).
        ENDIF.
      ENDIF.

    CLEAR: za23_bajas_emp, box_employee_name, za23_empleados-fecha_baja.
    LEAVE TO SCREEN 0.
  ELSE.
    MESSAGE i023(zemp_alfa02).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form upd_emp_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM upd_emp_data .

* go_validate->check_data_not_already_stored( ).
*
* IF gv_flag_emp EQ abap_true.

   MODIFY za23_empleados CLIENT SPECIFIED FROM za23_empleados.

   IF sy-subrc EQ 0.
*     COMMIT WORK.
     MESSAGE w022(zemp_alfa02).
   ELSE.
     MESSAGE w020(zemp_alfa02).
   ENDIF.

   PERFORM release_resources_employee.
   LEAVE TO SCREEN 0.

* ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CLEAR_DATA_DATS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM clear_data_dats .

  DATA lt_sel TYPE zhr_de_ar_emp_tree_alfa02.
  DATA lt_sel2 TYPE TABLE OF zhr_de_ar_emp_tree_alfa02.

  SELECT * FROM za23_asigemp INTO TABLE @DATA(asasdasda).

  LOOP AT gt_ade_tree ASSIGNING FIELD-SYMBOL(<asasasdasd>).

    SELECT * FROM za23_asigemp INTO @DATA(sas) WHERE id_empleado EQ @<asasasdasd>-id_empleado.
    IF sy-subrc EQ 0.
      DATA fecha TYPE string.
      fecha = sas-fecha_fin.
      IF fecha IS INITIAL OR fecha EQ '00000000'.
        lt_sel = <asasasdasd>.
        APPEND lt_sel TO lt_sel2.
        CLEAR lt_sel.
      ENDIF.

    ENDIF.

    ENDSELECT.

  ENDLOOP.

  SORT lt_sel2 BY id_empleado.
  DELETE ADJACENT DUPLICATES FROM lt_sel2 COMPARING id_empleado.

  gt_ade_tree =  lt_sel2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3007
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3007 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'EXECUTE'.
      IF za23_empleados-id_empleado IS NOT INITIAL AND gv_date IS NOT INITIAL.
        CLEAR: za23_empleados-id_empleado, gv_date, gv_date[].
        "AGREGAR MENSAJE DE QUE SE PUEDE HACER SOLAMENTE UNA BUSQUEDA DE UN CAMPO
      ELSE.
        PERFORM get_asig_emp_history_reports.
      ENDIF.

    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form screen_asig_his
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_asig_emp_history_reports .

  DATA: lt_asig_where TYPE TABLE OF string.

  PERFORM create_where_sel TABLES lt_asig_where.

  IF go_history_reports_container IS BOUND.
    PERFORM free_emp_hist_rep.
  ENDIF.

  IF go_history_reports_container IS NOT BOUND.
    PERFORM get_report_data TABLES lt_asig_where.
    PERFORM instance_his_rep_container.
    PERFORM instance_his_rep_fieldcat.
    PERFORM instance_his_rep_alv.
    PERFORM display_his_rep_alv.
  ELSE.
    PERFORM get_report_data TABLES lt_asig_where.
    PERFORM refresh_his_rep_alv.
  ENDIF.

ENDFORM.

*  PERFORM intance_report_container_emp_his.

*  data: go_alv_ida type ref to if_salv_gui_table_ida,
*        go_ida_fullscreen type ref to if_salv_gui_fullscreen_ida.
*
*  data: go_alv_display type ref to if_salv_gui_table_ida,
*        go_custon_cont type ref to cl_gui_custom_container.
*
*  go_custon_cont = new #( 'ALV_EMP_REG' ).
*
*  SELECT * FROM ZA23_EMPLEADOS INTO TABLE @DATA(gt_field) WHERE status EQ 'ACT'.
*
*  go_alv_ida = cl_salv_gui_table_ida=>create(
*                 iv_table_name         = gt_field "'ZA23_EMPLEADOS'
*                 io_gui_container      = go_custon_cont
**                 io_calc_field_handler =
*               ).
*               CATCH cx_salv_db_connection.          " Error connecting to database
*               CATCH cx_salv_db_table_not_supported. " DB table / view is not supported
*               CATCH cx_salv_ida_contract_violation. " IDA API contract violated by caller

*  go_ida_fullscreen = go_alv_ida->fullscreen( ).
*                      CATCH cx_salv_ida_contract_violation. " IDA API contract violated by caller
*
*  go_ida_fullscreen->display( ).


*&---------------------------------------------------------------------*
*& Form check_date_length
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_where_sel TABLES t_asig_where TYPE STANDARD TABLE.

  DATA: lt_hrcond TYPE STANDARD TABLE OF hrcond,
        ls_cond TYPE hrcond,
        lv_tabname TYPE dfies-tabname.

  IF gv_date IS NOT INITIAL .
    ls_cond-field = 'FECHA_INICIO'.
    ls_cond-opera = gv_date-option.
    ls_cond-low   = gv_date-low.
    ls_cond-high  = gv_date-high.
    APPEND ls_cond TO lt_hrcond.
  ENDIF.

  CLEAR ls_cond.

  IF za23_empleados-id_empleado IS NOT INITIAL .
    ls_cond-field = 'ID_EMPLEADO'.
    ls_cond-opera = 'EQ'.
    ls_cond-low   = za23_empleados-id_empleado.
    APPEND ls_cond TO lt_hrcond.
  ENDIF.

  CLEAR: za23_empleados-id_empleado, gv_date.

  IF lt_hrcond IS NOT INITIAL.

    CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
      EXPORTING
        dbtable               = 'ZA23_ASIGEMP'
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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form free_emp_hist_rep
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_emp_hist_rep .

  IF go_history_reports_container IS BOUND.
    go_history_reports_container->free(
      EXCEPTIONS
        cntl_error        = 1                " CNTL_ERROR
        cntl_system_error = 2                " CNTL_SYSTEM_ERROR
        OTHERS            = 3
    ).
    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

  CLEAR gt_fieldcat_his_rep.
*
  CLEAR: gv_date,za23_empleados-id_empleado, gv_date, gv_date[], go_history_reports_container.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_report_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_WHERE
*&---------------------------------------------------------------------*
FORM get_report_data  TABLES t_asig_where TYPE STANDARD TABLE.

  DATA: lv_tab_name  TYPE string.
  FIELD-SYMBOLS: <lt_history_reports> TYPE ANY TABLE.
  lv_tab_name = 'ZHRV_SE_ALFA02'.
  ASSIGN gt_rep_his TO <lt_history_reports>.

  SELECT * FROM (lv_tab_name)
      INTO TABLE <lt_history_reports> WHERE (t_asig_where).

  SORT gt_rep_his BY fecha_registro ASCENDING.

ENDFORM.
" FALTA LIMPIAR AL REFRESCAR Y BUSCAR CUANDO NO TENGA NADA DE DATOS Y QUE SOLO ACEPTE UN VALOR
*&---------------------------------------------------------------------*
*& Form instance_his_rep_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_his_rep_container .

  CREATE OBJECT go_history_reports_container
    EXPORTING
      container_name              = 'ALV_EMP_REG'                 " Name of the Screen CustCtrl Name to Link Container To
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
*& Form instance_his_Rep_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_his_rep_fieldcat .

CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
 EXPORTING
   i_structure_name             = 'ZHRV_SE_ALFA02' "'ZHR_EMP_JOB_AT_AREA_SCH'ZHRV_SE_ALFA02
  CHANGING
    ct_fieldcat                  = gt_fieldcat_his_rep
 EXCEPTIONS
   inconsistent_interface       = 1
   program_error                = 2
   OTHERS                       = 3
          .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form instance_his_rep_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_his_rep_alv .

  CREATE OBJECT go_alv_grid_his_rep
    EXPORTING
      i_parent                = go_history_reports_container                 " Parent Container
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
*& Form display_his_rep_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_his_rep_alv .

  go_alv_grid_his_rep->set_table_for_first_display(
    CHANGING
      it_outtab                     = gt_rep_his                 " Output Table
      it_fieldcatalog               = gt_fieldcat_his_rep                  " Field Catalog
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
*& Form refresh_his_rep_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_his_rep_alv .

  go_alv_grid_his_rep->refresh_table_display(
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
*& Form update_work_assignment
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_work_assignment .

  SELECT SINGLE * FROM za23_puestos INTO @DATA(lt_zpost) WHERE nombre_puesto = @gs_puestos-nombre_puesto .
  SELECT SINGLE * FROM za23_horarios INTO @DATA(lt_zsch) WHERE turno = @za23_horarios-turno.

  data lv_ad type char3.
  IF rbt_des EQ abap_true.
    lv_ad = 'DES'.
  ELSE.
    lv_ad = 'ACT'.
  ENDIF.

  UPDATE za23_asigemp SET fecha_inicio = @za23_asigemp-fecha_inicio,
          id_puesto = @lt_zpost-id_puesto, id_horario = @lt_zsch-id_horario, salario = @za23_asigemp-salario,
          moneda = 'MXN', fecha_fin = @za23_asigemp-fecha_fin,
          status = @lv_ad  WHERE id_empleado EQ @za23_empleados-id_empleado.

  IF sy-subrc EQ 0.
    COMMIT WORK.
    MESSAGE TEXT-005 TYPE 'S'.
    PERFORM clear_screen_3003.
    LEAVE TO SCREEN 0.
  ELSE.
    PERFORM confirmation_clear_data.
    MESSAGE TEXT-006 TYPE 'W'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form NUMBER_GET_ZA23_ASSIG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM number_get_za23_assig .

  DATA lv_num TYPE numc10.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr                   = '01'
      object                        = 'ZNI_PST_A2'
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
     OTHERS                        = 8.

    IF sy-subrc EQ 0.
      PERFORM search_reg_data_assig USING lv_num.
    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form VALIDATE_INITIAL_DATA_REC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_VALID_REC
*&---------------------------------------------------------------------*
FORM validate_initial_data_rec  USING    p_lv_valid_rec.

    IF lv_txt_id_emp IS NOT INITIAL AND
    gs_puestos-nombre_puesto IS NOT INITIAL AND
    za23_horarios-turno IS NOT INITIAL AND
    za23_asigemp-fecha_inicio IS NOT INITIAL AND
*    za23_asigemp-fecha_fin IS INITIAL AND
    za23_asigemp-salario IS NOT INITIAL AND
    za23_asigemp-salario > 0.

      p_lv_valid_rec = abap_true.

    ELSE.
      MESSAGE TEXT-004 TYPE 'W'.
    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form confirmation_clear_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM confirmation_clear_data .

  DATA: lv_msg TYPE string,
        lv_num.

  MESSAGE e010(zemp_alfa02) INTO lv_msg.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     titlebar                    = TEXT-002
      text_question               = lv_msg
     text_button_1               = TEXT-001
     text_button_2               = 'NO'
     display_cancel_button       = 'X'
   IMPORTING
     answer                      = gv_answ
   EXCEPTIONS
     text_not_found              = 1
     OTHERS                      = 2
            .
    CLEAR lv_msg.

    IF lv_num EQ '1'.
      PERFORM clear_screen_3003.
    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form confirmation_exit_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM confirmation_exit_screen .

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
     titlebar                    = TEXT-002
      text_question               = TEXT-008
     text_button_1               = TEXT-001
     text_button_2               = 'NO'
     display_cancel_button       = 'X'
   IMPORTING
     answer                      = gv_answ
   EXCEPTIONS
     text_not_found              = 1
     OTHERS                      = 2
            .

  IF gv_answ EQ '1'.
    PERFORM clear_screen_3003.
    LEAVE TO SCREEN 0.
  ELSE.
    PERFORM clear_screen_3003.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form clear_screen_3006
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM clear_screen_3006 .

  CLEAR: za23_bajas_emp, box_employee_name,box_name_area,box_name_area,
         za23_bajas_emp-id_empleado,za23_empleados-fecha_baja,
         box_position_name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form release_user_lock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM release_user_lock.

  CALL FUNCTION 'DEQUEUE_EZA23_EMPLEADOS'
   EXPORTING
    mode_za23_empleados       = 'E'
    mandt                     = sy-mandt
    id_empleado               = za23_empleados-id_empleado .


ENDFORM.
*&---------------------------------------------------------------------*
*& Form disable_display_element
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM disable_display_element CHANGING lv_num TYPE c.

  LOOP AT SCREEN.
    IF screen-name EQ 'BT_UPD'.
      screen-invisible = lv_num.
      MODIFY SCREEN.
      EXIT.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3010
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3010 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'BT_ACT'.
      PERFORM ACTIVE_EMPLOYEE.
      IF gv_answ EQ '1'.
        UPDATE za23_empleados SET status = 'ACT' WHERE id_empleado EQ za23_empleados-id_empleado.
        CLEAR: za23_empleados.
      ENDIF.
      LEAVE TO SCREEN 0.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.

FORM act_emp .

  UPDATE za23_empleados SET status = 'ACT'
    WHERE id_empleado EQ za23_empleados-id_empleado.
  IF sy-subrc eq 0.
    MESSAGE S020(zemp_alfa02).
    COMMIT WORK.
  ELSE.
    MESSAGE w025(zemp_alfa02).
    ROLLBACK WORK.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_family_temp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_family_temp .

  READ TABLE gt_family WITH KEY id_familiar = gv_value_row  INTO DATA(ls_entry).
  IF sy-subrc = 0.
    DELETE gt_family INDEX sy-tabix.
    PERFORM refresh_alv_fam.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_job_information
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_ZEMP
*&---------------------------------------------------------------------*
FORM get_job_information.

  lv_txt_id_emp = za23_empleados-id_empleado.
  SELECT SINGLE * FROM za23_asigemp INTO @DATA(lt_zasig) WHERE status = 'ACT' AND id_empleado = @lv_txt_id_emp.

  IF sy-subrc EQ 0 AND lt_zasig-id_puesto IS NOT INITIAL.                                                          "AND lt_zasig-fecha_fin EQ space OR lt_zasig-fecha_fin EQ '00000000' AND lt_zasig-fecha_inicio NE '00000000'.
    gv_assig_id = lt_zasig-id_asignacion.
    za23_asigemp-salario = lt_zasig-salario.
    PERFORM get_assignment USING lt_zasig.
    IF lt_zasig-status EQ 'ACT'.
      rbt_act = abap_true.
    ENDIF.
      gv_flag_emp = abap_true.
    ELSE.
      SET PF-STATUS 'STATUS_3003'.
      lv_num = 1.
      PERFORM disable_display_element USING lv_num.
    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_from_view
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_ASIG_WHERE
*&---------------------------------------------------------------------*
FORM get_data_from_view  TABLES p_gt_asig_where TYPE STANDARD TABLE.

  FIELD-SYMBOLS: <lt_any> TYPE ANY TABLE.
  DATA: lv_tab_name  TYPE string,
        lv_where type string.

  data: ls_zhrv TYPE table of zhrv_s_e_alfa02.

  CASE gv_tabstrip-activetab.
    WHEN 'JOBAREA'.
      lv_tab_name = 'ZHRV_S_E_ALFA02'.
      lv_where = 'id_empleado = @gs_employee-id_emplead'.
      ASSIGN ls_zhrv TO <lt_any>.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.


    select * from (lv_tab_name) into TABLE <lt_any> where (lv_where).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_tree
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_tree .

  clear: gv_tab_where, cond.

  PERFORM clear_data_dats.
  PERFORM salv_tree_data_modeling.
  PERFORM configure_salv_tree_columns.
  PERFORM display_salv_tree.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form container_reconfg
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM container_reconfg .

  PERFORM clear_container_ade.
  PERFORM create_container_ade.
  PERFORM create_inst_salv_tree.
  PERFORM build_salv_tree_header.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_data_vac_perm
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_data_vac_perm.

  UPDATE za23_vac_perm SET fecha_inicio = @za23_vac_perm-fecha_inicio,
          fecha_fin = @za23_vac_perm-fecha_fin,
          dias_vacaciones = @za23_vac_perm-dias_vacaciones,
          periodo = @za23_vac_perm-periodo
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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form initial_job_pos
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM initial_job_pos .
  clear: lv_txt_id_emp, za23_empleados.
  PERFORM clear_screen_3003.
  lv_boolact = abap_true.
  gv_code = 'ACT_JOB'.
ENDFORM.
