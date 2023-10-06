*&---------------------------------------------------------------------*
*& Report ZBLOQUEO_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBLOQUEO_ALFA02.

DATA gs_ZFACT_ALFA02 type ZFACT_ALFA02.

data exception type ref to cx_root.

write 'Solicitando bloqueo ....'.

CALL FUNCTION 'ENQUEUE_EZ_FACT_ALFA02'
 EXPORTING
   MODE_ZFACT_ALFA02       = 'E'
*   MANDT                   = SY-MANDT
*   FACTURA                 =
*   X_FACTURA               = ' '
*   _SCOPE                  = '2'
*   _WAIT                   = ' '
*   _COLLECT                = ' '
* EXCEPTIONS
*   FOREIGN_LOCK            = 1
*   SYSTEM_FAILURE          = 2
*   OTHERS                  = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


  gs_ZFACT_ALFA02-factura = '026352'.

  INSERT ZFACT_ALFA02 from gs_ZFACT_ALFA02.

      write / 'Solicitando de desbloqueo .... '.

      CALL FUNCTION 'DEQUEUE_EZ_FACT_ALFA02'
       EXPORTING
         MODE_ZFACT_ALFA02       = 'E'
*         MANDT                   = SY-MANDT
*         FACTURA                 =
*         X_FACTURA               = ' '
*         _SCOPE                  = '3'
*         _SYNCHRON               = ' '
*         _COLLECT                = ' '
                .
