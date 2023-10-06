*&---------------------------------------------------------------------*
*& Include          ZBI_VIRT_ALFA02_F01
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

  CHECK ok_code IS NOT INITIAL.

  CASE ok_code.

    WHEN 'LIB_P'.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      PERFORM libros_de_papel. " action in libros_de_papel

      IF gv_first_time EQ abap_false.
        gv_first_time = abap_true.
      ENDIF.

      WHEN 'LIB_E'.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      PERFORM libros_electronicos.

      IF gv_first_time EQ abap_false.
        gv_first_time = abap_true.
      ENDIF.

    WHEN 'CAT_L'.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      PERFORM categorias_libros.

      IF gv_first_time EQ abap_false.
        gv_first_time = abap_true.
      ENDIF.

    WHEN 'CAT_LC'.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      PERFORM categorias_libros_clientes.

      IF gv_first_time EQ abap_false.
        gv_first_time = abap_true.
      ENDIF.

    WHEN 'ACC_C_L'.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.

      PERFORM acceso_categorias_libros.

      IF gv_first_time EQ abap_false.
        gv_first_time = abap_true.
      ENDIF.


    WHEN 'UNDO'.

*      IF gv_first_time EQ abap_false.
*        gv_first_time = abap_true.
*      ENDIF.

*      IF gv_first_time EQ abap_true.
*        PERFORM free_container.
*      ENDIF.

     PERFORM free_container. " release resources and clean up

    WHEN OTHERS.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form LIBROS_DE_PAPEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM libros_de_papel .

    IF go_custom_container IS NOT BOUND. "check if not is instantiated

        PERFORM get_data.  " get data ZBI_LIB_LOGALI

        PERFORM instance_cust_cont USING 'P'. " instance of alv where is information show

        PERFORM build_field_cat. " get data of database

        PERFORM create_alv_grid_header.  " Headboard  [ / ]

        PERFORM build_layout. "  low edit in column

        PERFORM instance_ALV_LIB_PAPEL. " show container without data

        PERFORM set_alv_grid_handlers. " events of

        PERFORM register_events. " search help -> F04

        PERFORM create_alv_grid_variants. " variants of system

        PERFORM exclude_alv_grid_toolbar.

        PERFORM display_alv_lib_papel. " show information from db



    ELSE. "data refresh

      PERFORM refresh_alv_lib_papel.

    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INSTANCE_CUST_CONT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_cust_cont USING pv_tipo_op.

   DATA lo_gui_splitter_cont TYPE REF TO cl_gui_splitter_container. " class 3.47

      CREATE OBJECT go_custom_container
    EXPORTING
*      parent                      =                  " Parent container
      container_name              =   'ALV_CONT'               " Name of the Screen CustCtrl Name to Link Container To
*      style                       =                  " Windows Style Attributes Applied to this Container
*      lifetime                    = lifetime_default " Lifetime
*      repid                       =                  " Screen to Which this Container is Linked
*      dynnr                       =                  " Report To Which this Container is Linked
*      no_autodef_progid_dynnr     =                  " Don't Autodefined Progid and Dynnr?
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


  IF pv_tipo_op EQ 'P'.

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
      parent                  = go_custom_container                   " Parent Container
      rows                    =  2                  " Number of Rows to be displayed
      columns                 =  1                 " Number of Columns to be Displayed
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
      container =  go_gui_cont_header                " Container
  ).

  lo_gui_splitter_cont->set_row_height(
    EXPORTING
      id                = 1                 " Row ID
      height            = 20                 " Height
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
     row       = 2                 " Row
     column    = 1                " Column
   RECEIVING
     container =   go_gui_cont_body               " Container
 ).

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FIELD_CAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_field_cat .

  " search help F4 ->get column name
  FIELD-SYMBOLS <ls_fieldcat> TYPE lvc_s_fcat.

    " get name of column of the db example: name - last_name - age

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
     EXPORTING
*       I_BUFFER_ACTIVE              =
       i_structure_name             = 'ZBI_LIB_LOGALI'
*       I_CLIENT_NEVER_DISPLAY       = 'X'
*       I_BYPASSING_BUFFER           =
*       I_INTERNAL_TABNAME           =
      CHANGING
        ct_fieldcat                  = gt_fieldcat
     EXCEPTIONS
       inconsistent_interface       = 1
       program_error                = 2
       OTHERS                       = 3
              .
    IF sy-subrc <> 0.
* Implement suitable error handling here
      MESSAGE 'ERROR' TYPE 'E'.

    ELSE.
          " healp search --> F04
    LOOP AT gt_fieldcat ASSIGNING <ls_fieldcat>.

      CASE <ls_fieldcat>-fieldname.

        WHEN 'BI_CATEG'.
          <ls_fieldcat>-f4availabl = abap_true.
        WHEN 'ID_LIBRO'.
          <ls_fieldcat>-hotspot = abap_true.

        WHEN 'PRECIO'.
          <ls_fieldcat>-do_sum = abap_true.
        WHEN OTHERS.
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

  CASE ok_code. " syste variable
    WHEN 'LIB_P'.

       SELECT * FROM zbi_lib_logali INTO CORRESPONDING FIELDS OF TABLE  gt_libros_papel WHERE formato EQ  'P'.

    WHEN 'LIB_E'.
      SELECT * FROM zbi_lib_logali INTO CORRESPONDING FIELDS OF TABLE  gt_libros_ele WHERE formato EQ  'E'.

    WHEN 'CAT_L'.

      PERFORM get_data_cat_lib.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_LIB_PAPEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_alv_lib_papel .


  "definition in (F01) VARIABLE 'go_alv_lib_papel'
  CREATE OBJECT go_alv_lib_papel
    EXPORTING
*      i_shellstyle            = 0                " Control Style
*      i_lifetime              =                  " Lifetime
      i_parent                =  go_gui_cont_body "go_custom_container " show container         " Parent Container
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
*& Form display_alv_lib_papel
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv_lib_papel .

  DATA: lt_sort TYPE lvc_t_sort,
        ls_sort TYPE lvc_s_sort.

  ls_sort-fieldname = 'AUTOR'.
  ls_sort-up = abap_true.

  APPEND ls_sort TO lt_sort.


  DATA: lt_filter TYPE lvc_t_filt,
        ls_filter TYPE lvc_s_filt.

  ls_filter-fieldname = 'IDIOMA'.
  ls_filter-sign      = 'I'.
  ls_filter-option    = 'EQ'.
  ls_filter-low       = 'S'.

  APPEND ls_filter TO lt_filter.

  "definition in (F01) VARIABLE 'go_alv_lib_papel'
   go_alv_lib_papel->set_table_for_first_display(
    EXPORTING
*      i_buffer_active               =                  " Buffering Active
*      i_bypassing_buffer            =                  " Switch Off Buffer
*      i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*      i_structure_name              =                  " Internal Output Table Structure Name
      is_variant                    =  gs_variants                " Layout
      i_save                        =  'U'                 " Save Layout
*      i_default                     = 'X'              " Default Display Variant
      is_layout                     =  gs_layout               " Layout
*      is_print                      =                  " Print Control
*      it_special_groups             =                  " Field Groups
      it_toolbar_excluding          =  gt_toolbar_excluding                " Excluded Toolbar Standard Functions
*      it_hyperlink                  =                  " Hyperlinks
*      it_alv_graphics               =                  " Table of Structure DTC_S_TC
*      it_except_qinfo               =                  " Table for Exception Quickinfo
*      ir_salv_adapter               =                  " Interface ALV Adapter
    CHANGING
      it_outtab                     = gt_libros_papel                 " Output Table
      it_fieldcatalog               = gt_fieldcat                " Field Catalog
      it_sort                       =  lt_sort                " Sort Criteria
      it_filter                     =   lt_filter              " Filter Criteria
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
*& Form refresh_table_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv_lib_papel .

  go_alv_lib_papel->refresh_table_display(
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
*& Form free_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_container .
  "check if the object is instantiated
  IF go_custom_container IS BOUND. " is instanciated, liberation of recurse

        go_custom_container->free(
        EXCEPTIONS
          cntl_error        = 1                " CNTL_ERROR
          cntl_system_error = 2                " CNTL_SYSTEM_ERROR
          OTHERS            = 3
      ).
      IF sy-subrc <> 0.
       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      " lock of release with the object doesn't this instantiated
      CLEAR go_custom_container. " recurse clean, verify in the 'if' with go_custom_container is bound

      " verify if this instantiated
      IF go_alv_lib_papel IS BOUND.

        CLEAR go_alv_lib_papel.

      ENDIF.

      IF go_event_alv_grid IS BOUND.  " local class reference in TOP
         CLEAR go_event_alv_grid.
      ENDIF.

      IF go_salv_table IS BOUND.
        CLEAR go_salv_table.
      ENDIF.

      IF go_salv_hier_cat_lib IS BOUND.
        CLEAR go_salv_hier_cat_lib.
      ENDIF.

      IF go_salv_tree_cat_lib_cli IS BOUND.
        CLEAR go_salv_tree_cat_lib_cli.
      ENDIF.

      IF go_gui_tree_acc_cat_lib is BOUND.
        clear go_gui_tree_acc_cat_lib.
      ENDIF.

      clear: gt_fieldcat,
             gt_gui_tree_fieldcat.

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

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_layout .

  FIELD-SYMBOLS: <ls_fieldcat> TYPE lvc_s_fcat,
                 <ls_libros>   TYPE gty_libros_papel.
 " modify in form 'display_alv_lib_papel'  method 'display_alv_lib_papel' ->'is_layout' add our variable gs_layout

  DATA ls_style TYPE lvc_s_styl.

  gs_layout-edit  = abap_true.
  gs_layout-zebra = abap_true.
  gs_layout-stylefname = 'FIELD_STYLE'.
  gs_layout-cwidth_opt = abap_true.

      LOOP AT gt_fieldcat ASSIGNING <ls_fieldcat> WHERE key = abap_true.

     LOOP AT gt_libros_papel ASSIGNING <ls_libros>.
         ls_style-fieldname = <ls_fieldcat>-fieldname.
         ls_style-style = cl_gui_alv_grid=>mc_style_disabled.
         INSERT ls_style INTO TABLE <ls_libros>-field_style.
     ENDLOOP.

     ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_GRID_HANDLERS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_alv_grid_handlers .

  IF go_event_alv_grid IS NOT BOUND.  " if object not initial, one time creation

    CREATE OBJECT go_event_alv_grid. " create object <- relative

    SET HANDLER: go_event_alv_grid->handle_data_changed                  FOR go_alv_lib_papel, " 'go_alv_lib_papel' instance of standar object notify class 'go_event_receiver'
                 go_event_alv_grid->handle_double_click                  FOR go_alv_lib_papel,
                 go_event_alv_grid->handle_user_command                  FOR go_alv_lib_papel,
                 go_event_alv_grid->handle_toolbar                       FOR go_alv_lib_papel,
                 go_event_alv_grid->handle_onf4                          FOR go_alv_lib_papel,
                 go_event_alv_grid->handle_data_changed_finished         FOR go_alv_lib_papel,
                 go_event_alv_grid->handle_hotspot_click                 FOR go_alv_lib_papel.

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


  ls_f4-fieldname = 'BI_CATEG'.
  ls_f4-register =  abap_true.
  APPEND ls_f4 TO lt_f4.

  go_alv_lib_papel->register_f4_for_fields( it_f4 = lt_f4 ).

  "event register 3.24
  CALL METHOD go_alv_lib_papel->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter                 " Event ID
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
*& Form set_filter_criterial
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_filter_criterial .

" is necesary events
*  data: lt_filter type lvc_t_filt,
*        ls_filter type lvc_s_filt.
*
*  ls_filter-fieldname = 'IDIOMA'.
*  ls_filter-sign      = 'I'.
*  ls_filter-option    = 'EQ'.
*  ls_filter-low       = 'S'.
*
*  APPEND ls_filter to lt_filter.
*
*  go_alv_lib_papel->set_filter_criteria(
*    EXPORTING
*      it_filter                 =    lt_filter              " Filter Conditions
*    EXCEPTIONS
*      no_fieldcatalog_available = 1                " Instance Variable of Field Catalog not yet Set
*      others                    = 2
*  ).
*  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_alv_grid_variants
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_alv_grid_variants .

  gs_variants-report   = sy-repid.
  gs_variants-username = sy-uname.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form exclude_toolbar_functions
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM exclude_alv_grid_toolbar.


  DATA lv_exclude TYPE ui_func.

  lv_exclude = cl_gui_alv_grid=>mc_fc_info.
  APPEND lv_exclude TO gt_toolbar_excluding.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_alv_grid_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_alv_grid_header .

  DATA: lo_doc_cabec    TYPE REF TO cl_dd_document,
        lv_text         TYPE sdydo_text_element,
        lv_no_libros    TYPE i,
        lv_no_lib_char  TYPE string.


  CREATE OBJECT lo_doc_cabec.

  CONCATENATE 'Bienvenido ' sy-uname INTO lv_text SEPARATED BY space.

  lo_doc_cabec->add_text_as_heading(
    EXPORTING
      text          =  lv_text                " Single Text, Up To 255 Characters Long
*      sap_color     =                  " Not Release 99
*      sap_fontstyle =                  " Not Release 99
      heading_level = 1                " Valid: 1 to 6
*      a11y_tooltip  =                  " A11Y: Additional Explanation
*    CHANGING
*      document      =                  " x
  ).


  DESCRIBE TABLE gt_libros_papel LINES lv_no_libros.

  lv_no_lib_char = lv_no_libros.

  CONCATENATE 'N° de libros de papel disponibles ' lv_no_lib_char INTO lv_text SEPARATED BY space.

  lo_doc_cabec->add_text(
    EXPORTING
      text          =  lv_text                " Single Text, Up To 255 Characters Long
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

  lo_doc_cabec->new_line( ).

  WRITE sy-timlo ENVIRONMENT TIME FORMAT TO lv_text.

  lo_doc_cabec->add_text(
    EXPORTING
      text          =  lv_text                " Single Text, Up To 255 Characters Long
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
*& Form libros_electronicos
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM libros_electronicos .

IF go_custom_container IS NOT BOUND.

  PERFORM get_data.

  PERFORM instance_cust_cont USING 'E'.

  PERFORM instance_salv.

  PERFORM enable_salv_functions.

  PERFORM set_salv_events.

  PERFORM change_salv_layout.

  PERFORM change_salv_columns.

  PERFORM add_salv_aggregations.

  PERFORM add_salv_sorts.

  PERFORM add_salv_filters.

  PERFORM add_salv_colors.

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

 TRY.
  cl_salv_table=>factory(
    EXPORTING
*      list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
      r_container    =  go_custom_container                         " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table   =  go_salv_table                         " Basis Class Simple ALV Tables
    CHANGING
      t_table        = gt_libros_ele
  ).
  CATCH cx_salv_msg. " ALV: General Error Class with Message
  MESSAGE 'ERROR' TYPE 'E'.
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

  go_salv_table->display( ). " connection in instance_salv

ENDFORM.
*&---------------------------------------------------------------------*
*& Form enable_salv_functions
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM enable_salv_functions .

  DATA: lo_function TYPE REF TO cl_salv_functions_list,
        lv_name     TYPE salv_de_function,
        lv_icon     TYPE string,
        lv_tooltip  TYPE string.

  lv_name    = 'TOTAL'.
  lv_icon    = icon_apple_numbers.
  lv_tooltip = 'N° total de libros electricos'.

  lo_function = go_salv_table->get_functions( ).

  lo_function->set_all(
      value = if_salv_c_bool_sap=>true
  ).

  TRY.

    lo_function->add_function(
      EXPORTING
        name     = lv_name                  " ALV Function
        icon     = lv_icon
*        text     =
        tooltip  = lv_tooltip
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

  CREATE OBJECT go_salv_event. " creation of object

  lo_events = go_salv_table->get_event( ).

  SET HANDLER go_salv_event->handle_added_function FOR lo_events. "local class -><- standar object

  ENDIF. " in free container -> clear

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_SALV_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_salv_layout .

  DATA: lo_salv_layout TYPE REF TO cl_salv_layout,
        ls_key         TYPE salv_s_layout_key,
        lv_variant     TYPE slis_vari.

  lo_salv_layout = go_salv_table->get_layout( ).

  ls_key-report = sy-repid.

  ls_key-logical_group = 'LIE'.

  lo_salv_layout->set_save_restriction(
      value = if_salv_c_layout=>restrict_none
  ).

  lv_variant = 'DEFAULT'.

  lo_salv_layout->set_initial_layout( value = lv_variant ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_SALV_COLUMNS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_salv_columns .

  DATA: lo_columns    TYPE REF TO cl_salv_columns_table,
        lo_sng_column TYPE REF TO cl_salv_column.

  lo_columns = go_salv_table->get_columns( ).

  lo_columns->set_optimize(
      value = abap_true
  ).

   TRY.
   lo_sng_column = lo_columns->get_column( columnname = 'MANDT' ). " name field of db
   lo_sng_column->set_visible( " call method 'set visible' value true or false
       value = if_salv_c_bool_sap=>false
   ).
 CATCH cx_salv_not_found . " ALV: General Error Class (Checked in Syntax Check)
   MESSAGE 'ERROR' TYPE 'I'.
 ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_SALV_AGGREGATIONS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_salv_aggregations .

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
  lo_aggregations->set_aggregation_before_items( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_salv_sorts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_salv_sorts .

  DATA: lo_sorts TYPE REF TO cl_salv_sorts,
        lo_sort  TYPE REF TO cl_salv_sort.

  lo_sorts = go_salv_table->get_sorts( ).
TRY.
  lo_sorts->add_sort(
    EXPORTING
      columnname =  'AUTOR'                          " ALV Control: Field Name of Internal Table Field
*      position   =
      sequence   = if_salv_c_sort=>sort_up    " Sort Sequence
      subtotal   = if_salv_c_bool_sap=>true  " Boolean Variable (X=True, Space=False)
*      group      = if_salv_c_sort=>group_none " Control Break
*      obligatory = if_salv_c_bool_sap=>false  " Boolean Variable (X=True, Space=False)
    RECEIVING
      value      = lo_sort                           " ALV Sort Settings
  ).
  CATCH cx_salv_not_found.  " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_existing.   " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)
ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_salv_filters
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_salv_filters .

  DATA: lo_filters TYPE REF TO cl_salv_filters,
        lo_filter  TYPE REF TO cl_salv_filter.

  lo_filters = go_salv_table->get_filters( ).
TRY.
  lo_filters->add_filter(
    EXPORTING
      columnname = 'IDIOMA'                 " ALV Control: Field Name of Internal Table Field
      sign       = 'I'              " Selection Condition Sign
      option     = 'EQ'             " Selection Condition Option
      low        = 'S'                 " Lower Value of Selection Condition
*      high       =                  " Upper Value of Selection Condition
*    RECEIVING
*      value      =                  " ALV Filter Settings
  ).
  CATCH cx_salv_not_found.  " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)
  CATCH cx_salv_existing.   " ALV: General Error Class (Checked in Syntax Check)
ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_salv_colors
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_salv_colors .

  DATA: lo_columns TYPE REF TO cl_salv_columns_table,
        lo_column  TYPE REF TO cl_salv_column_table,
        lc_bool    TYPE abap_bool,
        ls_color_all TYPE lvc_s_scol.

  FIELD-SYMBOLS <ls_lib_ele> TYPE gty_lib.

   lo_columns = go_salv_table->get_columns( ).

   LOOP AT gt_libros_ele ASSIGNING <ls_lib_ele>.

      IF <ls_lib_ele>-moneda = 'USD'.

            ls_color_all-color-col = 7.
            ls_color_all-color-int = 0.
            ls_color_all-color-inv = 0.
            lc_bool = abap_true.

      ELSEIF <ls_lib_ele>-moneda = 'EUR'.

            ls_color_all-color-col = 7.
            ls_color_all-color-int = 0.
            ls_color_all-color-inv = 1.
            lc_bool = abap_true.

      ENDIF.


  IF lc_bool EQ lc_bool.
    APPEND ls_color_all TO <ls_lib_ele>-t_color.
    CLEAR ls_color_all.
  ENDIF.

   ENDLOOP.

TRY.
  lo_columns->set_color_column( value = 'T_COLOR' ). "NAME COLUMN
  CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)
ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_cat_lib
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_cat_lib .

  DATA: lt_cond_tab     TYPE TABLE OF hrcond,
        ls_cond_tab     TYPE hrcond,
        lt_where_clause TYPE TABLE OF string.

  IF NOT zbi_cat_logali-bi_categ IS INITIAL.

    ls_cond_tab-field = 'BI_CATEG'.
    ls_cond_tab-opera = 'EQ'.
    ls_cond_tab-low   = zbi_cat_logali-bi_categ.
    APPEND ls_cond_tab TO lt_cond_tab.

  ENDIF.

  IF NOT lt_cond_tab IS INITIAL.

    CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
      EXPORTING
        dbtable         = 'ZBI_CAT_LOGALI'                 " Database Table
      TABLES
        condtab         = lt_cond_tab                 " Condition Table
        where_clause    = lt_where_clause                  " Where Clause
      EXCEPTIONS
        empty_condtab   = 1
        no_db_field     = 2
        unknown_db      = 3
        wrong_condition = 4
        OTHERS          = 5
      .
    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
   ENDIF.

  IF NOT lt_where_clause IS INITIAL .

    SELECT * FROM zbi_cat_logali INTO TABLE gt_hier_cat WHERE (lt_where_clause).

  ELSE.

     SELECT * FROM zbi_cat_logali INTO TABLE gt_hier_cat.

  ENDIF.

  IF sy-subrc EQ 0.

     SELECT * FROM zbi_lib_logali INTO TABLE gt_hier_lib
     FOR ALL ENTRIES IN gt_hier_cat WHERE bi_categ EQ gt_hier_cat-bi_categ.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form categorias_libros
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM categorias_libros .

  IF NOT go_salv_hier_cat_lib IS BOUND.

    PERFORM get_data.

    PERFORM build_salv_hier.

    PERFORM enable_salv_hier_func.

    PERFORM config_salv_hier_col.

    PERFORM enable_salv_hierseq_events.

    PERFORM create_salv_hier_top_end.

  ENDIF.

  PERFORM display_salv_hier.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_salv_hier
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_salv_hier .

  DATA: lt_binding TYPE salv_t_hierseq_binding,
        ls_binding TYPE salv_s_hierseq_binding.

  ls_binding-master = 'MANDT'.
  ls_binding-slave   = 'MANDT'.
  APPEND ls_binding TO lt_binding.

  ls_binding-master = 'BI_CATEG'.
  ls_binding-slave = 'BI_CATEG'.
  APPEND ls_binding TO lt_binding.

TRY.
   cl_salv_hierseq_table=>factory(
     EXPORTING
       t_binding_level1_level2 = lt_binding                 " Binding Between Two Tables
     IMPORTING
       r_hierseq               = go_salv_hier_cat_lib                 " Sequential ALV Tables
     CHANGING
       t_table_level1          = gt_hier_cat
       t_table_level2          = gt_hier_lib
   ).
   CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)
   CATCH cx_salv_not_found.  " ALV: General Error Class (Checked in Syntax Check)
ENDTRY.

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

  go_salv_hier_cat_lib->display( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ENABLE_SALV_HIER_FUNC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM enable_salv_hier_func .

  go_salv_hier_cat_lib->get_functions( )->set_all(
      value = if_salv_c_bool_sap=>true
  ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CONFIG_SALV_HIER_COL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM config_salv_hier_col .

  DATA: lo_columns TYPE REF TO cl_salv_columns_hierseq,
        lo_column  TYPE REF TO cl_salv_column_hierseq,
        lo_level   TYPE REF TO cl_salv_hierseq_level.

  TRY.
      " NIVEL 1 - CABECERA
      lo_columns = go_salv_hier_cat_lib->get_columns( level = 1 ).

      lo_column ?= lo_columns->get_column( columnname = 'MANDT' ).
      lo_column->set_technical(
          value = if_salv_c_bool_sap=>true
      ).

      lo_columns->set_expand_column( value = 'DESCRIPCION' ).

      lo_level = go_salv_hier_cat_lib->get_level( level = 1 ).
      lo_level->set_items_expanded(
          value = if_salv_c_bool_sap=>true
      ).

      lo_columns = go_salv_hier_cat_lib->get_columns( level = 1 ).

      lo_column ?= lo_columns->get_column( columnname = 'MANDT' ).
      lo_column->set_technical(
          value = if_salv_c_bool_sap=>true
      ).

      " NIVEL 2 - ITEMS
      lo_columns = go_salv_hier_cat_lib->get_columns( level = 2 ).

      lo_column ?= lo_columns->get_column( columnname = 'MANDT' ).
      lo_column->set_technical(
          value = if_salv_c_bool_sap=>true
      ).

      lo_column ?= lo_columns->get_column( columnname = 'ID_LIBRO' ).
      lo_column->set_visible(
          value = if_salv_c_bool_sap=>false
      ).

      lo_column ?= lo_columns->get_column( columnname = 'TITULO' ).
      lo_column->set_cell_type(
          value = if_salv_c_cell_type=>hotspot
      ).

    CATCH cx_salv_not_found.
    CATCH cx_salv_data_error.
ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form enable_salv_hierseq_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM enable_salv_hierseq_events .

       DATA lo_hier_events TYPE REF TO cl_salv_events_hierseq.
       CREATE OBJECT go_salv_event_hierseq.
       lo_hier_events = go_salv_hier_cat_lib->get_event( ).
       SET HANDLER go_salv_event_hierseq->handle_link_click FOR lo_hier_events.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_SALV_HIER_TOP_END
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_salv_hier_top_end .

    DATA: lo_header TYPE REF TO cl_salv_form_layout_grid,
          lo_end TYPE REF TO cl_salv_form_layout_grid,
          lo_label  TYPE REF TO cl_salv_form_label,
          lo_flow   TYPE REF TO cl_salv_form_layout_flow,
          lv_text   TYPE string,
          lv_number TYPE i.

  CREATE OBJECT: lo_header, lo_end.

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

  CONCATENATE 'BIENVENIDO' sy-uname INTO lv_text SEPARATED BY space.
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

  DESCRIBE TABLE gt_hier_lib LINES lv_number.
  lv_text = lv_number.
  CONCATENATE 'N° de libros disponibles ' lv_text INTO lv_text SEPARATED BY space.

  lo_flow->create_text( text = lv_text ).

  go_salv_hier_cat_lib->set_top_of_list( value = lo_header ). " show


  " flow
   lo_flow = lo_end->create_flow(
    EXPORTING
      row     = 3                 " Natural Number
      column  = 1                 " Natural Number
*      rowspan =
*      colspan =
*    RECEIVING
*      r_value =
  ).

      CLEAR: lv_text, lv_number.

   DESCRIBE TABLE gt_hier_cat LINES lv_number. " this gt_hier_cat
  lv_text = lv_number.
  CONCATENATE 'N° de libros disponibles ' lv_text INTO lv_text SEPARATED BY space.

  lo_flow->create_text( text = lv_text ).
  go_salv_hier_cat_lib->set_end_of_list( value = lo_end ).



ENDFORM.
*&---------------------------------------------------------------------*
*& Form categorias_libros_clientes
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM categorias_libros_clientes .

      PERFORM instance_cust_cont USING 'C'. " creation container

      PERFORM build_salv_tree.

      PERFORM build_salv_tree_header.

      PERFORM get_salv_tree_data.

      PERFORM set_salv_tree_nodes.

      PERFORM config_salv_tree_col.

      PERFORM display_salv_tree .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_SALV_TREE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_salv_tree .

DATA it_mmc_tree TYPE TABLE OF zco_ma_mo_cl_tree.

   TRY.
    cl_salv_tree=>factory(
      EXPORTING
        r_container = go_custom_container
*        hide_header =
      IMPORTING
        r_salv_tree = go_salv_tree_cat_lib_cli
      CHANGING
        t_table     = gt_temp_cat_lib_cli
    ).
    CATCH cx_salv_error.
   ENDTRY.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_SALV_TREE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_salv_tree .

  go_salv_tree_cat_lib_cli->display( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_SALV_TREE_HEADER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_salv_tree_header .

  DATA lo_settings TYPE REF TO cl_salv_tree_settings.

  lo_settings = go_salv_tree_cat_lib_cli->get_tree_settings( ).
  "assing name column
  lo_settings->set_hierarchy_header( value = 'REGISTROS' ).

  lo_settings->set_hierarchy_tooltip( value = 'DESPLIEGUE DE NODOS'  ).
  lo_settings->set_hierarchy_size( value = 60 ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_SALV_TREE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_salv_tree_data .

 SELECT a~bi_categ a~descripcion titulo b~id_libro b~titulo b~autor b~editoral
         c~id_cliente c~nombre c~apellidos c~email
    FROM zbi_cat_logali AS a INNER JOIN zbi_lib_logali AS b ON a~bi_categ EQ b~bi_categ
    INNER JOIN zbi_c_l_logali AS z ON z~id_libro EQ b~id_libro
    INNER JOIN zbi_cln_logali AS c ON z~id_cliente EQ c~id_cliente
    INTO CORRESPONDING FIELDS OF TABLE gt_cat_lib_cli
    ORDER BY a~bi_categ b~id_libro.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SALV_TREE_NODES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_salv_tree_nodes .

    DATA: lo_nodes TYPE REF TO cl_salv_nodes,
          lo_node TYPE REF TO cl_salv_node.

     DATA: lv_text TYPE lvc_value,
            lv_key_categ TYPE salv_de_node_key,
            lv_key_lib TYPE salv_de_node_key.

     FIELD-SYMBOLS <ls_cat_lib_cli> TYPE zbi_cat_lib_cli_logali.

     lo_nodes = go_salv_tree_cat_lib_cli->get_nodes( ).

     LOOP AT gt_cat_lib_cli ASSIGNING <ls_cat_lib_cli>.

     ON CHANGE OF <ls_cat_lib_cli>-bi_categ.

     lv_text = <ls_cat_lib_cli>-descripcion.

 TRY.

     lo_node = lo_nodes->add_node( related_node = space " Key to Related Node
     relationship = if_salv_c_node_relation=>parent " Node Relation in Tree
     text = lv_text " ALV Control: Cell Content
     expander = abap_true "Boolean Variable (X=True, Space=False)
     folder = abap_true "Boolean Variable (X=True, Space=False)
     ).

 CATCH cx_salv_msg.

 ENDTRY.

 lv_key_categ = lo_node->get_key( ).

 ENDON.

 ON CHANGE OF <ls_cat_lib_cli>-id_libro.

 lv_text = <ls_cat_lib_cli>-titulo.

 TRY.

     lo_node = lo_nodes->add_node( related_node = lv_key_categ " Key to Related Node
     relationship = if_salv_c_node_relation=>last_child " Node Relation in Tree
     text = lv_text " ALV Control: Cell Content
     expander = abap_true "Boolean Variable (X=True, Space=False)
     folder = abap_true "Boolean Variable (X=True, Space=False)
     ).
     CATCH cx_salv_msg.
     ENDTRY.
     lv_key_lib = lo_node->get_key( ).
 ENDON.

  lv_text = <ls_cat_lib_cli>-id_cliente.
   TRY.
     lo_node = lo_nodes->add_node(
                 related_node   = lv_key_lib
                 relationship   = if_salv_c_node_relation=>last_child
                 data_row       = <ls_cat_lib_cli>
*                 collapsed_icon =
*                 expanded_icon  =
*                 row_style      =
                 text           = lv_text
*                 visible        = abap_true
*                 expander       =
*                 enabled        = abap_true
*                 folder         =
               ).
*               CATCH cx_salv_msg.

   CATCH cx_salv_msg.
   ENDTRY.


 ENDLOOP.

 lo_nodes->expand_all( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CONFIG_SALV_TREE_COL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM config_salv_tree_col .

  DATA: lo_columns TYPE REF TO cl_salv_columns_tree,
        lo_column TYPE REF TO cl_salv_column.

  lo_columns = go_salv_tree_cat_lib_cli->get_columns( ).

  lo_columns->set_optimize(
      abap_true
  ).

"HIDE COLUMNS
  TRY.
  lo_column = lo_columns->get_column( columnname = 'DESCRIPCION' ).
  lo_column->set_visible( abap_false ).

  lo_column = lo_columns->get_column( columnname = 'BI_CATEG' ).
  lo_column->set_visible( abap_false ).

  lo_column = lo_columns->get_column( columnname = 'TITULO' ).
  lo_column->set_visible( abap_false ).

  lo_column = lo_columns->get_column( columnname = 'ID_CLIENTE' ).
  lo_column->set_visible( abap_false ).

  CATCH cx_salv_not_found. " ALV: General Error Class (Checked in Syntax Check)
    ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ACCESO_CATEGORIAS_LIBROS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM acceso_categorias_libros .

  IF not go_gui_tree_acc_cat_lib is bound.

  PERFORM instance_cust_cont USING 'A'.

  PERFORM build_gui_tree.

  PERFORM build_gui_tree_header.

  PERFORM build_gui_tree_fieldcat.

  PERFORM set_gui_tree_first_display.

  PERFORM SET_GUI_TREE_DRAG_DROp.

  PERFORM gui_tree_add_favourit.

  PERFORM get_gui_tree_data.

  PERFORM set_gui_tree_nodes.

   PERFORM SET_GUI_TREE_EVENTS.

  PERFORM gui_tree_frontend_update.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_GUI_TREE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_gui_tree .

  CREATE OBJECT go_gui_tree_acc_cat_lib
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
      OTHERS                      = 8
    .
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_GUI_TREE_HEADER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_gui_tree_header .

  gs_gui_tree_header-heading = 'REGISTRO'.
  gs_gui_tree_header-tooltip = 'DESPLIEGUE LOS NODOS'.
  gs_gui_tree_header-width   = 65.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_GUI_TREE_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_gui_tree_fieldcat .

  FIELD-SYMBOLS <ls_fieldcat> TYPE lvc_s_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
   EXPORTING
*     I_BUFFER_ACTIVE              =
     i_structure_name             = 'ZBI_ACC_CAT_LIB_LOGALI'
*     I_CLIENT_NEVER_DISPLAY       = 'X'
*     I_BYPASSING_BUFFER           =
*     I_INTERNAL_TABNAME           =
    CHANGING
      ct_fieldcat                  = gt_gui_tree_fieldcat
   EXCEPTIONS
     inconsistent_interface       = 1
     program_error                = 2
     OTHERS                       = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF.

  LOOP AT gt_fieldcat ASSIGNING <ls_fieldcat>.

    IF  <ls_fieldcat>-fieldname = 'TIPO_ACCESO' OR
        <ls_fieldcat>-fieldname = 'DESC_ACCESO' OR
        <ls_fieldcat>-fieldname = 'BI_CATEG' OR
        <ls_fieldcat>-fieldname = 'ID_LIBRO' OR
        <ls_fieldcat>-fieldname = 'DESCRIPCION'.

      <ls_fieldcat>-no_out = abap_true.

    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GUI_TREE_FIRST_DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_gui_tree_first_display .

  go_gui_tree_acc_cat_lib->set_table_for_first_display(
    EXPORTING
      is_hierarchy_header     = gs_gui_tree_header
    CHANGING
      it_outtab            = gt_temp_acc_cat_lib
      it_fieldcatalog      = gt_gui_tree_fieldcat
  ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GUI_TREE_FRONTEND_UPDATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gui_tree_frontend_update .

  go_gui_tree_acc_cat_lib->frontend_update( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_GUI_TREE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_gui_tree_data .

   DATA: lt_values TYPE STANDARD TABLE OF dd07v,
        ls_value  TYPE dd07v,
        lv_found  TYPE i.

  FIELD-SYMBOLS <ls_acc> TYPE zbi_acc_cat_lib_alfal3.

  IF zbi_cln_logali-tipo_acceso IS NOT INITIAL.
    SELECT a_c~tipo_acceso
           cat~bi_categ
           cat~descripcion
           lib~id_libro
           lib~titulo
           lib~autor
           lib~editorial
         FROM zbi_a_c_alfal3 AS a_c
           INNER JOIN zbi_cat_alfal3 AS cat
             ON a_c~bi_categ EQ cat~bi_categ
           INNER JOIN zbi_lib_alfal3 AS lib
             ON cat~bi_categ EQ lib~bi_categ
         INTO CORRESPONDING FIELDS OF TABLE gt_acc_cat_lib
         WHERE a_c~tipo_acceso EQ zbi_cln_logali-tipo_acceso.
  ELSE.
    SELECT a_c~tipo_acceso
           cat~bi_categ
           cat~descripcion
           lib~id_libro
           lib~titulo
           lib~autor
           lib~editorial
         FROM zbi_a_c_alfal3 AS a_c
           INNER JOIN zbi_cat_alfal3 AS cat
             ON a_c~bi_categ EQ cat~bi_categ
           INNER JOIN zbi_lib_alfal3 AS lib
             ON cat~bi_categ EQ lib~bi_categ
         INTO CORRESPONDING FIELDS OF TABLE gt_acc_cat_lib.
  ENDIF.

  IF sy-subrc EQ 0.

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = 'ZBI_TIPO_ACCESO'
        text           = 'X'
        langu          = 'E'
*       BYPASS_BUFFER  = ' '
      IMPORTING
        rc             = lv_found
      TABLES
        dd07v_tab      = lt_values
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF lv_found EQ 0.

        LOOP AT gt_acc_cat_lib ASSIGNING <ls_acc>.
            READ TABLE lt_values INTO ls_value WITH KEY domvalue_l = <ls_acc>-tipo_acceso.
            IF sy-subrc EQ 0.
                <ls_acc>-desc_acceso = ls_value-ddtext.
            ENDIF.
        ENDLOOP.

    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form SET_GUI_TREE_NODES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_gui_tree_nodes .

  FIELD-SYMBOLS <ls_acc_cat_lib> TYPE zbi_acc_cat_lib_logali.

   DATA: lv_text   TYPE lvc_value,
          ls_node_lay TYPE lvc_s_layn,
          lv_node_text TYPE lvc_value,
          lv_acc_key TYPE lvc_nkey,
          lv_cat_key TYPE lvc_nkey,

          ls_acc      TYPE zbi_acc_cat_lib_logali.

    LOOP AT gt_acc_cat_lib ASSIGNING <ls_acc_cat_lib>.

        ON CHANGE OF <ls_acc_cat_lib>-tipo_acceso. "ls_acc-tipo_acceso.

        ls_node_lay-expander = abap_true.
        ls_node_lay-isfolder = abap_true.
*            lv_text = ls_acc-desc_acceso.
        lv_node_text =  <ls_acc_cat_lib>-desc_acceso.
            go_gui_tree_acc_cat_lib->add_node(
              EXPORTING
                i_relat_node_key     = space
                i_relationship       = cl_gui_column_tree=>relat_last_child
*                is_outtab_line       =
                is_node_layout       = ls_node_lay
*                it_item_layout       =
                i_node_text          = lv_node_text "lv_text
              IMPORTING
                e_new_node_key       = lv_acc_key
              EXCEPTIONS
                relat_node_not_found = 1
                node_not_found       = 2
                OTHERS               = 3
            ).
            IF sy-subrc <> 0.
             MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF.
        ENDON.

        ON CHANGE OF <ls_acc_cat_lib>-bi_categ. "ls_acc-bi_categ.

        ls_node_lay-isfolder = abap_true.
        ls_node_lay-expander = abap_true.

            lv_text = <ls_acc_cat_lib>-descripcion. "ls_acc-descripcion.

            go_gui_tree_acc_cat_lib->add_node(
              EXPORTING
                i_relat_node_key     = lv_acc_key
                i_relationship       = cl_gui_column_tree=>relat_last_child
*                is_outtab_line       =
                is_node_layout       = ls_node_lay
*                it_item_layout       =
                i_node_text          = lv_text
              IMPORTING
                e_new_node_key       = lv_cat_key
              EXCEPTIONS
                relat_node_not_found = 1
                node_not_found       = 2
                OTHERS               = 3
            ).
            IF sy-subrc <> 0.
             MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF.
        ENDON.

   " --------

        lv_node_text = <ls_acc_cat_lib>-id_libro.

        CLEAR ls_node_lay.

        ls_node_lay-dragdropid = gv_fav_line_id.

*        lv_text = ls_acc-id_libro.
        go_gui_tree_acc_cat_lib->add_node(
          EXPORTING
            i_relat_node_key     = lv_cat_key
            i_relationship       = cl_gui_column_tree=>relat_last_child
            is_outtab_line       = <ls_acc_cat_lib> "ls_node_lay
            is_node_layout       = ls_node_lay
            i_node_text          = lv_text
          EXCEPTIONS
            relat_node_not_found = 1
            node_not_found       = 2
            OTHERS               = 3
        ).
        IF sy-subrc <> 0.
         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        clear ls_node_lay.

    ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GUI_TREE_ADD_FAVOURIT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gui_tree_add_favourit .

  DATA: ls_node_layout TYPE lvc_s_layn,
      lv_node_text   TYPE lvc_value.

ls_node_layout-dragdropid = GV_FAV_FOLDER_ID. " error -correct
ls_node_layout-isfolder = abap_true.
ls_node_layout-n_image = icon_system_favorites.

lv_node_text = 'FAVORITOS'.

go_gui_tree_acc_cat_lib->add_node(
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
    OTHERS               = 3
).
IF sy-subrc <> 0.
 MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GUI_TREE_DRAG_DROp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_GUI_TREE_DRAG_DROp .

  data lv_effect type i.

  create object: go_line_behaviour.

  lv_effect = cl_dragdrop=>copy.

  go_line_behaviour->add(
    EXPORTING
      flavor          = 'FAVORIT'                 " Name of Class/Type
      dragsrc         = ABAP_TRUE                 " ? DragSource
      droptarget      = SPACE                 " ? DropTarget
      effect          = lv_effect "cl_dragdrop=>copy             " ? Move/Copy
*      effect_in_ctrl  = usedefaulteffect " ? Default Behavior for Drag and Drop Within a Control
    EXCEPTIONS
      already_defined = 1                " Behavior Already Contains the Specified Name
      obj_invalid     = 2                " Object Already Invalidated by Destroy
      others          = 3
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  GO_LINE_BEHAVIOUR->get_handle(
    IMPORTING
      handle      =  gv_fav_line_id              " Behavior Handle
    EXCEPTIONS
      obj_invalid = 1                " Object Already Destroyed
      others      = 2
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  create object GO_FAV_BEHAVIOUR.

  lv_effect = cl_dragdrop=>copy.

  GO_FAV_BEHAVIOUR->add(
    EXPORTING
      flavor          = 'FAVORIT'                 " Name of Class/Type
      dragsrc         = SPACE                 " ? DragSource
      droptarget      = ABAP_TRUE                 " ? DropTarget
      effect          = lv_effect "cl_dragdrop=>copy             " ? Move/Copy
*      effect_in_ctrl  = usedefaulteffect " ? Default Behavior for Drag and Drop Within a Control
    EXCEPTIONS
      already_defined = 1                " Behavior Already Contains the Specified Name
      obj_invalid     = 2                " Object Already Invalidated by Destroy
      others          = 3
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  GO_FAV_BEHAVIOUR->get_handle(
    IMPORTING
      handle      = gv_fav_folder_id  " Behavior Handle
    EXCEPTIONS
      obj_invalid = 1                " Object Already Destroyed
      others      = 2
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_GUI_TREE_EVENTS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_gui_tree_events .

  create object go_gui_tree_events.

  set handler go_gui_tree_events->handle_on_drag for GO_GUI_TREE_ACC_CAT_LIB.

  set handler go_gui_tree_events->handle_on_drop for GO_GUI_TREE_ACC_CAT_LIB.

ENDFORM.
