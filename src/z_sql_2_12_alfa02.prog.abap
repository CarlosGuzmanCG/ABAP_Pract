*&---------------------------------------------------------------------*
*& Report Z_SQL_2_12_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SQL_2_12_ALFA02.

DATA: LV_CHAR TYPE C LENGTH 6 VALUE 'LOGALI'.

DELETE FROM DEMO_EXPRESSIONS WHERE ID = LV_CHAR.

INSERT DEMO_EXPRESSIONS FROM TABLE @( VALUE #( ( ID = LV_CHAR CHAR1 = 'AABbCDDe'
CHAR2 = '123456' ) ) ).

SELECT SINGLE FROM demo_expressions
 FIELDS id,
 char1,
 char2,
 left( char1, 2 ) AS left,
 right( char1, 3 ) AS right,
 lpad( char2, 18, '0' ) AS lpad,
 rpad( char2, 18, '0' ) AS rpad,
 ltrim( char1, 'A' ) AS ltrim,
 rtrim( char1, 'e' ) AS rtrim,
 instr( char1, 'bC' ) AS instr,
 length( char1 ) AS lenght,
 replace( char1, 'DD', '__' ) AS replace,
 substring( char1, 3, 2 ) AS substring,
 lower( char1 ) AS lower,
 upper( char1 ) AS upper
 WHERE id EQ 'L'
 INTO @DATA(ls_result).
IF sy-subrc EQ 0.
 cl_demo_output=>display( ls_result ).
ENDIF.
