*&---------------------------------------------------------------------*
*& Report ZPOO_EJERC_09_SOLUC_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_ejerc_09_soluc_alfa02.

CLASS lcx_autoriz_iban DEFINITION INHERITING FROM cx_static_check.

ENDCLASS.

CLASS lcl_operaciones_banco DEFINITION.

 PUBLIC SECTION.
 METHODS transferencia IMPORTING iban TYPE string
 RAISING RESUMABLE(lcx_autoriz_iban).

ENDCLASS.


CLASS lcl_operaciones_banco IMPLEMENTATION.

 METHOD transferencia .
 WRITE / 'Comprobando cuenta IBAN'.
 IF iban EQ 'ES95 432 987654321'.
 RAISE RESUMABLE EXCEPTION TYPE lcx_autoriz_iban.
 ELSE.
 RAISE EXCEPTION TYPE lcx_autoriz_iban.
 ENDIF.
 ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.


 DATA: go_operaciones_banco TYPE REF TO lcl_operaciones_banco,
 gcx_excepcion TYPE REF TO cx_root.

 CREATE OBJECT go_operaciones_banco.

 WRITE / 'Caso 1 - Cuenta IBAN no permitida'.

 TRY.

 go_operaciones_banco->transferencia( iban = 'US95 432 987654321' ).

 WRITE: 'Operación alizada con éxito'.

 CATCH BEFORE UNWIND lcx_autoriz_iban INTO gcx_excepcion.

 IF gcx_excepcion->is_resumable EQ abap_true.

 RESUME.

 ELSE.

 WRITE: 'Operación NO permitida'.

 ENDIF.

 ENDTRY.

 SKIP 3.

 WRITE / 'Caso 2 - Cuenta IBAN permitida'.

 TRY.

 go_operaciones_banco->transferencia( iban = 'ES95 432 987654321' ).

 WRITE: / 'Operación realizada con éxito'.

 CATCH BEFORE UNWIND lcx_autoriz_iban INTO gcx_excepcion.

 IF gcx_excepcion->is_resumable EQ abap_true.

 RESUME.

 ELSE.

 WRITE: 'Operación NO permitida'.

 ENDIF.

 ENDTRY.
