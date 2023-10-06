*&---------------------------------------------------------------------*
*& Include          ZTEST_TREE01_ALFA02_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module INIT_2000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_2000 OUTPUT.

  CASE sy-ucomm.
   WHEN 'MMC'.
      IF gv_first_time EQ abap_false.
         gv_first_time = abap_true.
      ENDIF.

      IF gv_first_time EQ abap_true.
        PERFORM free_container.
      ENDIF.
      PERFORM marca_modelo_cliente.
      WHEN OTHERS.
    ENDCASE.

ENDMODULE.
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
*& Form create_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM create_container USING pv_tipo_op. "pv_tipo_op the type default chart

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
endform.
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
*& Form get_salv_tree_data
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
*& Form free_container
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_container .

" NO ENTRA LA PRIMERA VEZ, ENTRA LA SEGUNDA VEZ
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

  ENDIF.

  IF go_salv_tree is BOUND.
    clear: go_salv_tree.
  ENDIF.

" ENTRA LA PRIMERA VEZ Y SEGUNDA VEZ
  clear:gt_mmc_temp_tree.

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
