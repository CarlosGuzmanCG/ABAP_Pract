*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_F03
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_3200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*        SELECT SINGLE area~id_area FROM za23_puestos AS w_position
*          INNER JOIN za23_areas AS area ON w_position~id_area EQ area~id_area
*            WHERE area~nombre_area EQ @za23_areas-nombre_area INTO @DATA(lv_id_position).
*
*        SELECT SINGLE horario~id_horario FROM za23_horarios AS horario
*          WHERE turno EQ @za23_horarios-turno INTO @DATA(lv_schedule).
*
*        SELECT emp~id_empleado, record_payroll~fecha_inicio_pago, record_payroll~fecha_pago, record_payroll~fecha_fin_pago
*            FROM za23_empleados AS emp
*          INNER JOIN za23_asigemp AS assigemp ON
*            assigemp~id_empleado EQ emp~id_empleado
*          INNER JOIN za23_puestos AS w_position ON
*            w_position~id_puesto EQ assigemp~id_puesto
*          INNER JOIN za23_reg_nominas AS record_payroll ON
*            emp~id_empleado EQ record_payroll~id_empleado
*           WHERE assigemp~status EQ 'ACT' AND w_position~id_area EQ @lv_id_position AND
*            assigemp~id_horario EQ @lv_schedule
*            AND record_payroll~fecha_inicio_pago >= @gv_date-low
*            ORDER BY assigemp~id_empleado ASCENDING
*            INTO @DATA(lv_validate_date).
*
*          IF lv_validate_date-fecha_pago GE gv_date-low AND lv_validate_date-fecha_pago LE gv_date-high.
*            flag_range_date = abap_true.
*          ENDIF.
*
*       ENDSELECT.
FORM init_3200 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'EXECUTE'.

      PERFORM check_payment.

*      IF gv_date-high IS NOT INITIAL AND gv_date-low IS NOT INITIAL.
*
*        DATA flag_range_date TYPE abap_bool.
*
*        perform check_payment_record_exists using flag_range_date.
*
*        IF flag_range_date NE abap_true.
*
*          PERFORM get_data_payroll.
*
*          IF go_catalog_container IS NOT BOUND.
*            PERFORM create_cat_cont_payroll.
*            PERFORM create_cat_fiel_payroll.
*            PERFORM create_cat_alv_payroll.
*            PERFORM conf_catalog_layout_payroll CHANGING gs_layout.
*            PERFORM set_event_payroll.
*            PERFORM register_events_payroll.
*            PERFORM exclude_catalog_functions.
*            PERFORM display_cat_alv_payroll.
*          ELSE.
*            PERFORM refresh_container.
*          ENDIF.
*
*       ELSE.
*         MESSAGE S015(ZEMP_ALFA02) DISPLAY LIKE 'E'.
*         PERFORM free_cont_payroll.
*       ENDIF.
*     ELSE.
*       MESSAGE S017(ZEMP_ALFA02) DISPLAY LIKE 'E'.
*       CLEAR: gv_date[].
*     ENDIF.

  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_payroll .

  DATA: date_range TYPE RANGE OF sydatum WITH HEADER LINE.

  CLEAR:gt_payroll.

  date_range-sign = 'I'.
  date_range-option = 'BT'.
  date_range-low = gv_date-low.
  date_range-high = gv_date-high.
  APPEND date_range.

  SELECT SINGLE area~id_area FROM za23_puestos AS puesto
    INNER JOIN za23_areas AS area ON puesto~id_area EQ area~id_area
      WHERE area~nombre_area EQ @za23_areas-nombre_area INTO @DATA(lv_id_puesto).

  SELECT SINGLE horario~id_horario FROM za23_horarios AS horario
    WHERE turno EQ @za23_horarios-turno INTO @DATA(lv_horario).

  WAIT UP TO 3 SECONDS.

  SELECT emp~id_empleado ,emp~nombre, emp~apellido_paterno, emp~apellido_materno, asigemp~salario
    FROM za23_empleados AS emp
    INNER JOIN za23_asigemp AS asigemp ON
      asigemp~id_empleado EQ emp~id_empleado
    INNER JOIN za23_puestos AS puesto ON
      puesto~id_puesto EQ asigemp~id_puesto
    INTO CORRESPONDING FIELDS OF @gs_payroll
      WHERE asigemp~status EQ 'ACT' AND puesto~id_area EQ @lv_id_puesto AND asigemp~id_horario EQ @lv_horario
    ORDER BY asigemp~id_empleado DESCENDING.

  SELECT COUNT( fecha ) FROM za23_asistencias WHERE id_empleado = @gs_payroll-id_empleado AND
    tipo_asistencia EQ 'PRESENTE' AND fecha IN @date_range INTO @DATA(ls_asistencia).

    IF sy-subrc EQ 0.
      gs_payroll-dias = ls_asistencia.
      gs_payroll-subtotal = gs_payroll-salario * gs_payroll-dias.
      gs_payroll-moneda = 'MXM'.
      gs_payroll-moneda_subtotal = 'MXM'.
      gs_payroll-moneda_bono = 'MXM'.
      gs_payroll-total_pago = gs_payroll-salario * gs_payroll-dias + gs_payroll-bono_apoyo.
      gs_payroll-moneda_pago = 'MXM'.

      APPEND gs_payroll TO gt_payroll.
      CLEAR gs_payroll.
    ENDIF.

  ENDSELECT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_cat_cont_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_cat_cont_payroll .

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
*& Form create_cat_fiel_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_cat_fiel_payroll .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
   EXPORTING
     i_structure_name             =  'ZHR_EMP_REGNOM'
   CHANGING
      ct_fieldcat                  = gt_catalog_fieldcat
   EXCEPTIONS
     inconsistent_interface       = 1
     program_error                = 2
     OTHERS                       = 3
            .

  LOOP AT gt_catalog_fieldcat ASSIGNING FIELD-SYMBOL(<ls_field_pay>).
    CASE <ls_field_pay>-fieldname.
      WHEN 'BONO_APOYO'.
        <ls_field_pay>-edit = abap_true.
      WHEN ''.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_cat_alv_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_cat_alv_payroll .

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
*& Form conf_catalog_layout_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYOUT
*&---------------------------------------------------------------------*
FORM conf_catalog_layout_payroll  CHANGING p_gs_layout TYPE lvc_s_layo.

  DATA: ls_style TYPE lvc_s_styl,
        lv_id TYPE string.

  p_gs_layout-zebra = abap_true.  " DEFINE AND CONFIGURE THE LAYOUT
  p_gs_layout-cwidth_opt = abap_true. " OPTIMIZE THE INFORMATION OF THE CONTENT
  p_gs_layout-cwidth_opt = abap_true. " NEW PROPERTY COLUMN OPTIMIZATION

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_cat_alv_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_cat_alv_payroll .

  FIELD-SYMBOLS <lt_dataa> TYPE ANY TABLE.

  ASSIGN gt_payroll TO <lt_dataa>.


  go_catalog_alv->set_table_for_first_display(
    EXPORTING
      i_save                        = 'U'
      is_layout                     = gs_layout                 " Layout
      it_toolbar_excluding          = gt_excluding                 " Excluded Toolbar Standard Functions
    CHANGING
      it_outtab                     =  <lt_dataa>                " Output Table
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
*& Form set_list_area-box
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_list_area-box .

  DATA ls_tra TYPE za23_areas.
  SELECT * FROM za23_areas INTO TABLE @DATA(lt_area).

  LOOP AT lt_area INTO ls_tra.
    gs_values-key = ls_tra-nombre_area.
    APPEND gs_values TO gt_values.
    CLEAR gs_values.
  ENDLOOP.

  SORT gt_values BY key.
  DELETE ADJACENT DUPLICATES FROM gt_values COMPARING key.
  gv_id = 'ZA23_AREAS-NOMBRE_AREA'.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id                    = gv_id
      values                = gt_values
   EXCEPTIONS
     id_illegal_name       = 1
     OTHERS                = 2.

  CLEAR: gt_values[], gs_values.

  gv_code = 'DES_LIST'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form free_cont_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_cont_payroll .

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

  CLEAR: gt_payroll, gv_date[], gv_date, za23_areas, za23_horarios,gt_catalog_fieldcat,gv_id,
         go_events_receiver,gt_excluding, za23_reg_nominas-forma_pago.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_event_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_event_payroll .

  IF go_events_receiver IS NOT BOUND .
    CREATE OBJECT go_events_receiver.
    SET HANDLER: go_events_receiver->handle_toolbar_payroll FOR go_catalog_alv,
                 go_events_receiver->handle_data_changed_payroll FOR go_catalog_alv,    "validate data
                 go_events_receiver->handle_data_chan_fish_payroll FOR go_catalog_alv, "operations
                 go_events_receiver->handle_user_command_payroll FOR go_catalog_alv.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form register_events_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_events_payroll .
  " event enter
 CALL METHOD go_catalog_alv->register_edit_event
   EXPORTING
     i_event_id = cl_gui_alv_grid=>mc_evt_enter   " Event ID
   EXCEPTIONS
     error      = 1                " Error
     OTHERS     = 2 .

 IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
 ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form exclude_cat_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM exclude_cat_payroll .



ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3201
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3201 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'EXECUTE'.

      IF gv_date-high IS NOT INITIAL AND gv_date-low IS NOT INITIAL .

      DATA: lt_asig_where TYPE TABLE OF string,
            lt_asig_where2 TYPE TABLE OF string.

      PERFORM create_where_payroll TABLES lt_asig_where lt_asig_where2.

      PERFORM get_data_pay_rec_his TABLES lt_asig_where lt_asig_where2.

      IF go_catalog_container IS NOT BOUND.
        PERFORM create_cat_cont_payroll.
        PERFORM create_cat_fiel_h_payroll.
        PERFORM create_cat_alv_payroll.
        PERFORM display_cat_alv_h_payroll.
      ELSE.
        PERFORM refresh_container.
      ENDIF.

      ELSE.
        "mensaje de que debe agregar los datos
      ENDIF.

    WHEN 'DOWNLOADREPORT'.

      IF gt_zhrv IS NOT INITIAL AND gv_date-high IS NOT INITIAL AND gv_date-low IS NOT INITIAL.
        PERFORM generate_pdf.
      ELSE.
        MESSAGE s013(zemp_alfa02) DISPLAY LIKE 'W'.
      ENDIF.

    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_pay_rec_his
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_pay_rec_his TABLES t_asig_where  TYPE STANDARD TABLE
                                 t_asig_where2 TYPE STANDARD TABLE.

  FIELD-SYMBOLS: <lt_history_reports> TYPE ANY TABLE.
  lv_tab_name = 'ZHRV_P_E_ALFA02'.

  SELECT * FROM (lv_tab_name)
      WHERE nombre_area EQ @za23_areas-nombre_area
    AND turno EQ @za23_horarios-turno
    AND (t_asig_where) AND (t_asig_where2)
      ORDER BY id_asignacion DESCENDING
    INTO TABLE @gt_zhrv .

  SORT gt_zhrv BY fecha_fin_pago ASCENDING.

  IF gt_zhrv IS NOT INITIAL.

  LOOP AT gt_zhrv ASSIGNING FIELD-SYMBOL(<lt_fields>).
    CASE <lt_fields>-turno.
      WHEN '01'.
        <lt_fields>-turno = TEXT-011 .
      WHEN '02'.
        <lt_fields>-turno = TEXT-012.
      WHEN '03'.
        <lt_fields>-turno = TEXT-013.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_where_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_ASIG_WHERE
*&---------------------------------------------------------------------*
FORM create_where_payroll TABLES t_asig_where  TYPE STANDARD TABLE
                                 t_asig_where2 TYPE STANDARD TABLE.

  DATA: lt_hrcond TYPE TABLE OF hrcond,
        ls_cond TYPE hrcond,
        lt_hrcond2 TYPE TABLE OF hrcond,
        ls_cond2 TYPE hrcond.

  IF gv_date-low IS NOT INITIAL.
    ls_cond-field = 'FECHA_INICIO_PAGO'.
    ls_cond-opera = gv_date-option.
    ls_cond-low   = gv_date-low.
    ls_cond-high  = gv_date-high.
    APPEND ls_cond TO lt_hrcond.
  ENDIF.

  CLEAR ls_cond.

  IF  gv_date-high IS NOT INITIAL.
    ls_cond2-field = 'FECHA_FIN_PAGO'.
    ls_cond2-opera = gv_date-option.
    ls_cond2-low   = gv_date-low.
    ls_cond2-high  = gv_date-high.
    APPEND ls_cond2 TO lt_hrcond2.
  ENDIF.

  CLEAR ls_cond.

  IF lt_hrcond IS NOT INITIAL.

    CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
      EXPORTING
        dbtable               = 'ZA23_REG_NOMINAS'
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

  IF lt_hrcond2 IS NOT INITIAL.
    CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
      EXPORTING
        dbtable               = 'ZA23_REG_NOMINAS'
      TABLES
        condtab               = lt_hrcond2
        where_clause          = t_asig_where2
     EXCEPTIONS
       empty_condtab         = 1
       no_db_field           = 2
       unknown_db            = 3
       wrong_condition       = 4
       OTHERS                = 5 .
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_cat_fiel_h_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_cat_fiel_h_payroll .

CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
 EXPORTING
   i_structure_name             = 'ZHRV_P_E_ALFA02'
  CHANGING
    ct_fieldcat                  = gt_catalog_fieldcat
 EXCEPTIONS
   inconsistent_interface       = 1
   program_error                = 2
   OTHERS                       = 3 .

  LOOP AT gt_catalog_fieldcat ASSIGNING FIELD-SYMBOL(<lf_symbol>).
    CASE <lf_symbol>-fieldname.
      WHEN 'ID_ASIGNACION' OR 'ID_PUESTO' OR 'ID_AREA' OR 'ID_HORARIO' OR 'ID_PAG_NOMINA'.
        <lf_symbol>-no_out = abap_true.
      WHEN ''.
      WHEN OTHERS.
        gt_fieldcat-fieldname = <lf_symbol>-fieldname.
        gt_fieldcat-tabname = 'GT_ZHRV'.
        gt_fieldcat-seltext_l = <lf_symbol>-fieldname.
        APPEND gt_fieldcat.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_cat_alv_h_payroll
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_cat_alv_h_payroll .


  go_catalog_alv->set_table_for_first_display(
    CHANGING
      it_outtab                     = gt_zhrv                 " Output Table
      it_fieldcatalog               = gt_catalog_fieldcat
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
*& Form free_container_pay_rec_his
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_container_pay_rec_his .

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

  CLEAR: gt_zhrv, gt_catalog_fieldcat, za23_areas-nombre_area, za23_horarios-turno, gv_date[].


ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_3203
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_3203 .

  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'SAVEPDF'.
      PERFORM generate_pdf.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form generate_pdf
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM generate_pdf .

  PERFORM generate_alv_pdf.
  PERFORM convert_pdf.
  PERFORM download_pdf.
  PERFORM get_file USING gv_file.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form generate_alv_pdf
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM generate_alv_pdf .

  DATA: ls_layout TYPE slis_layout_alv.
  DATA: lv_print TYPE slis_print_alv.

  lv_print-print                  = 'X'.
  lv_print-no_print_listinfos     = 'X'. " display no listinfos
  lv_print-no_change_print_params = 'X'.

  sy-batch = 'X'.

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
   EXPORTING
     is_layout                      = ls_layout
     it_fieldcat                    = gt_fieldcat[]
     is_print                       = lv_print
    TABLES
      t_outtab                       = gt_zhrv
   EXCEPTIONS
     program_error                  = 1
     OTHERS                         = 2
            .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form convert_pdf
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM convert_pdf .

* Spool to PDF conversions
  DATA: gd_bytecount LIKE tst01-dsize.

  DATA: x_rqid LIKE tsp01-rqident.

** Obtengo la orden de Spool ultima generada
  PERFORM get_numero_spool USING sy-repid
                                   sy-uname
                          CHANGING x_rqid.

  CALL FUNCTION 'CONVERT_ABAPSPOOLJOB_2_PDF'
    EXPORTING
      src_spoolid                    = x_rqid
     no_dialog                      = space
   IMPORTING
     pdf_bytecount                  = gd_bytecount
   TABLES
     pdf                            = gt_objaux
   EXCEPTIONS
     err_no_abap_spooljob           = 1
     err_no_spooljob                = 2
     err_no_permission              = 3
     err_conv_not_possible          = 4
     err_bad_destdevice             = 5
     user_cancelled                 = 6
     err_spoolerror                 = 7
     err_temseerror                 = 8
     err_btcjob_open_failed         = 9
     err_btcjob_submit_failed       = 10
     err_btcjob_close_failed        = 11
     OTHERS                         = 12
            .
  IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form download_pdf
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM download_pdf .

DATA: lines TYPE STANDARD TABLE OF hlpext WITH HEADER LINE.

  DATA: lv_ruta(100) TYPE c,
        lv_extension(3) TYPE c.

  LOOP AT gt_objaux.
    lines-line+00(002) = gt_objaux-tdformat.
    lines-line+02(132) = gt_objaux-tdline.
    APPEND lines.
  ENDLOOP.

  SPLIT gv_file AT '.' INTO lv_ruta lv_extension.

  gv_file = 'C:\Users\Public\Downloads'.

  CONCATENATE lv_ruta '_' sy-datum '_' sy-uzeit '.' lv_extension INTO gv_file.

  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename                  = gv_file                     " Name of file
      filetype                  = 'BIN'                " File type (ASCII, binary ...)
    CHANGING
      data_tab                  =  lines[]                    " Transfer table
    EXCEPTIONS
      file_write_error          = 1                    " Cannot write to file
      no_batch                  = 2                    " Cannot execute front-end function in background
      gui_refuse_filetransfer   = 3                    " Incorrect Front End
      invalid_type              = 4                    " Invalid value for parameter FILETYPE
      no_authority              = 5                    " No Download Authorization
      unknown_error             = 6                    " Unknown error
      header_not_allowed        = 7                    " Invalid header
      separator_not_allowed     = 8                    " Invalid separator
      filesize_not_allowed      = 9                    " Invalid file size
      header_too_long           = 10                   " Header information currently restricted to 1023 bytes
      dp_error_create           = 11                   " Cannot create DataProvider
      dp_error_send             = 12                   " Error Sending Data with DataProvider
      dp_error_write            = 13                   " Error Writing Data with DataProvider
      unknown_dp_error          = 14                   " Error when calling data provider
      access_denied             = 15                   " Access to file denied.
      dp_out_of_memory          = 16                   " Not enough memory in data provider
      disk_full                 = 17                   " Storage medium is full.
      dp_timeout                = 18                   " Data provider timeout
      file_not_found            = 19                   " Could not find file
      dataprovider_exception    = 20                   " General Exception Error in DataProvider
      control_flush_error       = 21                   " Error in Control Framework
      not_supported_by_gui      = 22                   " GUI does not support this
      error_no_gui              = 23                   " GUI not available
      OTHERS                    = 24
    .
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_numero_spool
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SY_REPID
*&      --> SY_UNAME
*&      <-- X_RQID
*&---------------------------------------------------------------------*
FORM get_numero_spool USING f_repid f_uname CHANGING f_rqident.

  DATA: it_tsp01 LIKE tsp01 OCCURS 0 WITH HEADER LINE,
        ls_tsp01 TYPE tsp01.

  WAIT UP TO 1 SECONDS.

    SELECT rqident
     INTO CORRESPONDING FIELDS OF TABLE it_tsp01
     FROM tsp01
     WHERE rqowner  EQ sy-uname
       AND rqclient EQ sy-mandt.

   SORT it_tsp01 DESCENDING BY rqident.

   READ TABLE it_tsp01 INTO ls_tsp01 INDEX 1.

   f_rqident = ls_tsp01-rqident.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_file
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_FILE
*&---------------------------------------------------------------------*
FORM get_file  USING p_gv_file.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      window_title              = CONV string( TEXT-010 )                  " Window Title
      default_extension         = 'pdf'                 " Default Extension
      default_file_name         = 'archive.pdf'                 " Default File Name
      file_filter               = cl_gui_frontend_services=>filetype_all                 " File Type Filter Table
      initial_directory         = 'C:\Users\Public\Downloads'                 " Initial Directory
    CHANGING
      filename                  = p_gv_file                 " File Name to Save
      path                      = path                 " Path to File
      fullpath                  = fullpath                 " Path + File Name
    EXCEPTIONS
      cntl_error                = 1                " Control error
      error_no_gui              = 2                " No GUI available
      not_supported_by_gui      = 3                " GUI does not support this
      invalid_default_file_name = 4                " Invalid default file name
      OTHERS                    = 5
    .
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_payment_record_exists
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> FLAG_RANGE_DATE
*&---------------------------------------------------------------------*
FORM check_payment_record_exists  CHANGING flag_range_date.

  SELECT SINGLE area~id_area FROM za23_puestos AS w_position
    INNER JOIN za23_areas AS area
    ON w_position~id_area EQ area~id_area
     WHERE area~nombre_area EQ @za23_areas-nombre_area
    INTO @DATA(lv_id_position).

  SELECT SINGLE horario~id_horario FROM za23_horarios AS horario
    WHERE turno EQ @za23_horarios-turno INTO @DATA(lv_schedule)
    BYPASSING BUFFER.

  SELECT emp~id_empleado, record_payroll~fecha_inicio_pago,
          record_payroll~fecha_pago, record_payroll~fecha_fin_pago
    FROM za23_empleados AS emp
   INNER JOIN za23_asigemp AS assigemp ON
    assigemp~id_empleado EQ emp~id_empleado
   INNER JOIN za23_puestos AS w_position ON
    w_position~id_puesto EQ assigemp~id_puesto
   INNER JOIN za23_reg_nominas AS record_payroll ON
    emp~id_empleado EQ record_payroll~id_empleado
    WHERE assigemp~status EQ 'ACT' AND w_position~id_area
      EQ @lv_id_position AND
   assigemp~id_horario EQ @lv_schedule
   AND record_payroll~fecha_inicio_pago >= @gv_date-low
    ORDER BY assigemp~id_empleado ASCENDING
   INTO @DATA(lv_validate_date).

   IF lv_validate_date-fecha_pago GE gv_date-low AND
      lv_validate_date-fecha_pago LE gv_date-high.

     flag_range_date = abap_true.

   ENDIF.

  ENDSELECT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_payment
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_payment .

  IF gv_date-high IS NOT INITIAL AND gv_date-low IS NOT INITIAL.

    DATA flag_range_date TYPE abap_bool.

    PERFORM check_payment_record_exists USING flag_range_date.

    IF flag_range_date NE abap_true.

      PERFORM get_data_payroll.

      IF go_catalog_container IS NOT BOUND.
        PERFORM create_cat_cont_payroll.
        PERFORM create_cat_fiel_payroll.
        PERFORM create_cat_alv_payroll.
        PERFORM conf_catalog_layout_payroll CHANGING gs_layout.
        PERFORM set_event_payroll.
        PERFORM register_events_payroll.
        PERFORM exclude_catalog_functions.
        PERFORM display_cat_alv_payroll.
      ELSE.
        PERFORM refresh_container.
      ENDIF.

    ELSE.
      MESSAGE s015(zemp_alfa02) DISPLAY LIKE 'E'.
      PERFORM free_cont_payroll.
    ENDIF.
  ELSE.
    MESSAGE s017(zemp_alfa02) DISPLAY LIKE 'E'.
    CLEAR: gv_date[].
  ENDIF.

ENDFORM.
