*&---------------------------------------------------------------------*
*& Include          ZBI_VIRT_ALFA02_CL
*&---------------------------------------------------------------------*

CLASS lcl_event_alv_grid DEFINITION.

  PUBLIC SECTION.
  " standard class cl_gui_alv_grid

   METHODS handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
                                                      IMPORTING e_column
                                                                e_row
                                                                es_row_no.

  METHODS handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
                                                     IMPORTING er_data_changed
                                                               e_onf4
                                                               e_onf4_before
                                                               e_onf4_after
                                                               e_ucomm.

  METHODS handle_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
                                                                       IMPORTING e_modified
                                                                       et_good_cells.

  METHODS handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
                                                     IMPORTING e_ucomm.

  METHODS handle_toolbar FOR EVENT toolbar OF  cl_gui_alv_grid
                                           IMPORTING e_object
                                                     e_interactive.

  METHODS handle_onf4 FOR EVENT onf4 OF cl_gui_alv_grid
                                     IMPORTING  e_fieldname   "name column -->F04
                                                e_fieldvalue
                                                es_row_no
                                                er_event_data " data modification standard
                                                et_bad_cells
                                                e_display.

  METHODS handle_hotspot_click FOR EVENT hotspot_click
                               OF cl_gui_alv_grid
                               IMPORTING e_column_id
                                         e_row_id
                                         es_row_no.


ENDCLASS.


CLASS lcl_event_alv_grid IMPLEMENTATION.

  METHOD handle_double_click.

    DATA: lt_values TYPE TABLE OF dd07v,
          ls_values TYPE dd07v,
          ls_libros TYPE gty_libros_papel,
          lv_tipo_acceso TYPE zbi_tipo_acceso.

    CASE e_column.

    WHEN 'BI_CATEG'.

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        =  'ZBI_TIPO_ACCESO'                " Domain name
        text           = abap_true            " Default ' ': without texts, 'X': with, 'T': only text
*        langu          = space            " Language, default SY-LANGU, '*': all texts
*        bypass_buffer  = space
*      IMPORTING
*        rc             =
      TABLES
        dd07v_tab      = lt_values
      EXCEPTIONS
        wrong_textflag = 1                " Incorrect value in TEXT: Parameter (<> X, T ,'')
        OTHERS         = 2
      .
    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    READ TABLE gt_libros_papel INTO ls_libros INDEX es_row_no-row_id.

     IF sy-subrc EQ 0.
       SELECT SINGLE tipo_acceso FROM zbi_a_c_logali INTO lv_tipo_acceso
                     WHERE bi_categ EQ ls_libros-bi_categ.

       IF sy-subrc EQ 0.

          READ TABLE lt_values INTO ls_values
          WITH KEY domvalue_l = lv_tipo_acceso.
       IF sy-subrc EQ 0.

       MESSAGE i000(zbi_msg) WITH ls_values-ddtext.

       ENDIF.

       ENDIF.
     ENDIF.

    WHEN ''.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD handle_data_changed_finished.

     FIELD-SYMBOLS <ls_libros> TYPE gty_libros_papel.

     DATA ls_good_cells TYPE lvc_s_modi.

     CHECK e_modified EQ abap_true.

     LOOP AT et_good_cells INTO ls_good_cells.

     READ TABLE gt_libros_papel ASSIGNING <ls_libros> INDEX ls_good_cells-row_id.

     IF sy-subrc EQ 0.

     <ls_libros>-bbdd = abap_true.
     ENDIF.

     ENDLOOP.

 ENDMETHOD.

 "exercise 3.32
 METHOD handle_hotspot_click.

   DATA: lt_cln TYPE TABLE OF zbi_cln_logali,
         ls_c_l TYPE gty_libros_papel.

   CASE e_column_id.

   	WHEN 'ID_LIBRO'.

      READ TABLE gt_libros_papel INTO ls_c_l INDEX es_row_no-row_id.

      IF sy-subrc EQ 0.

          SELECT a~nombre a~apellidos a~email FROM zbi_cln_logali AS a INNER JOIN zbi_c_l_logali AS b
              ON a~id_cliente EQ b~id_cliente INTO CORRESPONDING FIELDS OF TABLE lt_cln WHERE b~id_libro
              EQ ls_c_l-id_libro.

*            cl_demo_output=>display( lt_cln ).

                  IF sy-subrc EQ 0.

                    CALL FUNCTION 'POPUP_WITH_TABLE'
                      EXPORTING
                        endpos_col         = 160
                        endpos_row         = 15
                        startpos_col       = 20
                        startpos_row       = 10
                        titletext          = TEXT-101
*                     IMPORTING
*                       CHOICE             =
                      TABLES
                        valuetab           = lt_cln
                     EXCEPTIONS
                       break_off          = 1
                       OTHERS             = 2
                              .
                    IF sy-subrc <> 0.
* Implement suitable error handling here

                      MESSAGE s003(zco_msg_alfa02) DISPLAY LIKE 'E'.

                    ENDIF.


                  ENDIF.

      ENDIF.

   	WHEN ''.

   	WHEN OTHERS.
   ENDCASE.

 ENDMETHOD.

  METHOD handle_toolbar.

    DATA ls_toolbar TYPE stb_button.

    ls_toolbar-function = 'A_SAVE'. " is the code of function

    ls_toolbar-quickinfo = 'Save'.

    ls_toolbar-icon = '@F_SAVE@'.

    APPEND ls_toolbar TO e_object->mt_toolbar. " from here we can remove options from the toolbar

  ENDMETHOD.

  METHOD handle_data_changed.

    DATA: ls_data_changed TYPE lvc_s_modi,
          lv_categ        TYPE zbi_categorias.

    LOOP AT er_data_changed->mt_good_cells INTO ls_data_changed.
      "search in of framework
      CASE ls_data_changed-fieldname.
        WHEN 'BI_CATEG'.

          er_data_changed->get_cell_value(
            EXPORTING
              i_row_id    =  ls_data_changed-row_id                " Row ID
*              i_tabix     =                  " Table Index
              i_fieldname =  ls_data_changed-fieldname                " Field Name
            IMPORTING
              e_value     =    lv_categ              " Cell Content
          ).

          SELECT SINGLE bi_categ FROM zbi_cat_logali INTO lv_categ  WHERE bi_categ EQ lv_categ.

          IF sy-subrc NE 0.

            er_data_changed->add_protocol_entry(
              EXPORTING
                i_msgid     =  'ZCO_MSG_AFA02'                " Message ID
                i_msgty     =   'E'               " Message Type
                i_msgno     =   '000'               " Message No.
                i_msgv1     =  TEXT-c01                " Message Variable1
                i_msgv2     =  lv_categ                " Message Variable2
                i_msgv3     =  TEXT-c02                 " Message Variable3
*                i_msgv4     =                  " Message Variable4
                i_fieldname =  ls_data_changed-fieldname                " Field Name
                i_row_id    =  ls_data_changed-row_id                " RowID
*                i_tabix     =                  " Table Index
            ).

          ENDIF.

        WHEN ''.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

  METHOD handle_user_command.


    DATA: lt_bbdd_libros TYPE TABLE OF zbi_lib_logali,
          ls_bbdd_libros TYPE zbi_lib_logali,
          ls_libros      TYPE gty_libros_papel.

    CASE e_ucomm.

      WHEN 'A_SAVE'. " exercise  3.28

         LOOP AT gt_libros_papel INTO ls_libros WHERE bbdd EQ abap_true. "[x]

           MOVE-CORRESPONDING ls_libros TO ls_bbdd_libros.
           APPEND ls_bbdd_libros TO lt_bbdd_libros.

         ENDLOOP.

         IF sy-subrc EQ 0.

            MODIFY zbi_lib_logali FROM TABLE lt_bbdd_libros.

            IF sy-subrc EQ 0.
              MESSAGE s001(zco_msg_alfa02).
            ENDIF.

         ENDIF.

      WHEN ''.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD handle_onf4.

    TYPES: BEGIN OF lty_cat,
      bi_categ    TYPE zbi_categorias,
      descripcion TYPE text60,
    END OF lty_cat.

    " value of the db
    DATA: lt_cat TYPE TABLE OF lty_cat,
          ls_cat TYPE lty_cat.

    "table > lt_return_tab   : table help search
    DATA: lt_return_tab TYPE TABLE OF ddshretval,
          ls_return_tab TYPE ddshretval.  "get register table

CASE e_fieldname.

  WHEN 'BI_CATEG'. "name column in db

    SELECT bi_categ descripcion FROM zbi_cat_logali INTO TABLE lt_cat  WHERE bi_categ NE space .

      IF sy-subrc EQ 0.

        CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
          EXPORTING
*            ddic_structure   = space            " Structure of VALUE_TAB (VALUE_ORG = 'S')
            retfield         =   'BI_CATEG'               " Name of return field in FIELD_TAB
*            pvalkey          = space            " Key for personal help
            dynpprog         = sy-repid            " Current program
            dynpnr           = sy-dynnr            " Screen number
            dynprofield      = 'BI_CATEG'            " Name of screen field for value return
*            stepl            = 0                " Steploop line of screen field
*            window_title     =                  " Title for the hit list
*            value            = space            " Field contents for F4 call
            value_org        = 'S'              " Value return: C: cell by cell, S: structured
*            multiple_choice  = space            " Switch on multiple selection
*            display          = space            " Override readiness for input
*            callback_program = space            " Program for callback before F4 start
*            callback_form    = space            " Form for callback before F4 start (-> long docu)
*            callback_method  =                  " Interface for Callback Routines
*            mark_tab         =                  " Defaults for Selected Lines when Multiple Selection is Switched On
*          IMPORTING
*            user_reset       =                  " Single-Character Flag
          TABLES
            value_tab        =  lt_cat                " Table of values: entries cell by cell
*            field_tab        =                  " Fields of the hit list
            return_tab       =   lt_return_tab               " Return the selected value
*            dynpfld_mapping  =                  " Assignment of the screen fields to the internal table
          EXCEPTIONS
            parameter_error  = 1                " Incorrect parameter
            no_values_found  = 2                " No values found
            OTHERS           = 3
          .
        IF sy-subrc <> 0.
         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

        ELSE.

          READ TABLE lt_return_tab INTO ls_return_tab INDEX 1.

          IF sy-subrc EQ 0.

                            " interna table with modify for the alv
            FIELD-SYMBOLS <lt_modify_data> TYPE lvc_t_modi.
            DATA ls_modify_data TYPE lvc_s_modi.


            ls_modify_data-row_id    = es_row_no-row_id. "
            ls_modify_data-fieldname = e_fieldname. " name column
            ls_modify_data-value = ls_return_tab-fieldval.  " new value

            ASSIGN er_event_data->m_data->* TO <lt_modify_data>.

            APPEND ls_modify_data TO <lt_modify_data>.

          ENDIF.

        ENDIF.

      ENDIF.

    WHEN ''.

    WHEN OTHERS.
    ENDCASE.

    er_event_data->m_event_handled = abap_true.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_events_salv_list DEFINITION.

  PUBLIC SECTION.

  METHODS handle_added_function FOR EVENT added_function OF cl_salv_events_table
                                                         IMPORTING e_salv_function.

ENDCLASS.

CLASS lcl_events_salv_list IMPLEMENTATION.

  METHOD handle_added_function.

    CASE e_salv_function.
      WHEN 'TOTAL'.
        DATA count1 TYPE i.

        SELECT COUNT(*) FROM zbi_lib_logali INTO count1 WHERE formato EQ  'E'.

        MESSAGE i003(zbi_msg) WITH count1.

      WHEN ''.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_event_salv_hierseq DEFINITION.
    PUBLIC SECTION.
        METHODS: handle_LINK_CLICK FOR EVENT link_click
                                   OF cl_salv_events_hierseq
                                   IMPORTING level
                                             column
                                             row.
ENDCLASS.


CLASS lcl_event_salv_hierseq IMPLEMENTATION.

 METHOD handle_link_click.

        DATA: lt_clientes TYPE TABLE OF gty_clientes,
              ls_clientes TYPE gty_clientes,
              ls_libros   TYPE zbi_lib_logali.

        READ TABLE gt_hier_lib INTO ls_libros INDEX row.
        IF sy-subrc EQ 0.

            SELECT a~nombre a~apellidos a~email FROM ( zbi_cln_logali AS a
                INNER JOIN zbi_c_l_logali AS b
                    ON b~id_cliente EQ a~id_cliente
                )
                INTO CORRESPONDING FIELDS OF TABLE lt_clientes
                WHERE b~id_libro EQ ls_libros-id_libro.

            IF sy-subrc EQ 0.
                CALL FUNCTION 'POPUP_WITH_TABLE'
                  EXPORTING
                    endpos_col   = 130
                    endpos_row   = 15
                    startpos_col = 20
                    startpos_row = 10
                    titletext    = TEXT-p02
                  TABLES
                    valuetab     = lt_clientes
                  EXCEPTIONS
                    break_off = 1
                    OTHERS = 2
                  .

            ELSE.
                MESSAGE i002(zbi_msg).
            ENDIF.

        ENDIF.

    ENDMETHOD.


ENDCLASS.

CLASS  lcl_drag_drop_object DEFINITION.

  PUBLIC SECTION.

  DATA: gs_data      TYPE zbi_acc_cat_lib_logali,
        gv_node_text TYPE lvc_value.

ENDCLASS.


CLASS lcl_gui_tree_events  DEFINITION.

  PUBLIC SECTION.

  METHODS: handle_on_drag FOR EVENT on_drag
                          OF cl_gui_alv_tree
                          IMPORTING sender
                                    node_key
                                    fieldname
                                    drag_drop_object,

            handle_on_drop FOR EVENT on_drop
                          OF cl_gui_alv_tree
                          IMPORTING sender
                                    node_key
                                    drag_drop_object.

ENDCLASS.

CLASS lcl_gui_tree_events IMPLEMENTATION.

  METHOD handle_on_drag.

    DATA lo_drag_drop TYPE REF TO lcl_drag_drop_object.

    CREATE OBJECT lo_drag_drop.

    sender->get_outtab_line(
      EXPORTING
        i_node_key     = node_key
      IMPORTING
        e_outtab_line  = lo_drag_drop->gs_data " line object
        e_node_text    = lo_drag_drop->gv_node_text
*        et_item_layout =
*        es_node_layout =
      EXCEPTIONS
        node_not_found = 1
        OTHERS         = 2
    ).
    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    drag_drop_object->object = lo_drag_drop.

  ENDMETHOD.

  METHOD handle_on_drop.

    DATA: lo_drag_drop   TYPE REF TO lcl_drag_drop_object,
          ls_layout_node TYPE lvc_s_layn.

  ls_layout_node-n_image = icon_system_favorites.

  CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.

  lo_drag_drop ?= drag_drop_object->object.

  go_gui_tree_acc_cat_lib->add_node(
    EXPORTING
      i_relat_node_key     = gv_fav_key                 " Node Already in Tree Hierarchy
      i_relationship       = cl_gui_column_tree=>relat_first_child   " How to Insert Node
      is_outtab_line       = lo_drag_drop->gs_data                " Attributes of Inserted Node
      is_node_layout       = ls_layout_node                 " Node Layout
*      it_item_layout       =                  " Item Layout
      i_node_text          = lo_drag_drop->gv_node_text                 " Hierarchy Node Text
*    IMPORTING
*      e_new_node_key       =                  " Key of New Node Key
    EXCEPTIONS
      relat_node_not_found = 1                " Relat Node Key not Found
      node_not_found       = 2                " Node not Found
      OTHERS               = 3
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  sender->expand_node( EXPORTING i_node_key =  gv_fav_key ).

  sender->frontend_update( ).

  ENDCATCH.

  IF sy-subrc EQ 0.

    drag_drop_object->abort( ).

  ENDIF.

  ENDMETHOD.

ENDCLASS.
