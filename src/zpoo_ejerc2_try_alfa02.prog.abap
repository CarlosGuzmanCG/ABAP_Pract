*&---------------------------------------------------------------------*
*& Report ZPOO_EJERC2_TRY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_ejerc2_try_alfa02.

CLASS divi DEFINITION.

  PUBLIC SECTION.

  METHODS: vlr IMPORTING num1 TYPE i
                         num2 TYPE i.

  PRIVATE SECTION.

  DATA: num1 TYPE i, num2 TYPE i, resultado.

  METHODS: operac_div IMPORTING num1 TYPE i
                                num2 TYPE i,
                                get_result.

ENDCLASS.

CLASS divi IMPLEMENTATION.

    METHOD vlr.

      me->num1 = num1.

      me->num2 = num2.

      operac_div(
        EXPORTING
          num1 = num1
          num2 = num2
      ).



    ENDMETHOD.

    METHOD operac_div.

      TRY.
          resultado = me->num1 / me->num2.

          get_result( ).

      CATCH cx_sy_zerodivide.

          WRITE 'División entre cero'.

          if me->num1 gt 0.

              me->num2 = me->num1.

          else.

              me->num2 = 1.

          endif.


      RETRY.

      ENDTRY.

    ENDMETHOD.

    METHOD get_result.

      WRITE: 'resultado: ', me->resultado.

    ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA gr_divi TYPE REF TO divi.

  CREATE OBJECT gr_divi.

  gr_divi->vlr(
    EXPORTING
      num1 = 2
      num2 = 0
  ).
