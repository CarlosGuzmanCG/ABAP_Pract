*&---------------------------------------------------------------------*
*& Include          Z_CONCESIONARIO_AUT_ALFA02_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_2000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_2000 .

  CHECK ok_code IS NOT INITIAL. " don't execute logic is value ok_code is not initial

  " code modulation
  CASE ok_code.
    " Code automation for the process to avoid generating overhead
    WHEN 'BTN_SALE'.

       IF gv_first_time EQ abap_false.
         gv_first_time = abap_true.
      ENDIF.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      PERFORM automov_on_sale. "subroutime

    WHEN 'BTN_RENT'.

      IF gv_first_time EQ abap_false.
         gv_first_time = abap_true.
      ENDIF.


      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      PERFORM automov_on_rent.

    when 'VEHCLN'.

      IF gv_first_time EQ abap_false.
         gv_first_time = abap_true.
      ENDIF.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      perform vehi_cln_hier.

   WHEN 'MMC'.

      IF gv_first_time EQ abap_false.
         gv_first_time = abap_true.
      ENDIF.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.
      PERFORM marca_modelo_cliente.

    WHEN 'G_MMC'.

       IF gv_first_time EQ abap_false.
         gv_first_time = abap_true.
      ENDIF.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      PERFORM gui_marca_modelo_clientes.


    WHEN 'UNDO'. " button to hide the data container

      IF gv_first_time EQ abap_false.
         gv_first_time = abap_true.
      ENDIF.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      PERFORM free_container. " release of resources

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form crete_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_container USING pv_tipo_op. "pv_tipo_op the type default chart

  " div container  -->header
  DATA lo_gui_splitter_cont TYPE REF TO cl_gui_splitter_container.

  " Instance of object of tha class TOP video 3.3
  CREATE OBJECT go_custom_container
    EXPORTING
      container_name              = 'ALV_CONT'   "Name the contaier [x]                 " Name of the Screen CustCtrl Name to Link Container To
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

  IF pv_tipo_op EQ 'V'.
" creation de instance
    CREATE OBJECT lo_gui_splitter_cont
    EXPORTING
*      link_dynnr              =                    " Screen Number
*      link_repid              =                    " Report Name
*      shellstyle              =                    " Window Style
*      left                    =                    " Left-aligned
*      top                     =                    " Top
*      width                   =                    " NPlWidth
*      height                  =                    " Hght
*      metric                  = cntl_metric_dynpro " Metric
*      align                   = 15                 " Alignment
      parent                  =  go_custom_container                  " Parent Container
      rows                    =  2                  " Number of Rows to be displayed
      columns                 =  1                  " Number of Columns to be Displayed
*      no_autodef_progid_dynnr =                    " Don't Autodefined Progid and Dynnr?
*      name                    =                    " Name
    EXCEPTIONS
      cntl_error              = 1                  " See Superclass
      cntl_system_error       = 2                  " See Superclass
      OTHERS                  = 3
    .
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  lo_gui_splitter_cont->get_container(
    EXPORTING
      row       =  1                " Row
      column    =  1                " Column
    RECEIVING
      container = go_gui_cont_header                 " Container
  ).

  lo_gui_splitter_cont->set_row_height(
    EXPORTING
      id                =  1                " Row ID
      height            =  20                " Height
*    IMPORTING
*      result            =                  " Result Code
    EXCEPTIONS
      cntl_error        = 1                " See CL_GUI_CONTROL
      cntl_system_error = 2                " See CL_GUI_CONTROL
      OTHERS            = 3
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  lo_gui_splitter_cont->get_container(
    EXPORTING
      row       =  2                " Row
      column    =  1                " Column
    RECEIVING
      container =  go_gui_container_body                " Container
  ).

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
" this method gets the data from the table database
FORM create_fieldcat .

  FIELD-SYMBOLS <ls_fieldcat> TYPE lvc_s_fcat.

"field catolog video 3.5
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
   EXPORTING
*     I_BUFFER_ACTIVE              =
     i_structure_name             =  'ZCO_VEHICULOS' " structura the table to show
*     I_CLIENT_NEVER_DISPLAY       = 'X'
*     I_BYPASSING_BUFFER           =
*     I_INTERNAL_TABNAME           =
    CHANGING
      ct_fieldcat                  =  gt_fieldcat " table internal with the structure in the TOP
   EXCEPTIONS
     inconsistent_interface       = 1
     program_error                = 2
     OTHERS                       = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE 'Fieldcat error' TYPE 'E'. " it is recommended to use a message class

  ELSE.
    "search  active in 'MARCA'
    LOOP AT gt_fieldcat ASSIGNING <ls_fieldcat>.

      CASE <ls_fieldcat>-fieldname.

        WHEN 'MARCA'.

          <ls_fieldcat>-f4availabl = abap_true.

        WHEN 'MATRICULA'.

          <ls_fieldcat>-hotspot = abap_true. " enable hand in of column 'MATRICULA' OF TABLE

        WHEN 'PRECIO'.

          <ls_fieldcat>-do_sum = abap_true.

      ENDCASE.

    ENDLOOP.

  ENDIF.


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

  CASE ok_code. " variable of TOP

    WHEN 'BTN_SALE'. "or 'BTN_RENT'. " code of asociation funtion the button of the screen

      SELECT * FROM zco_vehiculos
        INTO CORRESPONDING FIELDS OF TABLE gt_vehiculos
        WHERE flg_compra EQ abap_false AND flg_alquiler EQ abap_false.  " vehicles available

*    WHEN 'BTN_RENT'.
*
*       SELECT * FROM zco_vehiculos
*        INTO CORRESPONDING FIELDS OF TABLE gt_vehiculos
*        WHERE flg_alquiler EQ abap_false.
    WHEN 'BTN_RENT'.

      SELECT * FROM zco_vehiculos
        INTO CORRESPONDING FIELDS OF TABLE gt_veh_alq
        WHERE flg_compra EQ abap_false AND flg_alquiler EQ abap_false.  " vehicles available

    when 'VEHCLN'.

      PERFORM get_data_veh_clnt.

    WHEN OTHERS.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_alv .

  CREATE OBJECT go_alv_grid
    EXPORTING
*      i_shellstyle            = 0                " Control Style
*      i_lifetime              =                  " Lifetime
      i_parent                =  go_gui_container_body "go_custom_container "parameter exportin screen ->create_container  " Parent Container
*      i_appl_events           = space            " Register Events as Application Events
*      i_parentdbg             =                  " Internal, Do not Use
*      i_applogparent          =                  " Container for Application Log
*      i_graphicsparent        =                  " Container for Graphics
*      i_name                  =                  " Name
*      i_fcat_complete         = space            " Boolean Variable (X=True, Space=False)
*      o_previous_sral_handler =
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
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .

  "sort order upward
  DATA: lt_sort TYPE lvc_t_sort,
        ls_sort TYPE lvc_s_sort.

  DATA: lt_filter TYPE lvc_t_filt,
        ls_filter TYPE lvc_S_filt.

*
  ls_sort-fieldname = 'MARCA'.
*  ls_sort-UP        = abap_true. " upward
  ls_sort-down      = abap_true. " falling
  ls_sort-subtot    = abap_true.
    APPEND ls_sort TO lt_sort.

*  ls_sort-fieldname = 'MODELO'.
*  ls_sort-UP        = abap_true.
*    APPEND ls_sort to lt_sort.

    "equals set_filter_criteria
    ls_filter-fieldname = 'POTENCIA'.
    ls_filter-sign      = 'I'.
    ls_filter-option    = 'GT'.
    ls_filter-low       = '150'.
    APPEND ls_filter TO lt_filter.


  go_alv_grid->set_table_for_first_display(
    EXPORTING
*      i_buffer_active               =                  " Buffering Active
*      i_bypassing_buffer            =                  " Switch Off Buffer
*      i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*      i_structure_name              =                  " Internal Output Table Structure Name
      is_variant                    =  gs_variants                " Layout
      i_save                        =  'U'                " Save Layout
*      i_default                     = 'X'              " Default Display Variant
      is_layout                     =   gs_layout               " Layout
*      is_print                      =                  " Print Control
*      it_special_groups             =                  " Field Groups
      it_toolbar_excluding          =    gt_toolbar_excluding              " Excluded Toolbar Standard Functions
*      it_hyperlink                  =                  " Hyperlinks
*      it_alv_graphics               =                  " Table of Structure DTC_S_TC
*      it_except_qinfo               =                  " Table for Exception Quickinfo
*      ir_salv_adapter               =                  " Interface ALV Adapter
    CHANGING
      it_outtab                     =    gt_vehiculos              " Output Table
      it_fieldcatalog               =    gt_fieldcat              " Field Catalog
      it_sort                       =    lt_sort        " Sort Criteria
*      it_filter                     =    lt_filter              " Filter Criteria
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
*& Form refresh_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv .

  go_alv_grid->refresh_table_display( " method for actualy the dynpro
*    EXPORTING
*      is_stable      =                  " With Stable Rows/Columns
*      i_soft_refresh =                  " Without Sort, Filter, etc.
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
*& Form AUTOMOV_ON_SALE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM automov_on_sale .

  " Code automation for the process to avoid generating overhead

  IF go_custom_container IS NOT BOUND.
" EXPLIATIONIN VIDEO 3.13 MIN 2:40 - 3:56
    PERFORM get_data. " get data of database zco_vehiculos

    PERFORM create_container USING 'V'. " code modularization in the include F01

    "ct_fieldcat =  gt_fieldcat
    PERFORM create_fieldcat. " breakpoint for look at the content in method LVC_FIELDCATALOG_MERGE

    PERFORM create_layout.

    PERFORM create_alv. " call a subrutines

    PERFORM create_alv_header. "

    PERFORM set_handlers.

    PERFORM register_events. " register events

    PERFORM exclude_toolbar_functions.

    PERFORM display_alv. " show information of db zco_vehiculos -> subroutine with data

    PERFORM create_variants.

  ELSE.
    "ordination criteria
*    perform set_sort_criteria.
    " filter order eq display_alv
*    perform set_filter_criteria.

    " refresh the container
    PERFORM refresh_alv.

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

  "check if the object is instantiated
  IF go_custom_container IS BOUND .  " is instanciated, liberation of recurse

      go_custom_container->free(
        EXCEPTIONS
          cntl_error        = 1                " CNTL_ERROR
          cntl_system_error = 2                " CNTL_SYSTEM_ERROR
          OTHERS            = 3
      ).
      IF sy-subrc <> 0.
       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.  "hide alv of custom container

      " lock of release with the object doesn't this instantiated
      CLEAR go_custom_container. " recurse clean, verify in the 'if' with go_custom_container is bound

      " verify if this instantiated
      IF go_alv_grid IS BOUND.

        CLEAR go_alv_grid. " object clean, the ralation this lost with he 'clear' go_custom_container

      ENDIF.

      IF go_event_receiver IS BOUND.
        CLEAR go_event_receiver.
      ENDIF.

      IF go_salv_table IS BOUND.
        CLEAR go_salv_table.
      ENDIF.

      IF go_salv_event IS BOUND.
        CLEAR go_salv_event.
      ENDIF.

  ENDIF.

  IF go_salv_hier is bound.
        clear go_salv_hier.
  ENDIF.

  IF go_salv_tree is BOUND.
    clear: go_salv_tree.
  ENDIF.

  IF go_gui_tree is BOUND.
    clear go_gui_tree.
  ENDIF.

  clear:gt_mmc_temp_tree,
        gt_fieldcat,
        gt_fieldcat_tree.

  cl_gui_cfw=>flush(
    EXCEPTIONS
      cntl_system_error = 1                " cntl_system_error
      cntl_error        = 2                " cntl_error
      others            = 3
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*

" available method refresh_alv -> in the class set_table_for_first_display
FORM create_layout .

  FIELD-SYMBOLS <ls_vehiculos> TYPE gty_vehiculos.

  DATA ls_style TYPE lvc_s_styl.

  gs_layout-zebra = abap_true. " this value is true or false
  gs_layout-edit =  abap_true. " inform to the alv -> display_alv in the method set_table_for_first_display in 'is_layout' pass variable
  gs_layout-stylefname = 'FIELD_STYLE'. " edit customizable column
  gs_layout-cwidth_opt = abap_true. "NEW PROPERTY column optimization

  "LOCK COLUMNS FROM BEING PERSONALIZED
  LOOP AT gt_vehiculos ASSIGNING <ls_vehiculos>.

    "internal model
    ls_style-fieldname = 'MATRICULA'.
    ls_style-style     = cl_gui_alv_grid=>mc_style_disabled. "
    INSERT ls_style INTO TABLE <ls_vehiculos>-field_style. " definition in of TOP, control column

     " LOCK COLUMN MARCA  IN ls_style-fieldname
*    " internal model
*    ls_style-fieldname = 'MARCA'.
*    ls_style-style     = cl_gui_alv_grid=>mc_style_disabled. "
*    insert ls_style into table <ls_vehiculos>-field_style. " definition in of TOP, control column


  ENDLOOP.

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

  IF go_event_receiver IS NOT BOUND . " execue just once

      " create instance of event
      CREATE OBJECT go_event_receiver.

      SET HANDLER: go_event_receiver->handle_data_changed          FOR go_alv_grid,
                   go_event_receiver->handle_double_click          FOR go_alv_grid,
                   go_event_receiver->handle_user_command          FOR go_alv_grid,
                   go_event_receiver->handle_toolbar               FOR go_alv_grid,
                   go_event_receiver->handle_onf4                  FOR go_alv_grid,
                   go_event_receiver->handle_data_changed_finished FOR go_alv_grid,
                   go_event_receiver->handle_hotspot_click         FOR go_alv_grid.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form register_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_events .

  DATA: lt_f4 TYPE lvc_t_f4,
        ls_f4 TYPE lvc_s_f4.

  ls_f4-fieldname = 'MARCA'.
  ls_f4-register = abap_true.

  APPEND ls_f4 TO lt_f4.

  go_alv_grid->register_f4_for_fields( it_f4 = lt_f4 ).

  " method for register of event edit WITH VALIDATION OF DATA
  CALL METHOD go_alv_grid->register_edit_event
    EXPORTING
      i_event_id =  cl_gui_alv_grid=>mc_evt_enter " assigned value for the event               " Event ID
    EXCEPTIONS
      error      = 1                " Error
      OTHERS     = 2
    .
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort_criteria
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort_criteria .

   DATA: lt_sort TYPE lvc_t_sort,
         ls_sort TYPE lvc_s_sort.

  ls_sort-fieldname = 'MARCA'.
  ls_sort-up        = abap_true.

  APPEND ls_sort TO lt_sort.

  go_alv_grid->set_sort_criteria(
    EXPORTING
      it_sort                   =  lt_sort                " Sort Criteria
    EXCEPTIONS
      no_fieldcatalog_available = 1                " Instance Variable of Field Catalog not yet Set
      OTHERS                    = 2
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_filter_criteria
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_filter_criteria .

 DATA: lt_filter TYPE lvc_t_filt,
       ls_filter TYPE lvc_s_filt.

  " filter of information
  ls_filter-fieldname = 'POTENCIA'.
  ls_filter-sign = 'I'.
  ls_filter-option = 'GT'. " bt
  ls_filter-low = '150'.
*  ls_filter-high = '200'.

  APPEND ls_filter TO lt_filter.

  go_alv_grid->set_filter_criteria(
    EXPORTING
      it_filter                 = lt_filter                 " Filter Conditions
    EXCEPTIONS
      no_fieldcatalog_available = 1                " Instance Variable of Field Catalog not yet Set
      OTHERS                    = 2
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_variants
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_variants .

  gs_variants-report = sy-repid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form exclude_toolbar_functions
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM exclude_toolbar_functions .

  DATA lv_exclude TYPE ui_func.

  lv_exclude = cl_gui_alv_grid=>mc_fc_print.
  APPEND lv_exclude TO gt_toolbar_excluding.

  lv_exclude = cl_gui_alv_grid=>mc_fc_pc_file.
  APPEND lv_exclude TO gt_toolbar_excluding.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_alv_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_alv_header .

  DATA: lo_doc_cabec TYPE REF TO cl_dd_document,
        lv_text      TYPE sdydo_text_element,
        lv_no_vehiculos TYPE i,
        lv_no_vehiculos_st TYPE string.

  CREATE OBJECT lo_doc_cabec.

  CONCATENATE 'Bienvenido' sy-uname INTO lv_text SEPARATED BY space.

  lo_doc_cabec->add_text_as_heading(
    EXPORTING
      text          =  lv_text               " Single Text, Up To 255 Characters Long
*      sap_color     =                  " Not Release 99
*      sap_fontstyle =                  " Not Release 99
      heading_level =   1              " Valid: 1 to 6
*      a11y_tooltip  =                  " A11Y: Additional Explanation
*    CHANGING
*      document      =                  " x
  ).

  DESCRIBE TABLE gt_vehiculos LINES lv_no_vehiculos.

  lv_no_vehiculos_st = lv_no_vehiculos.

  CONCATENATE 'N° de vehiculos disponibles ' lv_no_vehiculos_st INTO lv_text SEPARATED BY space.

  lo_doc_cabec->add_text( EXPORTING text = lv_text ).

  lo_doc_cabec->new_line(
*      repeat =
  ).

  WRITE sy-datum DD/MM/YYYY TO lv_text.

  lo_doc_cabec->add_text(
    EXPORTING
      text          = lv_text                 " Single Text, Up To 255 Characters Long
*      text_table    =                  " Table With Single Texts
*      fix_lines     =                  " If 'X': TEXT_TABLE Display in Lines, Otherwise Continuous
*      sap_style     =                  " Recommended Styles
*      sap_color     =                  " Not Release 99
*      sap_fontsize  =                  " Recommended Font Sizes
*      sap_fontstyle =                  " Not Release 99
*      sap_emphasis  =                  " Text Highlighting
*      style_class   =                  " Not Release 99
*      a11y_tooltip  =                  " A11Y: Additional Explanation
*    CHANGING
*      document      =                  " x
  ).

  lo_doc_cabec->display_document(
    EXPORTING
*      reuse_control      =                  " HTML Control Reused
*      reuse_registration =                  " Event Registration Reused
*      container          =                  " Name of Container (New Container Object Generated)
      parent             =   go_gui_cont_header               " Contain Object Already Exists
    EXCEPTIONS
      html_display_error = 1                " Error Displaying the Document in the HTML Control
      OTHERS             = 2
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form automov_on_rent
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM automov_on_rent . " this is screen

IF go_salv_table IS NOT BOUND.

  PERFORM get_data.

  PERFORM create_container USING 'A'.

  PERFORM instance_salv.

  PERFORM set_salv_functions.

  PERFORM set_salv_events.

  PERFORM change_salv_layout.

  PERFORM change_salv_columns.

  PERFORM set_salv_aggregation.

  PERFORM set_salv_sort.

  PERFORM set_salv_filters.

  perform set_salv_colors.

ENDIF.

  PERFORM display_salv.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form instance_salv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_salv .

  DATA lx_salv_msg TYPE REF TO cx_salv_msg.

TRY.
  cl_salv_table=>factory(
    EXPORTING
*      list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
      r_container    = go_custom_container                          " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table   = go_salv_table " TOP                          " Basis Class Simple ALV Tables
    CHANGING
      t_table        = gt_veh_alq "gt_vehiculos --> removed 4.13   " table internal
  ).
  CATCH cx_salv_msg INTO lx_salv_msg. " ALV: General Error Class with Message

  WRITE lx_salv_msg->get_text( ).

ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_salv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_salv .

  go_salv_table->display( ).  " new screen, not customizable

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_salv_functions
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_salv_functions .

  DATA: lo_function TYPE REF TO cl_salv_functions_list, "
        lv_name     TYPE salv_de_function,
        lv_ICON     TYPE string,
        lv_TEXT     TYPE string,
        lv_TOOLTIP  TYPE string.

  lv_name    = 'BTN_RENT'. "name button
  lv_icon    = icon_rental_agreement.
  lv_text    = 'Contrato'.
  lv_tooltip = 'Contrato de renta'.

  lo_function = go_salv_table->get_functions( ). "reference

*  lo_function->set_sort_asc(
*      value = if_salv_c_bool_sap=>true "value default
*  ).
*
*  lo_function->set_sort_desc(
*      value = if_salv_c_bool_sap=>true  " value default
*  ).
 "is the same
*  lo_function->set_default(
*      value = if_salv_c_bool_sap=>true
*  ).
*
* lo_function->set_detail(
*     value = if_salv_c_bool_sap=>true
* ).
  "function all
  lo_function->set_all(
      value = if_salv_c_bool_sap=>true
  ).

  TRY.
    lo_function->add_function(
      EXPORTING
        name     =  lv_name                 " ALV Function
        icon     =  lv_icon
        text     =  lv_text
        tooltip  =  lv_tooltip
        position =  if_salv_c_function_position=>right_of_salv_functions                " Positioning Function
    ).
    CATCH cx_salv_existing.   " ALV: General Error Class (Checked in Syntax Check)
    CATCH cx_salv_wrong_call. " ALV: General Error Class (Checked in Syntax Check)

  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_salv_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_salv_events .

  DATA lo_events TYPE REF TO cl_salv_events_table.

  IF go_salv_event IS NOT BOUND. " call one

  CREATE OBJECT go_salv_event.

  lo_events = go_salv_table->get_event( ).

  SET HANDLER go_salv_event->handle_added_function FOR lo_events. "local class -><- standar object

  ENDIF. " in free container -> clear

ENDFORM.
*&---------------------------------------------------------------------*
*& Form change_salv_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_salv_layout .
  "save key in db

  DATA: lo_salv_layout TYPE REF TO cl_salv_layout,
        ls_key         TYPE salv_s_layout_key,
        lv_variant     TYPE slis_vari.

  lo_salv_layout = go_salv_table->get_layout( ).

  ls_key-report = sy-repid.

  ls_key-logical_group = 'ALQ'. " new variant

  lo_salv_layout->set_key( value = ls_key ). "primary key or foreign key

  lo_salv_layout->set_save_restriction(
      value = if_salv_c_layout=>restrict_none
  ).

  lv_variant = 'DEFAULT'.

  lo_salv_layout->set_initial_layout( value = lv_variant ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form change_salv_columns
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_salv_columns .

  DATA: "lo_columns type ref to cl_salv_columns_table,
        lo_columns    TYPE REF TO cl_salv_columns_table,
        lo_sng_column TYPE REF TO cl_salv_column.

  lo_columns = go_salv_table->get_columns( ). " reference class

   " obtimation columns
   "obtimation columns [name|name1]
  lo_columns->set_optimize( abap_true ). " or abap_true

" hiden field columns
 TRY.
   lo_sng_column = lo_columns->get_column( columnname = 'FLG_COMPRA' ). " name field of db
   lo_sng_column->set_visible( " call method 'set visible' value true or false
       value = if_salv_c_bool_sap=>false
   ).
 CATCH cx_salv_not_found . " ALV: General Error Class (Checked in Syntax Check)

 ENDTRY.

 " fields FLG_ALQUILER
  TRY.
   lo_sng_column = lo_columns->get_column( columnname = 'FLG_ALQUILER' ). " name field of db
   lo_sng_column->set_visible( " call method 'set visible' value true or false
       value = if_salv_c_bool_sap=>false
   ).
 CATCH cx_salv_not_found . " ALV: General Error Class (Checked in Syntax Check)

 ENDTRY.

   TRY.
   lo_sng_column = lo_columns->get_column( columnname = 'CLIENT' ). " name field of db
   lo_sng_column->set_visible( " call method 'set visible' value true or false
       value = if_salv_c_bool_sap=>false
   ).
 CATCH cx_salv_not_found . " ALV: General Error Class (Checked in Syntax Check)

 ENDTRY.

TRY.
   lo_sng_column = lo_columns->get_column( columnname = 'MATRICULA' ). " name field of db
   lo_sng_column->set_long_text( 'PLACA AUTO' ).
   lo_sng_column->set_medium_text( 'PLACA AUTO' ).
   lo_sng_column->set_short_text( 'PLACA AUTO' ).
 CATCH cx_salv_not_found . " ALV: General Error Class (Checked in Syntax Check)

 ENDTRY.

*  go_salv_table->get_columns( ). " method show

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_salv_aggregation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_salv_aggregation .

  DATA: lo_aggregations TYPE REF TO cl_salv_aggregations,
        lo_aggregation  TYPE REF TO cl_salv_aggregation.

  COMMIT WORK.
  lo_aggregations = go_salv_table->get_aggregations( ).

TRY.

  lo_aggregations->add_aggregation(
    EXPORTING
      columnname  = 'PRECIO'                 " ALV Control: Field Name of Internal Table Field
      aggregation = if_salv_c_aggregation=>total " Aggregation
    RECEIVING
      value       = lo_aggregation           " ALV: Aggregations
  ).
  CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_not_found.  " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_existing.   " ALV: General Error Class (Checked in Syntax Check)

ENDTRY.

  lo_aggregations->set_aggregation_before_items( abap_true ).

*  lo_aggregation->clear().

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_salv_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_salv_sort .

  Data: lo_sorts type ref to cl_salv_sorts,
        lo_sort  type ref to cl_salv_sort.

  lo_sorts = go_salv_table->get_sorts( ).

try.
  lo_sorts->add_sort(
    EXPORTING
      columnname =   'MARCA'                         " ALV Control: Field Name of Internal Table Field
*      position   =
      sequence   = if_salv_c_sort=>sort_up    " Sort Sequence  ---> ASC
      subtotal   = if_salv_c_bool_sap=>true  " Boolean Variable (X=True, Space=False)
*      group      = if_salv_c_sort=>group_none " Control Break
*      obligatory = if_salv_c_bool_sap=>false  " Boolean Variable (X=True, Space=False)
    RECEIVING
      value      = lo_sort                           " ALV Sort Settings
  ).
  CATCH cx_salv_not_found.  " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_existing.   " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)

endtry.

*  lo_sorts->clear( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_salv_filters
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_salv_filters .

  data: lo_filters type ref to cl_salv_filters,
        lo_filter  type ref to cl_salv_filter.

  lo_filters = go_salv_table->get_filters( ).

try.
  lo_filters->add_filter(
    EXPORTING
      columnname = 'COMBUSTIBLE'                 " ALV Control: Field Name of Internal Table Field
      sign       = 'I'              " Selection Condition Sign
      option     = 'EQ'             " Selection Condition Option
      low        = 'GASOLINA'                 " Lower Value of Selection Condition
*      high       =                  " Upper Value of Selection Condition
    RECEIVING
      value      = lo_filter                 " ALV Filter Settings
  ).
  CATCH cx_salv_not_found.  " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_existing.   " ALV: General Error Class (Checked in Syntax Check)

endtry.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_salv_colors
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_salv_colors .
" set color
DATA: "lo_columns type ref to cl_salv_columns_table,
        lo_columns    TYPE REF TO cl_salv_columns_table,
        lo_column     TYPE REF TO cl_salv_column_table,
        ls_color      type lvc_s_colo,
        ls_color_all  type lvc_s_scol.

  FIELD-SYMBOLS <ls_veh_alq> TYPE gty_vehiculos_alq.

  ls_color-col = 5.
  ls_color-int = 1.
  ls_color-inv = 0.

  lo_columns = go_salv_table->get_columns( ). " reference class
" hiden field columns
 TRY.
   lo_column ?= lo_columns->get_column( columnname = 'PRECIO' ). " name field of db
   lo_column->set_color( value = ls_color ).
 CATCH cx_salv_not_found . " ALV: General Error Class (Checked in Syntax Check)

 ENDTRY.

 LOOP at gt_veh_alq ASSIGNING <ls_veh_alq>.

   " modify the value in fieldsimbols

   IF <ls_veh_alq>-marca eq 'AUDI' and <ls_veh_alq>-modelo eq 'A8'.

    ls_color_all-fname = 'MODELO'.
    ls_color_all-color-col = col_negative.
    ls_color_all-color-int = 1.
    ls_color_all-color-inv = 0.

    APPEND ls_color_all to <ls_veh_alq>-t_color.

   ENDIF.

   IF <ls_veh_alq>-marca eq 'FORD'.
    ls_color_all-color-col = col_negative.
    ls_color_all-color-int = 1.
    ls_color_all-color-inv = 0.

    APPEND ls_color_all to <ls_veh_alq>-t_color.
   ENDIF.

   CLEAR ls_color_all.

 ENDLOOP.
try.
  lo_columns->set_color_column( value = 'T_COLOR' ). "NAME COLUMN
  CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)
endtry.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form vehi_alq_hier
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM vehi_cln_hier .

  IF go_salv_hier is not bound.

    PERFORM get_data.

    PERFORM create_salv_hier.

    PERFORM set_salv_hier_funct. " functions standard

    perform configure_hier_columns. " hide columns

    PERFORM set_hier_events.

    perform alv_hier_top_end_list.


  ENDIF.

  perform display_salv_hier. " show data

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_veh_clnt
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_veh_clnt .

    DATA: lt_cond_tab     TYPE TABLE OF hrcond,
        ls_cond_tab     TYPE hrcond,
        lt_where_clause TYPE TABLE OF string.

  IF zco_clientes-dni IS NOT INITIAL.
    ls_cond_tab-field = 'DNI'.
    ls_cond_tab-opera = 'EQ'.
    ls_cond_tab-low   = zco_clientes-dni.
    APPEND ls_cond_tab TO lt_cond_tab.
  ENDIF.

  IF zco_clientes-nombre IS NOT INITIAL.
    ls_cond_tab-field = 'NOMBRE'.
    ls_cond_tab-opera = 'LK'.
    CONCATENATE '%' zco_clientes-nombre '%' INTO ls_cond_tab-low.
    APPEND ls_cond_tab TO lt_cond_tab.
  ENDIF.

  IF zco_clientes-last_name IS NOT INITIAL.
    ls_cond_tab-field = 'LAST_NAME'.
    ls_cond_tab-opera = 'LK'.
    CONCATENATE '%' zco_clientes-last_name '%' INTO ls_cond_tab-low.
    APPEND ls_cond_tab TO lt_cond_tab.
  ENDIF.

  IF zco_clientes-email IS NOT INITIAL.
    ls_cond_tab-field = 'EMAIL'.
    ls_cond_tab-opera = 'LK'.
    CONCATENATE '%' zco_clientes-email '%' INTO ls_cond_tab-low.
    APPEND ls_cond_tab TO lt_cond_tab.
  ENDIF.

  IF zco_clientes-cntr_type IS NOT INITIAL.
    ls_cond_tab-field = 'CNTR_TYPE'.
    ls_cond_tab-opera = 'EQ'.
    ls_cond_tab-low   = zco_clientes-cntr_type.
    APPEND ls_cond_tab TO lt_cond_tab.
  ENDIF.

  IF zco_clientes-matricula IS NOT INITIAL.
    ls_cond_tab-field = 'MATRICULA'.
    ls_cond_tab-opera = 'EQ'.
    ls_cond_tab-low   = zco_clientes-matricula.
    APPEND ls_cond_tab TO lt_cond_tab.
  ENDIF.

  IF lt_cond_tab IS NOT INITIAL.
    CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
      EXPORTING
        dbtable         = 'ZCO_CLIENTES'
      TABLES
        condtab         = lt_cond_tab
        where_clause    = lt_where_clause
      EXCEPTIONS
        empty_condtab   = 1
        no_db_field     = 2
        unknown_db      = 3
        wrong_condition = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

  IF lt_where_clause IS NOT INITIAL.
    SELECT * FROM zco_clientes
      INTO TABLE gt_cln_hier
      WHERE (lt_where_clause).
  ELSE.
    SELECT * FROM zco_clientes
    INTO TABLE gt_cln_hier.
  ENDIF.

  IF sy-subrc EQ 0.
    SELECT * FROM zco_vehiculos
        INTO TABLE gt_veh_hier
        FOR ALL ENTRIES IN gt_cln_hier
        WHERE matricula EQ gt_cln_hier-matricula.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_salv_hier
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_salv_hier .

  data: lt_binding type salv_t_hierseq_binding,
        ls_binding type salv_s_hierseq_binding.

  ls_binding-master = 'CLIENT'.
  ls_binding-slave  = 'CLIENT'.
  APPEND ls_binding to lt_binding.

  ls_binding-master = 'MATRICULA'.
  ls_binding-slave  = 'MATRICULA'.
  APPEND ls_binding to lt_binding.

try.
  cl_Salv_hierseq_table=>factory(
    EXPORTING
      t_binding_level1_level2 = lt_binding                 " Binding Between Two Tables
    IMPORTING
      r_hierseq               = go_salv_hier                 " Sequential ALV Tables
    CHANGING
      t_table_level1          = gt_veh_hier
      t_table_level2          = gt_cln_hier
  ).
  CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_not_found.  " ALV: General Error Class (Checked in Syntax Check)
endtry.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_salv_hier
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_salv_hier .

  go_salv_hier->display( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_salv_hier_funct
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_salv_hier_funct .

*  data lo_func_hier type ref to cl_salv_functions_list.
*
*  lo_func_hier = go_salv_hier->get_functions( ).
*
*  lo_func_hier->set_all(
*      value = if_salv_c_bool_sap=>true
*  ).

   go_salv_hier->get_functions( )->set_all(
       value = if_salv_c_bool_sap=>true
   ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form configure_hier_columns
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM configure_hier_columns .

  data: lo_hier_columns type ref to cl_salv_columns_hierseq,
        lo_hier_column  type ref to cl_salv_column_hierseq,
        lo_hier_level   type ref to cl_salv_hierseq_level.

"header table
try.
  lo_hier_columns = go_salv_hier->get_columns( level = 1 ).
  CATCH cx_salv_not_found. " ALV: General Error Class (Checked in Syntax Check)
endtry.

*  lo_hier_columns->set_optimize( ). "not recommended

TRY.
lo_hier_column ?= lo_hier_columns->get_column( columnname = 'CLIENT' ).
lo_hier_column->set_technical(
    value = if_salv_c_bool_sap=>true
).
CATCH cx_salv_not_found. " ALV: General Error Class (Checked in Syntax Check)
ENDTRY.

try.
  lo_hier_columns->set_expand_column( value = 'MARCA' ).
  CATCH cx_salv_data_error. " ALV: General Error Class with Message
endtry.

try.
  lo_hier_level = GO_salv_hier->get_level( level = 1 ).
  CATCH cx_salv_not_found. " ALV: General Error Class (Checked in Syntax Check)
endtry.

lo_hier_level->set_items_expanded(
    value = if_salv_c_bool_sap=>true
).

"items table

try.
  lo_hier_columns = go_salv_hier->get_columns( level = 2 ).
  CATCH cx_salv_not_found. " ALV: General Error Class (Checked in Syntax Check)
endtry.

*  lo_hier_columns->set_optimize( ). "not recommended

TRY.
lo_hier_column ?= lo_hier_columns->get_column( columnname = 'CLIENT' ).
lo_hier_column->set_technical(
    value = if_salv_c_bool_sap=>true
).
CATCH cx_salv_not_found. " ALV: General Error Class (Checked in Syntax Check)
ENDTRY.


TRY.
lo_hier_column ?= lo_hier_columns->get_column( columnname = 'DNI' ).
lo_hier_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
CATCH cx_salv_not_found. " ALV: General Error Class (Checked in Syntax Check)
ENDTRY.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_hier_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_hier_events .

  data lo_hier_events type ref to cl_salv_events_hierseq.

  create object go_hier_events.

  lo_hier_events = go_salv_hier->get_event( ).

  set HANDLER go_hier_events->handle_link_clik for lo_hier_events.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_hier_top_end_list
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM alv_hier_top_end_list .

  data: lo_header type ref to cl_salv_form_layout_grid,
        lo_label  type ref to cl_salv_form_label,
        lo_flow   type ref to cl_salv_form_layout_flow,
        lv_text   type string,
        lv_number type i.

  create object lo_header.

  " add informat
  lo_label = lo_header->create_label(
    EXPORTING
      row         = 1                 " Natural Number
      column      = 1                 " Natural Number
*      rowspan     =
*      colspan     =
*      text        =
*      tooltip     =
*      r_label_for =                  " Text
*    RECEIVING
*      r_value     =                  " Label
  ).

  CONCATENATE 'BIENVENIDO' sy-uname into lv_text SEPARATED BY space.
  lo_label->set_text( value = lv_text ).

" flow
   lo_flow = lo_header->create_flow(
    EXPORTING
      row     = 2                 " Natural Number
      column  = 1                 " Natural Number
*      rowspan =
*      colspan =
*    RECEIVING
*      r_value =
  ).

  DESCRIBE TABLE gt_veh_hier lines lv_number.
  lv_text = lv_number.
  CONCATENATE 'N° de vehiculos disponibles ' lv_text into lv_text SEPARATED BY space.
  lo_flow->create_text( text = lv_text ).


  " flow
   lo_flow = lo_header->create_flow(
    EXPORTING
      row     = 3                 " Natural Number
      column  = 1                 " Natural Number
*      rowspan =
*      colspan =
*    RECEIVING
*      r_value =
  ).

  DESCRIBE TABLE gt_cln_hier lines lv_number.
  lv_text = lv_number.
  CONCATENATE 'N° de clientes disponibles ' lv_text into lv_text SEPARATED BY space.

  lo_flow->create_text( text = lv_text ).

  go_salv_hier->set_top_of_list( value = lo_header ). " show
  go_salv_hier->set_end_of_list( value = lo_header ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form marca_modelo_cliente
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM marca_modelo_cliente .

  PERFORM create_container using 'T'. " instance container

  perform ceate_instance_salv_tree. "instance

  perform build_salv_tree_header.

  PERFORM get_salv_tree_data.

  PERFORM salv_tree_data_modeling.

  PERFORM configure_salv_tree_columns.

  perform display_salv_tree.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ceate_instance_salv_tree
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM ceate_instance_salv_tree .

try.
  cl_salv_tree=>factory(
    EXPORTING
      r_container = go_custom_container                 " Abstract Container for GUI Controls
*      hide_header =                  " Do Not Show Header
    IMPORTING
      r_salv_tree = go_salv_tree                 " ALV: Tree Model
    CHANGING
      t_table     = gt_mmc_temp_tree
  ).
  CATCH cx_salv_error. " ALV: General Error Class (Checked in Syntax Check)
endtry.

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

  data lo_settings type ref to cl_salv_tree_settings.

  lo_settings = go_salv_tree->get_tree_settings( ).
  "assing name column
  lo_settings->set_hierarchy_header( value = 'REGISTROS' ).

  "string character, mouse
  lo_settings->set_hierarchy_tooltip( value = 'DESPLIEGUE LOS NODOS' ).
  lo_settings->set_hierarchy_size( value = 35 ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_salv_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_salv_tree_data .

  select marcas~marca
         vehiculos~modelo
         vehiculos~matricula
         vehiculos~motor
         vehiculos~combustible
         clientes~nombre
         clientes~last_name
         clientes~dni
         clientes~email
    from zco_marcas as marcas INNER JOIN zco_vehiculos as vehiculos
                                on marcas~marca eq vehiculos~marca
                              INNER JOIN zco_clientes as clientes
                                on vehiculos~matricula eq clientes~matricula
                              into table gt_mmc_tree
    order by marcas~marca vehiculos~modelo.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form salv_tree_data_modeling
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM salv_tree_data_modeling .

  data: lo_nodes type ref to cl_salv_nodes,
        lo_node type ref to cl_salv_node.

  data: lv_text       type lvc_value,
        lv_key_marca  type salv_de_node_key,
        lv_key_modelo type salv_de_node_key.

  FIELD-SYMBOLS <ls_mmc_tree> type zco_ma_mo_cl_tree.

  lo_nodes = go_salv_tree->get_nodes( ).

  LOOP AT gt_mmc_tree ASSIGNING <ls_mmc_tree>.
    on CHANGE OF <ls_mmc_tree>-marca.

    lv_text = <ls_mmc_tree>-marca.
    try.
      lo_node = lo_nodes->add_node(
        EXPORTING
          related_node   = space " not node s                 " Key to Related Node
          relationship   =  if_salv_c_node_relation=>parent                " Node Relation in Tree
          text           = lv_text                 " ALV Control: Cell Content
          expander       =  abap_true                " Boolean Variable (X=True, Space=False)
          folder         = abap_true                 " Boolean Variable (X=True, Space=False)
      ).

      lv_key_marca = lo_node->get_key(  ).

      CATCH cx_salv_msg. " ALV: General Error Class with Message
    endtry.

    endon.

    "model child

    on CHANGE OF <ls_mmc_tree>-modelo.
    lv_text = <ls_mmc_tree>-modelo.

    try.
      lo_node = lo_nodes->add_node(
        EXPORTING
          related_node   = lv_key_marca                " Key to Related Node
          relationship   =  if_salv_c_node_relation=>last_child                " Node Relation in Tree
          text           = lv_text                 " ALV Control: Cell Content
          expander       =  abap_true                " Boolean Variable (X=True, Space=False)
          folder         = abap_true                 " Boolean Variable (X=True, Space=False)
      ).

      lv_key_modelo = lo_node->get_key( ).

      CATCH cx_salv_msg. " ALV: General Error Class with Message
    endtry.

    endon.

    lv_text = <ls_mmc_tree>-matricula.
    try.
      lo_node = lo_nodes->add_node(
        EXPORTING
          related_node   = lv_key_modelo                " Key to Related Node
          relationship   =  if_salv_c_node_relation=>last_child                " Node Relation in Tree
          data_row       = <ls_mmc_tree>                 " Data Row
          text           = lv_text                 " ALV Control: Cell Content
      ).

*      lo_node->set_data_row( value = <ls_mmc_tree> ).

      CATCH cx_salv_msg. " ALV: General Error Class with Message
    endtry.

  ENDLOOP.

  lo_nodes->expand_all( ).

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

  data: lo_columns type ref to cl_salv_columns_tree,
        lo_column type ref to cl_salv_column.

  lo_columns = go_salv_tree->get_columns( ).

  lo_columns->set_optimize(
      abap_true
  ).

"HIDE COLUMNS
  try.
  lo_column = lo_columns->get_column( columnname = 'MARCA' ).
  lo_column->set_visible( ABAP_FALSE ).

  lo_column = lo_columns->get_column( columnname = 'MODELO' ).
  lo_column->set_visible( ABAP_FALSE ).

  lo_column = lo_columns->get_column( columnname = 'MATRICULA' ).
  lo_column->set_visible( ABAP_FALSE ).

  CATCH cx_salv_not_found. " ALV: General Error Class (Checked in Syntax Check)
    endtry.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form gui_marca_modelo_cliente
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gui_marca_modelo_clientes .

  PERFORM create_container USING 'G'.

  PERFORM instance_gui_tree. " subroutine

  PERFORM configure_gui_tree_header.

  PERFORM create_gui_tree_fieldcat.

  PERFORM gui_tree_first_display. " get data

  PERFORM gui_tree_drag_drop_event .

  PERFORM gui_tree_add_favourit.

  PERFORM get_salv_tree_data.

  PERFORM gui_tree_set_nodes.

  PERFORM gui_tree_events."set handle



  PERFORM gui_tree_front_update. " node

ENDFORM.
*&---------------------------------------------------------------------*
*& Form instance_gui_tree
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_gui_tree .

  create object go_gui_tree
    EXPORTING
*      lifetime                    =
      parent                      = go_custom_container
*      shellstyle                  =
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
*      hide_selection              =
      item_selection              = 'X'
*      no_toolbar                  =
      no_html_header              = 'X'
*      i_print                     =
*      i_fcat_complete             =
*      i_model_mode                =
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      illegal_node_selection_mode = 5
      failed                      = 6
      illegal_column_name         = 7
      others                      = 8
    .
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form configure_gui_tree_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM configure_gui_tree_header .

  gs_hierarchy_header-heading = 'REGISTROS'.
  gs_hierarchy_header-tooltip = 'DESPLIEGUE LOS NODOS'.
  gs_hierarchy_header-width = 35.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_gui_tree_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_gui_tree_fieldcat .

  FIELD-SYMBOLS <ls_fieldcat> type lvc_s_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
   EXPORTING
*     I_BUFFER_ACTIVE              =
     I_STRUCTURE_NAME             = 'ZCO_MA_MO_CL_TREE'
*     I_CLIENT_NEVER_DISPLAY       = 'X'
*     I_BYPASSING_BUFFER           =
*     I_INTERNAL_TABNAME           =
    CHANGING
      ct_fieldcat                  = gt_fieldcat_tree "gt_fieldcat
   EXCEPTIONS
     INCONSISTENT_INTERFACE       = 1
     PROGRAM_ERROR                = 2
     OTHERS                       = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

LOOP AT gt_fieldcat ASSIGNING <ls_fieldcat>.

  IF <ls_fieldcat>-fieldname = 'MARCA' or <ls_fieldcat>-fieldname = 'MODELO' or
    <ls_fieldcat>-fieldname = 'MATRICULA'.

    <ls_fieldcat>-no_out = abap_true.

  ENDIF.

ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form gui_tree_first_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gui_tree_first_display .

  go_gui_tree->set_table_for_first_display(
    EXPORTING
      is_hierarchy_header   =  gs_hierarchy_header
    CHANGING
      it_outtab             = gt_mmc_temp_tree
      it_fieldcatalog      = gt_fieldcat_tree "gt_fieldcat
  ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form gui_tree_front_update
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gui_tree_front_update .

  go_gui_tree->frontend_update( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form gui_tree_set_nodes
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gui_tree_set_nodes .

  FIELD-SYMBOLS <ls_mmc_Tree> type zco_ma_mo_cl_tree.

  data: ls_node_layout  type lvc_s_layn,
        lv_node_text    type lvc_value,
        lv_new_node_marca type lvc_nkey,
        lv_new_node_modelo type lvc_nkey.

  LOOP AT gt_mmc_tree ASSIGNING <ls_mmc_Tree>.

    on CHANGE OF <ls_mmc_Tree>-marca.

    ls_node_layout-isfolder = abap_true.
    ls_node_layout-expander = abap_true.

    lv_node_text = <ls_mmc_Tree>-marca.

      go_gui_tree->add_node(
        EXPORTING
          i_relat_node_key     = space
          i_relationship       = cl_gui_column_tree=>relat_last_child
*          is_outtab_line       =
          is_node_layout       = ls_node_layout
*          it_item_layout       =
          i_node_text          = lv_node_text
        IMPORTING
          e_new_node_key       = lv_new_node_marca
        EXCEPTIONS
          relat_node_not_found = 1
          node_not_found       = 2
          others               = 3
      ).
      IF SY-SUBRC <> 0.
       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

    endon.

    on CHANGE OF <ls_mmc_Tree>-modelo.

    ls_node_layout-isfolder = abap_true.
    ls_node_layout-expander = abap_true.

    lv_node_text = <ls_mmc_Tree>-modelo.

      go_gui_tree->add_node(
        EXPORTING
          i_relat_node_key     = lv_new_node_marca "node father
          i_relationship       = cl_gui_column_tree=>relat_last_child
*          is_outtab_line       =
          is_node_layout       = ls_node_layout
*          it_item_layout       =
          i_node_text          = lv_node_text
        IMPORTING
          e_new_node_key       = lv_new_node_modelo
        EXCEPTIONS
          relat_node_not_found = 1
          node_not_found       = 2
          others               = 3
      ).
      IF SY-SUBRC <> 0.
       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

    endon.

     lv_node_text = <ls_mmc_Tree>-matricula.

    clear ls_node_layout.
    ls_node_layout-dragdropid = gv_fav_line_id.

          go_gui_tree->add_node(
        EXPORTING
          i_relat_node_key     = lv_new_node_modelo "node father
          i_relationship       = cl_gui_column_tree=>relat_last_child
          is_outtab_line       = <ls_mmc_Tree>
          is_node_layout       = ls_node_layout
*          it_item_layout       =
          i_node_text          = lv_node_text
*        IMPORTING
*          e_new_node_key       =
        EXCEPTIONS
          relat_node_not_found = 1
          node_not_found       = 2
          others               = 3
      ).
      IF SY-SUBRC <> 0.
       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.


      clear ls_node_layout.


  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form gui_tree_add_favourit
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gui_tree_add_favourit .

data: ls_node_layout type lvc_s_layn,
      lv_node_text   type lvc_value.

ls_node_layout-dragdropid = gv_fav_folder_id.
ls_node_layout-isfolder = abap_true.
ls_node_layout-n_image = icon_system_favorites.

lv_node_text = 'FAVORITOS'.

go_gui_tree->add_node(
  EXPORTING
    i_relat_node_key     = space
    i_relationship       = cl_gui_column_tree=>relat_first_child
*    is_outtab_line       =
    is_node_layout       = ls_node_layout
*    it_item_layout       =
    i_node_text          = lv_node_text
  IMPORTING
    e_new_node_key       = gv_fav_key
  EXCEPTIONS
    relat_node_not_found = 1
    node_not_found       = 2
    others               = 3
).
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form gui_tree_drag_event
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gui_tree_drag_drop_event .

  data lv_effect type i.

  create object go_line_behaviour.

  lv_effect = cl_dragdrop=>copy.



  go_line_behaviour->add(
    EXPORTING
      flavor          = 'FAVORIT'
      dragsrc         = ABAP_TRUE
      droptarget      = SPACE
      effect          = lv_effect
*      effect_in_ctrl  = usedefaulteffect
    EXCEPTIONS
      already_defined = 1
      obj_invalid     = 2
      others          = 3
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

    go_line_behaviour->get_handle(
    IMPORTING
      handle      = gv_fav_line_id
    EXCEPTIONS
      obj_invalid = 1
      others      = 2
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT go_fav_behaviour.
  lv_effect = cl_dragdrop=>copy.

  go_fav_behaviour->add(
    EXPORTING
      flavor          = 'FAVORIT'
      dragsrc         = space
      droptarget      = abap_true
      effect          = lv_effect
*      effect_in_ctrl  = usedefaulteffect
    EXCEPTIONS
      already_defined = 1
      obj_invalid     = 2
      others          = 3
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  go_fav_behaviour->get_handle(
    IMPORTING
      handle      = gv_fav_folder_id
    EXCEPTIONS
      obj_invalid = 1
      others      = 2
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form gui_tree_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gui_tree_events .

  create object go_gui_tree_events.

  set handler go_gui_tree_events->handle_on_drag for go_gui_tree.

  set handler go_gui_tree_events->handle_on_drop for go_gui_tree.

ENDFORM.
