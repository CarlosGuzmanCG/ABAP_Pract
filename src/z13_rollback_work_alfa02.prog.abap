*&---------------------------------------------------------------------*
*& Report Z13_ROLLBACK_WORK_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z13_ROLLBACK_WORK_ALFA02.

  CLASS lcl_rollback definition.

    public section.

    class-methods on_transaction_finished for event transaction_finished
                  of cl_system_transaction_state importing kind.

   endclass.

   CLASS lcl_rollback IMPLEMENTATION.

     method on_transaction_finished.

       IF kind eq cl_system_transaction_state=>rollback_work.

          write 'Operaciones en BBDD anuladas con exito'.

       ELSEIF kind eq cl_system_transaction_state=>commit_work.

          write 'Base de datos actualizada'.

       ENDIF.

    endmethod.

   ENDCLASS.

   START-OF-SELECTION.

   DATA gwa_airline type zscarralfa02.

               " Metodo     =>
   set handler lcl_rollback=>on_transaction_finished.  " Evento

   select single * from zscarralfa02
     into gwa_airline
     where carrid eq 'AA'.

     IF sy-subrc eq 0.

        gwa_airline-currcode = 'AER'.

        UPDATE zscarralfa02 from gwa_airline.

        COMMIT WORK. " -> Ejecutar antes

        ROLLBACK WORK. " -> Cancelar operaciones de db

        IF sy-subrc eq 0.

          write 'Actualizado con exito'.

        ENDIF.

     ENDIF.
