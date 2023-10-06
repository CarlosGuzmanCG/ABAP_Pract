*&---------------------------------------------------------------------*
*& Report Z08_SQL_STRING_FUNC_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z08_SQL_STRING_FUNC_ALFA02.

CLASS LCL_SQL_STRING_FUNC DEFINITION.
    PUBLIC SECTION.

    CLASS-METHODS MAIN.

ENDCLASS.

CLASS LCL_SQL_STRING_FUNC IMPLEMENTATION.

    METHOD MAIN.

    data lv_char type c length 6 value 'ABCDEF'.

    delete from DEMO_EXPRESSIONS where id eq 'L'.

    INSERT DEMO_EXPRESSIONS FROM TABLE @( VALUE #( ( id = 'L' char1 = '123456' char2 = 'aBcD' ) ) ).

    select single from demo_expressions
        fields char1 as text1,
               char2 as text2,
               concat( char1, char2 ) as concat,
               concat_with_space( char1, @lv_char, 2 ) as concat2,
               CHAR1 && CHAR2 && 'CADENA3' && @LV_CHAR AS AMPERSAND,
               left( char1, 2 ) as left,
               right( char1, 3 ) as right,
               lpad( char2, 10, '0' ) as lpad, "0000aBcDe
               rpad( char2, 10, '01' ) as rpad, "aBcDe0101
               ltrim( char1, '1' ) as ltrim,
               rtrim( char1, '6' ) as rtrim,
               instr( char1, '23' ) as instr,
               length( char1 ) as length,
               replace( char1, '34', '__' ) as replace,
               substring( char1, 2, 3 ) as substring,
               lower( char2 ) as lower,
               upper( char2 ) as upper

         WHERE ID EQ 'L'
         INTO @DATA(LS_RESULT).

     IF SY-SUBRC EQ 0.
        CL_DEMO_OUTPUT=>DISPLAY( LS_RESULT ).
     ENDIF.

    ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

LCL_SQL_STRING_FUNC=>MAIN(  ).
