*&---------------------------------------------------------------------*
*& Report ZPOO_38_RAISE_EXCEP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_38_raise_excep_alfa02.

CLASS lcl_check_user DEFINITION.

  PUBLIC SECTION.

  METHODS: check_user IMPORTING user TYPE syuname
            RAISING zcx_autorizacion_alfa02,

           check_recurso IMPORTING user TYPE syuname
           RAISING zcx_permisos_alfa02.

ENDCLASS.

CLASS lcl_check_user IMPLEMENTATION.

  METHOD check_user.

    IF user = 'ALFA02'.

      RAISE EXCEPTION TYPE zcx_autorizacion_alfa02
        EXPORTING
          textid   = zcx_autorizacion_alfa02=>usuario_inactivo
*          previous =
      .

    ENDIF.

  ENDMETHOD.

  METHOD check_recurso.

    DATA: lv_msgv1 TYPE msgv1,
          lv_msgv2 TYPE msgv2,
          lv_msgv3 TYPE msgv3,
          lv_msgv4 TYPE msgv4.

    lv_msgv1 = sy-uname.
    lv_msgv2 = sy-repid.
    lv_msgv3 = sy-datum.
    lv_msgv4 = sy-uzeit.

    IF user = 'ALFA02'.

      RAISE EXCEPTION TYPE zcx_permisos_alfa02
        EXPORTING
*          textid   =
*          previous =
          msgv1    = lv_msgv1
          msgv2    = lv_msgv2
          msgv3    = lv_msgv3
          msgv4    = lv_msgv4
      .

    ENDIF.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA: gcx_autorizacion TYPE REF TO zcx_autorizacion_alfa02,
        gcx_permisos     TYPE REF TO zcx_permisos_alfa02,
        gcl_check_user    TYPE REF TO lcl_check_user.

  CREATE OBJECT gcl_check_user.

*  TRY.
*
*  gcl_check_user->check_user( user = sy-uname ).
*
*  CATCH zcx_autorizacion_alfa02 INTO gcx_autorizacion. " Clase de excepcion con clase de mensajes:
*
**      write: 'Se ha emitido la excepcion'.
*
*        WRITE: / gcx_autorizacion->get_text( ).
*
*   ENDTRY.
*
*   TRY.
*
*     gcl_check_user->check_recurso( user = sy-uname ).
*
*     CATCH zcx_permisos_alfa02 INTO gcx_permisos. " Clase de excepcion con clase de mensajes
*
*      WRITE: / gcx_permisos->get_text( ).
*
*   ENDTRY.

skip  3.

write / '------------------Con un solo bloque try------------------------'.
skip.



*TRY.
*
*  gcl_check_user->check_user( user = sy-uname ).
*  gcl_check_user->check_recurso( user = sy-uname ).
*
*     CATCH zcx_autorizacion_alfa02 INTO gcx_autorizacion. " Clase de excepcion con clase de mensajes:
*        WRITE: / gcx_autorizacion->get_text( ).
*
*     CATCH zcx_permisos_alfa02 INTO gcx_permisos. " Clase de excepcion con clase de mensajes
*       WRITE: / gcx_permisos->get_text( ).
*
*ENDTRY.

data: gv_num1       type i,
      gv_num2       type i,
      gv_resultado  type i,
      gcx_exception type ref to cx_root.

gv_num1 = 20.
gv_num2 =  0.

  TRY.

  gv_resultado = gv_num1 / gv_num2.

  write: 'Resultado: ',gv_resultado.

  CATCH cx_root into gcx_exception.

    write 'Capturada y tratada por la clase padre'.

  write: / gcx_exception->get_text( ).

  gv_num2 = 1.

  RETRY.

  write 'Excepcion capturada y corregida'.

  write: / gcx_exception->get_text( ).

  ENDTRY.
