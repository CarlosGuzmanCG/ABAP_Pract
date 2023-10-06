*&---------------------------------------------------------------------*
*& Report Z09_SQL_DATES_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z09_SQL_DATES_ALFA02.

CLASS LCL_SQL_DATES DEFINITION.

    PUBLIC SECTION.
    CLASS-METHODS MAIN.

ENDCLASS.

CLASS LCL_SQL_DATES IMPLEMENTATION.

    METHOD MAIN.

        DELETE FROM  DEMO_EXPRESSIONS WHERE ID = 'L'.
        INSERT DEMO_EXPRESSIONS FROM @( VALUE #( ID = 'L' DATS1 = '20220105'
        DATS2 = '20230101' ) ).

        SELECT SINGLE FROM  DEMO_EXPRESSIONS
            FIELDS DATS1 AS FECHA1,
                   DATS2 AS FECHA2,
                   DATS_IS_VALID( DATS1 ) AS VALID,
                   DATS_DAYS_BETWEEN( DATS1, DATS2 ) AS DATS_DAYS_BETWEEN,
                   DATS_ADD_DAYS( DATS1, 50 ) AS ADD_DAYS,
                   DATS_ADD_MONTHS( DATS1, -1 ) AS ADD_MONTHS
                   INTO @DATA(LS_RESULT).

       IF sy-subrc eq 0.
        cl_demo_output=>display( ls_result ).
       endif.

    ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

    lcl_sql_dates=>main( ).
