*&---------------------------------------------------------------------*
*& Report Z10_SQL_CASE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z10_SQL_CASE_ALFA02.

CLASS LCL_SQL_CASE DEFINITION.
    PUBLIC SECTION.
    CLASS-METHODS MAIN.
ENDCLASS.

CLASS LCL_SQL_CASE IMPLEMENTATION.

    METHOD MAIN.

        DATA(LCL_RANDOM) = CL_ABAP_RANDOM_INT=>create(
                             seed = conv i( sy-uzeit )
                             min  = 1
                             max  = 100
                           ).

        delete from DEMO_EXPRESSIONS where id BETWEEN 0 and 9.

        INSERT DEMO_EXPRESSIONS FROM TABLE @( VALUE #(
        for i = 0 until i > 9
        (
        ID = i NUM1 = LCL_RANDOM->get_next(  )  num2 = LCL_RANDOM->get_next(  )
         ) ) ).

         select from DEMO_EXPRESSIONS
                fields num1, num2,
                case when num1 < 50 and  num2 < 50 then 'ambos menor que 50'
                     when num1 > 50 and num2 > 50 then 'ambos mayor a 50'
                     when num1 = 50 and num2 = 50 then 'igual a 50'
                     else 'otro'
                end as grupo
                ORDER BY grupo
                into table @data(lt_result).

        if sy-subrc eq 0.
            cl_demo_output=>display( lt_result ).
        endif.

    ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
 lcl_sql_case=>main(  ).
