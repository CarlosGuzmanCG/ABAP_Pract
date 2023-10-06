*&---------------------------------------------------------------------*
*& Report ZPOO_MEMORIA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_memoria_alfa02.


DATA: gr_handle_area TYPE REF TO zcl_cesta_comp_area_alfa02,
      gr_cesta       TYPE REF TO zcl_cesta_compras_alfa02,
      gs_ekpo        TYPE ekpo.

TRY.
    gr_handle_area = zcl_cesta_comp_area_alfa02=>attach_for_write(
*                       client      =
*                       inst_name   = cl_shm_area=>default_instance
*                       attach_mode = cl_shm_area=>attach_mode_default
*                       wait_time   = 0
                     ).
                     CATCH cx_shm_exclusive_lock_active.  " Instanz ist schon gesperrt
                     CATCH cx_shm_version_limit_exceeded. " Keine weiteren Versionen verfügbar
                     CATCH cx_shm_change_lock_active.     " Eine Schreibsperre ist schon aktiv
                     CATCH cx_shm_parameter_error.        " Übergebener Parameter hat falschen Wert
                     CATCH cx_shm_pending_lock_removed.   " Shared Objects: wartende Sperre wurde gelöscht
ENDTRY.

CREATE OBJECT gr_cesta AREA HANDLE gr_handle_area.

SELECT * FROM ekpo
   INTO gs_ekpo
   WHERE ebeln EQ '00'.
endselect.

  IF sy-subrc EQ 0.

    APPEND gs_ekpo TO gr_cesta->doc_compras.

  ENDIF.

  TRY.
      gr_handle_area->set_root(  root = gr_cesta  ).
      CATCH cx_shm_initial_reference. " Initiale Referenz übergeben
      CATCH cx_shm_wrong_handle.      " Falsches Handle

  ENDTRY. "

  TRY.

     gr_handle_area->detach_commit( ).

     CATCH cx_shm_wrong_handle.
     CATCH cx_shm_already_detached.
     CATCH cx_shm_secondary_commit.
     CATCH cx_shm_event_execution_failed.
     CATCH cx_shm_completion_error.

  ENDTRY.

  WRITE 'Objeto guardado en la memoria compartida'.
