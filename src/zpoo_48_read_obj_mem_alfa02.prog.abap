*&---------------------------------------------------------------------*
*& Report ZPOO_48_READ_OBJ_MEM_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_48_read_obj_mem_alfa02.

  DATA: gr_handle_area TYPE REF TO zcl_pedido_area_alfa02,
        gv_fecha_pedido TYPE sydatum,
        gv_hora_pedido TYPE syuzeit.

TRY.

  gr_handle_area = zcl_pedido_area_alfa02=>attach_for_read(
*                     client    =
*                     inst_name = cl_shm_area=>default_instance
                   ).

       CATCH cx_shm_inconsistent.          " Unterschiedliche Definitionen zwischen Program und Gebiet

       CATCH cx_shm_no_active_version.     " Keine aktive Version für ein Attach vorhanden

       CATCH cx_shm_read_lock_active.      " Anforderung einer 2. Lesesperre

       CATCH cx_shm_exclusive_lock_active. " Instanz ist schon gesperrt

       CATCH cx_shm_parameter_error.       " Falscher Parameter übergeben

       CATCH cx_shm_change_lock_active.

  ENDTRY.

  gr_handle_area->root->get_fecha_creacion(
    IMPORTING
      fecha_creacion =  gv_fecha_pedido                " Fecha de sistema
  ).

  gr_handle_area->root->get_hora_pedido(
    IMPORTING
      hora_pedido =    gv_hora_pedido              " H.sistema
  ).


  TRY.

  gr_handle_area->detach( ).

    CATCH cx_shm_wrong_handle.

    CATCH cx_shm_already_detached.

  ENDTRY.

  WRITE: / 'Fecha pedido: ', gv_fecha_pedido DD/MM/YYYY,
         / 'Hora pedido: ', gv_hora_pedido ENVIRONMENT TIME FORMAT.
