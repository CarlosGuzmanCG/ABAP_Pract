*&---------------------------------------------------------------------*
*& Report ZPOO_01_MVM_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_01_MVM_ALFA02.

  DATA: gv_acreedor TYPE lifnr.

  SELECT-OPTIONS so_lifnr FOR gv_acreedor.

CLASS lcl_modelo DEFINITION.

 PUBLIC SECTION.


  METHODS: set_modelo, get_modelo RETURNING VALUE(acreedores) TYPE bbp_lfa1_t.

  PRIVATE SECTION.

  DATA table_acreedores TYPE bbp_lfa1_t.

ENDCLASS.


CLASS lcl_modelo IMPLEMENTATION.

     METHOD set_modelo.

     SELECT * FROM lfa1 INTO TABLE table_acreedores  WHERE lifnr IN so_lifnr.

     ENDMETHOD.

     METHOD get_modelo.

       acreedores = table_acreedores.

     ENDMETHOD.
ENDCLASS.

CLASS lcl_vista DEFINITION.

 PUBLIC SECTION.

 METHODS pintar_acreedores IMPORTING acreedores TYPE bbp_lfa1_t.

ENDCLASS.


CLASS lcl_vista IMPLEMENTATION.

 METHOD pintar_acreedores.

 DATA lt_datos TYPE TABLE OF lfa1.

 lt_datos = acreedores.

 CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'

 EXPORTING i_structure_name = 'LFA1'

 TABLES t_outtab = lt_datos EXCEPTIONS program_error = 1 OTHERS = 2.

 IF sy-subrc <> 0.

 ENDIF.

 ENDMETHOD.
ENDCLASS.


CLASS lcl_controlador DEFINITION.

 PUBLIC SECTION.

 METHODS: set_modelo IMPORTING modelo TYPE REF TO lcl_modelo,
          get_modelo EXPORTING modelo TYPE REF TO lcl_modelo,

          set_vista IMPORTING vista TYPE REF TO lcl_vista,
          get_vista EXPORTING vista TYPE REF TO lcl_vista.

 PRIVATE SECTION.

    DATA: modelo TYPE REF TO lcl_modelo, vista TYPE REF TO lcl_vista.

ENDCLASS.


CLASS lcl_controlador IMPLEMENTATION.

       METHOD set_modelo.

          me->modelo = modelo.

       ENDMETHOD.

       METHOD get_modelo.

         modelo = me->modelo.

       ENDMETHOD.

       METHOD set_vista.

          me->vista = vista.
          me->vista->pintar_acreedores( acreedores = me->modelo->get_modelo( ) ).

       ENDMETHOD.

       METHOD get_vista.

         vista = me->vista.

       ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

     DATA: gr_vista TYPE REF TO lcl_vista,
           gr_modelo TYPE REF TO lcl_modelo,
           gr_controlador TYPE REF TO lcl_controlador.
           CREATE OBJECT: gr_vista,
           gr_modelo,
           gr_controlador.
           gr_modelo->set_modelo( ).
           gr_controlador->set_modelo( modelo = gr_modelo ).
           gr_controlador->set_vista( vista = gr_vista ).
