*&---------------------------------------------------------------------*
*& Report ZBLOQUEO_EMPLE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbloqueo_emple_alfa02.

DATA gs_empleados TYPE zemple_alfa02.

  CALL FUNCTION 'ENQUEUE_EZ_EMPE_ALFA02'
*   EXPORTING
*     MODE_ZEMPLE_ALFA02       = 'E'
*     MANDT                    = SY-MANDT
*     NUM_DIR                  = "Bloqueo a nivel de registro
*     X_NUM_DIR                = ' '
*     _SCOPE                   = '2'
*     _WAIT                    = ' '
*     _COLLECT                 = ' '
   EXCEPTIONS
     foreign_lock             = 1
     system_failure           = 2
   OTHERS                   = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  gs_empleados-num_dir = 7.
  gs_empleados-nombre = 'Sara'.
  gs_empleados-apellido1 = 'Martinez'.
  gs_empleados-apellido2 = 'Lopez'.
  gs_empleados-cat_prof = '3'.
  gs_empleados-status = 'A'.

  INSERT zemple_alfa02 FROM gs_empleados.

 IF sy-subrc EQ 0.

      MESSAGE i001(00) WITH 'Registro insertado correctamente'.

 ENDIF.

 CALL FUNCTION 'DEQUEUE_EZ_EMPE_ALFA02'
*  EXPORTING
*    MODE_ZEMPLE_ALFA02       = 'E'
*    MANDT                    = SY-MANDT
*    NUM_DIR                  =
*    X_NUM_DIR                = ' '
*    _SCOPE                   = '3'
*    _SYNCHRON                = ' '
*    _COLLECT                 = ' '
           .
