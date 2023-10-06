*&---------------------------------------------------------------------*
*& Report ZPOO_EJERC_39_CLEANUP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_ejerc_39_cleanup_alfa02.

PARAMETERS: pa_n1 TYPE i,
            pa_n2 TYPE i.

START-OF-SELECTION.

DATA: gv_resultado TYPE i,
      gcx_exception TYPE REF TO cx_root.

TRY.

TRY .

  gv_resultado = pa_n1 + pa_n2.

  gv_resultado = pa_n1 / pa_n2.

  gv_resultado = pa_n1 - pa_n2.

CATCH zcx_permisos_alfa02.

  WRITE: /'no tiene permisos al recurso solicitado'.

CATCH zcx_autorizacion_alfa02.

    WRITE: / 'No tiene autorizacion'.

    CLEANUP INTO gcx_exception.

      WRITE / 'Estructura de control CLEANUP'.

      WRITE : / 'Mensaje= ',  gcx_exception->get_text( ).

      WRITE: / 'Resultado = ', gv_resultado.


ENDTRY.

CATCH cx_sy_zerodivide INTO gcx_exception.

  WRITE / gcx_exception->get_text( ).

ENDTRY.
