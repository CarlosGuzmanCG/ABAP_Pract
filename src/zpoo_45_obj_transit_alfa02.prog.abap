*&---------------------------------------------------------------------*
*& Report ZPOO_45_OBJ_TRANSIT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_45_obj_transit_alfa02.

DATA: agent         TYPE REF TO zca_persist_estud_alfa02,
      gr_estudiante TYPE REF TO zcl_persist_estud_alfa02,
      grx_exception TYPE REF TO cx_root.

agent = zca_persist_estud_alfa02=>agent.

" Datos que exiasten en la memoria ram

TRY.

    gr_estudiante = agent->create_transient( i_estudiante = 'ALFA002' ).

    gr_estudiante->set_nombre( i_nombre = 'CARLOS' ).

    gr_estudiante->set_fecha_nacimiento( i_fecha_nacimiento = '20220101' ).

    CATCH cx_os_object_existing INTO grx_exception. " Excepción de servicios de objeto

      WRITE / grx_exception->get_text( ).

ENDTRY.

  commit work.

write / 'Programa finalizado'.


" Obtener datos transitorios

TRY.

  gr_estudiante = agent->get_transient( i_estudiante =  'ALFA002' ).


  write:  / gr_estudiante->get_estudiante( ),
          / gr_estudiante->get_nombre( ),
          / gr_estudiante->get_fecha_nacimiento( ).

  CATCH cx_os_object_not_found into grx_exception.

  write / grx_exception->get_text( ).

ENDTRY.
