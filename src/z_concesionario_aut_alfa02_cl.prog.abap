*&---------------------------------------------------------------------*
*& Include          Z_CONCESIONARIO_AUT_ALFA02_CL
*&---------------------------------------------------------------------*
" methods for events with double click
CLASS lcl_events_receiver DEFINITION.

  PUBLIC SECTION.
  " method that acts on changes
  METHODS handle_data_changed FOR EVENT data_changed" name of method in the local class
                              OF cl_gui_alv_grid " name of event
                              IMPORTING er_data_changed
                                        e_onf4
                                        e_onf4_before
                                        e_onf4_after
                                        e_ucomm.
  " add new register
  METHODS handle_data_changed_finished FOR EVENT data_changed_finished
                                       OF cl_gui_alv_grid
                                       IMPORTING e_modified     " abap_bool
                                                 et_good_cells. " modified cells

  "
  METHODS handle_user_command FOR EVENT user_command
                              OF cl_gui_alv_grid
                              IMPORTING e_ucomm.
  "Event with gets the data column,row and row_no
  METHODS handle_double_click FOR EVENT double_click
                              OF cl_gui_alv_grid
                              IMPORTING e_column
                                        e_row      " number the row
                                        es_row_no. "

  "
  METHODS handle_toolbar FOR EVENT toolbar
                        OF  cl_gui_alv_grid
                        IMPORTING e_object
                                  e_interactive.

  METHODS handle_onf4 FOR EVENT onf4
                      OF cl_gui_alv_grid
                      IMPORTING e_fieldname   "name column
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

CLASS lcl_events_receiver IMPLEMENTATION.
" modify of data in container
  METHOD handle_data_changed.

    DATA: ls_data_changed TYPE lvc_s_modi,
          lv_marca        TYPE zlo_marca.

    LOOP AT er_data_changed->mt_good_cells INTO ls_data_changed.
      "search in of framework
      CASE ls_data_changed-fieldname.
        WHEN 'MARCA'.
          er_data_changed->get_cell_value(
            EXPORTING
              i_row_id    =     ls_data_changed-row_id            " Row ID
*              i_tabix     =                  " Table Index
              i_fieldname =     ls_data_changed-fieldname             " Field Name
            IMPORTING
              e_value     =    lv_marca              " Cell Content
          ).

        SELECT SINGLE marca FROM zco_marcas INTO lv_marca WHERE marca EQ lv_marca. " value of db lv_marca true o false

          "if the value exists it is not executed
          IF sy-subrc NE 0.

             er_data_changed->add_protocol_entry(
               EXPORTING
                 i_msgid     =  'zco_msg_Alfa02' " class message               " Message ID
                 i_msgty     =  'E'               " Message Type
                 i_msgno     =  '000'               " Message No.
                 i_msgv1     = TEXT-m01                 " Message Variable1
                 i_msgv2     =  lv_marca                 " Message Variable2, is the value get by the user
                 i_msgv3     = TEXT-m02                  " Message Variable3
*                 i_msgv4     =                  " Message Variable4
                 i_fieldname =   ls_data_changed-fieldname               " Field Name the message is value It's not valid
                 i_row_id    =   ls_data_changed-row_id                " RowID
*                 i_tabix     =                  " Table Index
             ).

          ENDIF.



        WHEN ''.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

  METHOD handle_data_changed_finished.

    DATA ls_good_cells TYPE lvc_s_modi. " see definition in data_changt_finished

    FIELD-SYMBOLS <ls_vehiculos> TYPE gty_vehiculos. " pointers

    CHECK e_modified EQ abap_true.

    LOOP AT et_good_cells INTO ls_good_cells.
      " modify record

      READ TABLE gt_vehiculos ASSIGNING <ls_vehiculos> INDEX ls_good_cells-row_id.

      IF sy-subrc EQ 0.
          "     data   -  column
          <ls_vehiculos>-bbdd = abap_true.
      ENDIF.


    ENDLOOP.

  ENDMETHOD.

"
  METHOD handle_user_command.

    " records of all data that can be modified
    DATA: lt__bbdd_vehiculos TYPE TABLE OF zco_vehiculos,
          ls_bbdd_vehiculos  TYPE zco_vehiculos,
          ls_vehiculos       TYPE gty_vehiculos.

    "fuction code
    CASE e_ucomm.

      WHEN 'A_SAVE'. " function code to save the data

        LOOP AT gt_vehiculos INTO ls_vehiculos WHERE bbdd EQ abap_true.

          MOVE-CORRESPONDING ls_vehiculos TO ls_bbdd_vehiculos.

          APPEND ls_bbdd_vehiculos TO lt__bbdd_vehiculos.

        ENDLOOP.

        IF sy-subrc EQ 0.

          MODIFY zco_vehiculos FROM TABLE lt__bbdd_vehiculos.

          IF sy-subrc EQ 0.
             MESSAGE s001(zco_msg_alfa02).
          ENDIF.

        ENDIF.

      WHEN ''.

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.
" event double click
  METHOD handle_double_click.

    DATA ls_vehiculos TYPE gty_vehiculos.

    CASE e_column.
      " when user gives double click in column 'MODELO'
      WHEN 'MODELO'.

        READ TABLE gt_vehiculos INTO ls_vehiculos INDEX es_row_no-row_id.

        IF sy-subrc EQ 0.

          CASE ls_vehiculos-combustible.
            WHEN 'ELECTRIC'.
              MESSAGE text-C01 type 'I'.
            WHEN 'HYBRID'.
              MESSAGE text-C02 type 'I'.
            WHEN 'GASOLINA'.
              MESSAGE text-C03 type 'I'.
            WHEN 'DIESEL'.
              MESSAGE text-C04 type 'I'.
            WHEN OTHERS.
          ENDCASE.

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

  METHOD handle_onf4.

  TYPES: BEGIN OF lty_marcas,
    marca TYPE zlo_marca,
    END OF lty_marcas.

" the data of database
    DATA: lt_marcas TYPE TABLE OF lty_marcas,
          ls_marcas TYPE lty_marcas.

    " Table interna with modify for help search
    " structure for get data of handle_onf4
    DATA: lt_return_tab TYPE TABLE OF ddshretval,
          ls_return_tab TYPE ddshretval.

    "table interna with the modification for the alv control
    "Value selected with lookup
    FIELD-SYMBOLS <lt_modify_data> TYPE lvc_t_modi.

    DATA ls_modify_data TYPE lvc_s_modi.

    CASE e_fieldname.
      WHEN 'MARCA'.

        SELECT marca FROM zco_marcas
          INTO TABLE lt_marcas
          WHERE marca NE space.

        IF sy-subrc EQ 0.

          CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
            EXPORTING
*             DDIC_STRUCTURE         = ' '
              retfield               = 'MARCA' " db
*             PVALKEY                = ' '
             dynpprog               = sy-repid
             dynpnr                 = sy-dynnr
             dynprofield            = 'MARCA'  " dynpro
*             STEPL                  = 0
*             WINDOW_TITLE           =
*             VALUE                  = ' '
             value_org              = 'S' " SHOW contend the content 'S' not other letter, bar with table information
*             MULTIPLE_CHOICE        = ' '
*             DISPLAY                = ' '
*             CALLBACK_PROGRAM       = ' '
*             CALLBACK_FORM          = ' '
*             CALLBACK_METHOD        =
*             MARK_TAB               =
*           IMPORTING
*             USER_RESET             =
            TABLES
              value_tab              = lt_marcas
*             FIELD_TAB              =
             return_tab             = lt_return_tab " new value
*             DYNPFLD_MAPPING        =
           EXCEPTIONS
             parameter_error        = 1
             no_values_found        = 2
             OTHERS                 = 3
                    .
          IF sy-subrc <> 0.
            "* Implement suitable error handling here

            " exportation of data for the events double click show in MARCA

          ELSE.

          READ TABLE lt_return_tab INTO ls_return_tab INDEX 1.

          IF sy-subrc EQ 0.

          ls_modify_data-row_id    = es_row_no-row_id.
          ls_modify_data-fieldname = e_fieldname.
          ls_modify_data-value     =  ls_return_tab-fieldval. " recolection of new value

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


  METHOD handle_hotspot_click.

    DATA: lt_clientes TYPE TABLE OF zco_clientes,
          ls_vehiculos TYPE gty_vehiculos.

  CASE e_column_id.

    WHEN 'MATRICULA'.

      READ TABLE gt_vehiculos INTO ls_vehiculos INDEX es_row_no-row_id.

      IF sy-subrc EQ 0.
        SELECT * FROM zco_clientes INTO TABLE lt_clientes WHERE matricula EQ ls_vehiculos-matricula
            AND cntr_type EQ 'C'.

          IF sy-subrc EQ 0.

              " function module

            CALL FUNCTION 'POPUP_WITH_TABLE'
              EXPORTING
                endpos_col         = 160
                endpos_row         = 15
                startpos_col       = 20
                startpos_row       = 10
                titletext          = TEXT-p01
*             IMPORTING
*               CHOICE             =
              TABLES
                valuetab           = lt_clientes
             EXCEPTIONS
               break_off          = 1
               OTHERS             = 2
                      .
            IF sy-subrc <> 0.
              " Implement suitable error handling here

          ENDIF.

          ELSE.

                MESSAGE s002(zco_msg_alfa02) DISPLAY LIKE 'E'.

            ENDIF.

      ENDIF.

    WHEN ''.

    WHEN OTHERS.
  ENDCASE.

  ENDMETHOD.


ENDCLASS.


class lcl_sav_event definition.

  PUBLIC SECTION.
  "btn_rent
  methods handle_added_function for event added_function of cl_salv_events_table
                                                         IMPORTING e_salv_function. " code function

endclass.


class lcl_sav_event IMPLEMENTATION.

  method handle_added_function.

    CASE e_salv_function.

      WHEN 'BTN_RENT'. " break point

      WHEN ''.
      WHEN OTHERS.
    ENDCASE.

  endmethod.

endclass.

class lcl_hier_events DEFINITION.

  public section.

    methods handle_link_clik for event link_click
                           of cl_salv_events_hierseq
                           importing level
                                     column
                                     row.

endclass.

class lcl_hier_events IMPLEMENTATION.

  method handle_link_clik.

    data ls_cln_hier type zco_clientes.

    read TABLE gt_cln_hier into ls_cln_hier index row.

    IF sy-subrc eq 0.
      MESSAGE I000(ZCO_MSG_ALFA02) WITH 'CLIENTE' ls_cln_hier-nombre.
    ENDIF.

  endmethod.

endclass.

CLASS lcl_drag_drop_object definition.

  public section.

  data: gs_mmc_data  type zco_ma_mo_cl_tree,
        gv_note_text type lvc_value.

endclass.

class lcl_gui_tree_events definition.

  public section.

  methods: handle_on_drag for EVENT on_drag
                          of cl_gui_alv_tree
                          IMPORTING sender
                                    node_key
                                    fieldname
                                    drag_drop_object,

           handle_on_drop for event on_drop
                          of cl_gui_alv_tree
                          importing sender
                                    node_key
                                    drag_drop_object.
endclass.

class lcl_gui_tree_events IMPLEMENTATION.

  method handle_on_drag.

    data lo_drag_drop type ref to lcl_drag_drop_object.

    create object lo_drag_drop.

    sender->get_outtab_line(
      EXPORTING
        i_node_key     = node_key
      IMPORTING
        e_outtab_line  = lo_drag_drop->gs_mmc_data " line object
        e_node_text    = lo_drag_drop->gv_note_text
*        et_item_layout =
*        es_node_layout =
      EXCEPTIONS
        node_not_found = 1
        others         = 2
    ).
    IF SY-SUBRC <> 0.
     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    drag_drop_object->object = lo_drag_drop.

  ENDMETHOD.

  method handle_on_drop.

    data: lo_drag_drop   type ref to lcl_drag_drop_object,
          ls_layout_node type lvc_s_layn.

  ls_layout_node-n_image = icon_system_favorites.

  catch SYSTEM-EXCEPTIONS move_cast_error = 1.

  lo_drag_drop ?= drag_drop_object->object.

  go_gui_tree->add_node(
    EXPORTING
      i_relat_node_key     = gv_fav_key                 " Node Already in Tree Hierarchy
      i_relationship       = cl_gui_column_tree=>relat_first_child   " How to Insert Node
      is_outtab_line       = lo_drag_drop->gs_mmc_data                " Attributes of Inserted Node
      is_node_layout       = ls_layout_node                 " Node Layout
*      it_item_layout       =                  " Item Layout
      i_node_text          = lo_drag_drop->gv_note_text                  " Hierarchy Node Text
*    IMPORTING
*      e_new_node_key       =                  " Key of New Node Key
    EXCEPTIONS
      relat_node_not_found = 1                " Relat Node Key not Found
      node_not_found       = 2                " Node not Found
      others               = 3
  ).
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  sender->expand_node( EXPORTING i_node_key =  gv_fav_key ).

  sender->frontend_update( ).

  endcatch.

  IF sy-subrc eq 0.

    drag_drop_object->abort( ).

  ENDIF.

  ENDMETHOD.

endclass.
