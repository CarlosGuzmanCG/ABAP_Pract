*&---------------------------------------------------------------------*
*& Report ZPOO_EJERC1_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_EJERC1_ALFA02.

class lcl_check_user definition.

  public section.

  METHODS check_user importing user type syuname
                      raising zcx_acceso_alfa02.

endclass.

class lcl_check_user implementation.

  method check_user.

    data lv_msgv1 type msgv1.

    lv_msgv1 = sy-uname.

    IF user = 'ALFA02'.

      raise exception type zcx_acceso_alfa02
        EXPORTING
*          textid   = s
*          previous =
      MSGV1 = lv_msgv1
      .

    endif.

 endmethod.

endclass.

START-OF-SELECTION.

  data: gcx_check_user type ref to zcx_acceso_alfa02,
        gcl_check type ref to lcl_check_user.

  create object gcl_check.


  TRY.
      gcl_check->check_user( user =  'ALFA02' ).
*      CATCH zcx_acceso_alfa02. " clase de mensajes

  CATCH  zcx_acceso_alfa02 into gcx_check_user.

    write / gcx_check_user->get_text( ).

  ENDTRY.
