*&---------------------------------------------------------------------*
*& Report ZTEST_SUMA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_suma_alfa02.

CLASS lcl_calculadora DEFINITION.

    public section.

    methods: suma importing num1 type i num2 type i
                   EXPORTING resultado type i.

ENDCLASS.

class lcl_calculadora implementation.

  method suma.

    resultado = num1 + num2.

  endmethod.

endclass.

class test definition for TESTING RISK LEVEL HARMLESS DURATION SHORT.

  public section.

  methods test for testing.

endclass.

class test implementation.

  method test.

      data: gr_lcl_calculadora type ref to lcl_calculadora,
            result type i.

      create object gr_lcl_calculadora.

      gr_lcl_calculadora->suma(
        EXPORTING
          num1      = 5
          num2      = 4
        IMPORTING
          resultado = result
      ).

      cl_aunit_assert=>assert_equals(
        EXPORTING
          exp                  = 10
          act                  = result
          msg                  = 'RESULTADO INCORRECTO'
*          level                = if_aunit_constants=>severity-medium
*          tol                  =
*          quit                 = if_aunit_constants=>quit-test
*          ignore_hash_sequence = abap_false
*        RECEIVING
*          assertion_failed     =
      ).

  endmethod.


endclass.
