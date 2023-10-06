*&---------------------------------------------------------------------*
*& Report ZPOO_ACTUALIZAR_MEMORIA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_actualizar_memoria_alfa02.

DATA: gr_handle_area TYPE REF TO zcl_cesta_comp_area_alfa02,
      gs_ekpo TYPE ekpo.

TRY.

  gr_handle_area = zcl_cesta_comp_area_alfa02=>attach_for_update(
* client =
* inst_name = CL_SHM_AREA=>
* attach_mode =
* wait_time = 0
 ).

    CATCH cx_shm_inconsistent. "
    CATCH cx_shm_no_active_version. "
    CATCH cx_shm_exclusive_lock_active. "
    CATCH cx_shm_version_limit_exceeded. "
    CATCH cx_shm_change_lock_active. "
    CATCH cx_shm_parameter_error. "
* CATCH cx_shm_pending_lock_removed. "
ENDTRY.

   READ TABLE gr_handle_area->root->doc_compras INTO gs_ekpo index 1.

   gs_ekpo-ebeln = '11222'.

TRY.

 gr_handle_area->detach_commit( ).

      CATCH cx_shm_wrong_handle.

       CATCH cx_shm_already_detached.

      CATCH cx_shm_secondary_commit.

      CATCH cx_shm_event_execution_failed.

      CATCH cx_shm_completion_error.

ENDTRY.

WRITE 'VALOR ACTUALIZADO'.
