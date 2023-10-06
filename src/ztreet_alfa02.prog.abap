*&---------------------------------------------------------------------*
*& Module Pool      ZTREET_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM ZTREET_ALFA02.

DATA: go_custom_cont_ade TYPE REF TO cl_gui_custom_container.
DATA: go_salv_tree TYPE REF TO cl_salv_tree.
DATA: ok_code TYPE syucomm.
 DATA: gt_ade_temp_tree TYPE TABLE OF zhr_de_ar_emp_tree_alfa02,

 gt_ade_tree TYPE TABLE OF zhr_de_ar_emp_tree_alfa02.



*&---------------------------------------------------------------------*
*& Module INIT_200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_200 OUTPUT.

 CHECK ok_code IS NOT INITIAL.

  CASE ok_code.
    WHEN 'ADE'.
       IF go_custom_cont_ade IS BOUND.
        PERFORM clear_container_ade.
      ENDIF.

      PERFORM area_department_employee.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.

  ok_code = sy-ucomm.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form area_department_employee
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM area_department_employee .

   IF go_salv_tree IS NOT BOUND.

            IF go_custom_cont_ade IS BOUND.
        PERFORM clear_container_ade.
      ENDIF.

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
*      hide_header =                  " Do Not Show Header
    IMPORTING
      r_salv_tree = go_salv_tree                 " ALV: Tree Model
    CHANGING
      t_table     = gt_ade_temp_tree
  ).
  CATCH cx_salv_error. " ALV: General Error Class (Checked in Syntax Check)
    " agregar mensaje de error
  ENDTRY.

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

*    DATA: lv_langu_header   TYPE salv_de_tree_text,
*        lv_langu_tooltip  TYPE salv_de_tree_text.
*
*  IF sy-langu EQ 'S'." SPANISH LENGUAJE
*    lv_langu_header  = 'AREA'.
*    lv_langu_tooltip = 'DESPLIEGUE LOS NODOS'.
*  ELSEIF sy-langu EQ 'E'. " ENGLISH LANGUAGE
*    lv_langu_header  = 'AREA'.
*    lv_langu_tooltip = 'DEPLOY THE NODES'.
*  ENDIF.

    DATA: lo_settings TYPE REF TO cl_salv_tree_settings.

  lo_settings = go_salv_tree->get_tree_settings( ).

  lo_settings->set_hierarchy_header( value = 'Registros' ).
  lo_settings->set_hierarchy_tooltip( value = 'Despliegue los nodos' ).
  lo_settings->set_hierarchy_size( value = 60 ).

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

   SELECT
     area~nombre_area job_title~nombre_puesto employee~id_empleado
         employee~nombre employee~apellido_paterno employee~apellido_materno
         employee~calle employee~colonia employee~municipio employee~estado
         employee~no_interior employee~n_telefono1 employee~correo_elec
        FROM za23_empleados AS employee
          INNER JOIN za23_asignacion AS assignment
                  ON employee~id_empleado EQ assignment~id_empleado
          INNER JOIN za23_puestos AS job_title
                  ON assignment~id_puesto EQ job_title~id_puesto
          INNER JOIN za23_areas AS area
                  ON job_title~id_area EQ area~id_area

     INTO TABLE gt_ade_tree
*     WHERE employee~status EQ 'ACT'

        .

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

DATA: lo_nodes         TYPE REF TO cl_salv_nodes, " todos los nodos
        lo_node          TYPE REF TO cl_salv_node,   "  solo un nodo

        lv_text          TYPE lvc_value,
        lv_key_area      TYPE salv_de_node_key,
        lv_key_job_title TYPE salv_de_node_key.

        FIELD-SYMBOLS <ls_ade_tree> TYPE zhr_de_ar_emp_tree_alfa02.

  lo_nodes = go_salv_tree->get_nodes( ).


  LOOP AT gt_ade_tree ASSIGNING <ls_ade_tree>.

    "lo_nodes = go_salv_tree->get_nodes( ). " clase estandar
    ON CHANGE OF <ls_ade_tree>-nombre_area. " nueva area, lo agregamos al nodo
      lv_text = <ls_ade_tree>-nombre_area. " le pasamos el nombre del area
      TRY.
      lo_node = lo_nodes->add_node( " new node parent
        EXPORTING
          related_node   = space                 " Key to Related Node
          relationship   = if_salv_c_node_relation=>parent "if_salv_c_node_relation=>parent                 " Node Relation in Tree
          text           = lv_text                 " ALV Control: Cell Content
          expander       = abap_true                 " Boolean Variable (X=True, Space=False)
          folder         = abap_true                  " Boolean Variable (X=True, Space=False)
      ).

      lv_key_area = lo_node->get_key( ). " obtenemos clave del nodo padre

      CATCH cx_salv_msg. " ALV: General Error Class with Message
      ENDTRY.
    ENDON.

    " cuando se cambia el valor de los puestos
    ON CHANGE OF <ls_ade_tree>-nombre_puesto.
      lv_text = <ls_ade_tree>-nombre_puesto.
      TRY.
      lo_node = lo_nodes->add_node( "new nodel child
          EXPORTING
            related_node   =  lv_key_area                " Key to Related Node  referencia del padre apunto al hijo al padre
            relationship   = if_salv_c_node_relation=>last_child "if_salv_c_node_relation=>last_child                 " Node Relation in Tree   agregamos al hijo
            text           = lv_text                 " ALV Control: Cell Content
            expander       = abap_true                " Boolean Variable (X=True, Space=False)
            folder         = abap_true                 " Boolean Variable (X=True, Space=False)
        ).

      lv_key_job_title = lo_node->get_key( ). " obtenemos la clave

      CATCH cx_salv_msg. " ALV: General Error Class with Message
      ENDTRY.
    ENDON.
*    CLEAR lv_key_area.

    lv_text = <ls_ade_tree>-id_empleado.

    TRY.
    lo_node = lo_nodes->add_node(
      EXPORTING
        related_node   = lv_key_job_title "lv_key_job_title                " Key to Related Node
        relationship   = if_salv_c_node_relation=>last_child "first_child "FIRST_CHILD "if_salv_c_node_relation=>last_child                 " Node Relation in Tree
*        data_row       = <ls_ade_tree>   "agregamos los demas valores
        text           = lv_text                " ALV Control: Cell Content
    ).
    lo_node->set_data_row( value = <ls_ade_tree> ).
    CATCH cx_salv_msg. " ALV: General Error Class with Message
    ENDTRY.
*    CLEAR:  lv_key_job_title, lv_key_area, <ls_ade_tree>.
  ENDLOOP.

  lo_nodes->expand_all( ). " expande todos los nodos

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
  lo_columns->set_optimize(
      value = if_salv_c_bool_sap=>true
  ).

*  DATA: lo_columns TYPE REF TO cl_salv_columns_tree,
*        lo_column  TYPE REF TO cl_salv_column.
*
*  lo_columns = go_salv_tree->get_columns( ).
*  lo_columns->set_optimize( abap_true ).
*  TRY.
*  lo_column = lo_columns->get_column( columnname = 'NOMBRE_AREA' ).
*  lo_column->set_visible( abap_false ).
*  lo_column = lo_columns->get_column( columnname = 'NOMBRE_PUESTO' ).
*  lo_column->set_visible( abap_false ).
*  lo_column = lo_columns->get_column( columnname = 'ID_EMPLEADO' ).
*  lo_column->set_visible( abap_false ).
*  CATCH cx_salv_not_found.
*    ENDTRY.
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

   CLEAR:gt_ade_temp_tree, gt_ade_tree.

*    cl_gui_cfw=>flush(
*    EXCEPTIONS
*      cntl_system_error = 1                " cntl_system_error
*      cntl_error        = 2                " cntl_error
*      OTHERS            = 3
*  ).
*  IF sy-subrc <> 0.
*   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.

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
