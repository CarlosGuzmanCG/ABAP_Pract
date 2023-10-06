*&---------------------------------------------------------------------*
*& Report ZPOO_40_RESUMABLE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_40_RESUMABLE_ALFA02.

class lcx_tarjeta_caducada definition inheriting from cx_static_check.

  public section.

  constants: lcx_tarjeta_caducada type string
              value 'Su tarjeta es caducada y retenida por el cajero'.

endclass.

class lcx_saldo_insuficiente definition inheriting from cx_static_check.

  public SECTION.

  constants lcx_saldo_insuficiente type string
            value 'Saldo insuficiente en su cuenta'.

endclass.

class lcl_banco definition.

  public section.

  methods: validar_cuenta importing tarjeta type string
                                    importe type i
                                    cuenta_ahorro type abap_bool optional

                                    raising lcx_tarjeta_caducada
                                    resumable(lcx_saldo_insuficiente).


endclass.

class lcl_banco implementation.

  method validar_cuenta.

    write / 'Comprobando validez de la tarjeta'.

    IF tarjeta eq '1111 2222 3333 4444'.

      raise exception type lcx_tarjeta_caducada.

    ENDIF.

    write / 'Comprobando saldo en la cuenta'.

    if importe ge 50.

      IF cuenta_ahorro eq abap_true.

        raise resumable EXCEPTION type lcx_saldo_insuficiente.


        write / 'Después del levantamiento de RESUMABLE'.

        else.

          raise exception type lcx_saldo_insuficiente.

      ENDIF.

    ENDIF.

  endmethod.

endclass.

class lcl_cajero definition.

  public section.

  methods retirar_dinero importing tarjeta type string
                                   importe type i
                                   cuenta_ahorro type abap_bool optional.

endclass.

class lcl_cajero IMPLEMENTATION.

  method retirar_dinero.

    data: lo_banco type ref to lcl_banco,
          lcx_exception type ref to cx_root.

    create object lo_banco.

    TRY.

      lo_banco->validar_cuenta(
        EXPORTING
          tarjeta       = tarjeta
          importe       = importe
          cuenta_ahorro = cuenta_ahorro
      ).

      write / 'Recoge los billetes'.
      write / 'Operacion finalizada con exito'.

      CATCH               lcx_tarjeta_caducada.

        write / lcx_tarjeta_caducada=>lcx_tarjeta_caducada.

      CATCH BEFORE UNWIND lcx_saldo_insuficiente into lcx_exception.

      IF lcx_exception->is_resumable eq abap_true.

        write / 'Retirar dinero de la cuenta ahorro'.

        resume.
        else.

          write / 'Saldo insuficiente en la cuenta corriente'.

      ENDIF.

    ENDTRY.

  endmethod.

endclass.

START-OF-SELECTION.

  data gcl_cajero type ref to lcl_cajero.

  create object gcl_cajero.

  write / 'Caso 1 - Tarjeta_caducada'. skip.

  gcl_cajero->retirar_dinero(
    EXPORTING
      tarjeta       = '1111 2222 3333 4444'
      importe       =  30
*      cuenta_ahorro =
  ).skip.

    write / 'Caso 2 - Saldo insuficiente'. skip.

  gcl_cajero->retirar_dinero(
    EXPORTING
      tarjeta       = '1111 2222 3333 4444'
      importe       =  130
*      cuenta_ahorro =
  ).skip.

    write / 'Caso 3 - Tarjeta_caducada'. skip.

  gcl_cajero->retirar_dinero(
    EXPORTING
      tarjeta       = '1111 2222 3333 5555'
      importe       =  100
      cuenta_ahorro = abap_true
  ).
