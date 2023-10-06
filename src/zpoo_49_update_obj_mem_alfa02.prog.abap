*&---------------------------------------------------------------------*
*& Report ZPOO_49_UPDATE_OBJ_MEM_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_49_UPDATE_OBJ_MEM_ALFA02.

 data gr_handle_area type ref to zcl_pedido_area_alfa02.


try.
 gr_handle_area = zcl_pedido_area_alfa02=>attach_for_update(
*                    client      =
*                    inst_name   = cl_shm_area=>default_instance
*                    attach_mode = cl_shm_area=>attach_mode_default
*                    wait_time   = 0
                  ).

                  CATCH cx_shm_inconsistent.           " Unterschiedliche Definitionen zwischen Program und Gebiet
                  CATCH cx_shm_no_active_version.      " Keine aktive Version für ein Attach vorhanden
                  CATCH cx_shm_exclusive_lock_active.  " Instanz ist schon gesperrt
                  CATCH cx_shm_version_limit_exceeded. " Keine weiteren Versionen verfügbar
                  CATCH cx_shm_change_lock_active.     " Eine Schreibsperre ist schon aktiv
                  CATCH cx_shm_parameter_error.        " Übergebener Parameter hat falschen Wert
                  CATCH cx_shm_pending_lock_removed.   " Shared Objects: wartende Sperre wurde gelöscht

endtry.

  gr_handle_area->root->set_fecha_creacion( fecha_creacion = '20201127' ).

try.

  gr_handle_area->detach_commit( ).

  CATCH cx_shm_wrong_handle.
  CATCH cx_shm_already_detached.
  CATCH cx_shm_secondary_commit.
  CATCH cx_shm_event_execution_failed.
  CATCH cx_shm_completion_error.

endtry.

write / 'Objeto actualizado '.
