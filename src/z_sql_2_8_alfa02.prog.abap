*&---------------------------------------------------------------------*
*& Report Z_SQL_2_8_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SQL_2_8_ALFA02.

DATA(gv_offset) = 18.
DATA gv_decimal TYPE p LENGTH 13 DECIMALS 4 VALUE
'27.0671'.
SELECT SINGLE FROM demo_expressions
 FIELDS num1
 WHERE num1 EQ 14 AND num2 EQ 8
 INTO @DATA(gv_num1).
IF sy-subrc NE 0.
 INSERT demo_expressions FROM @( VALUE #( num1 = 14 num2
= 8 ) ).
ENDIF.
SELECT SINGLE FROM demo_expressions
 FIELDS id,
 num1,
 num2,
 CAST( num1 AS FLTP ) / CAST( num2 AS FLTP )
AS ratio,
 division( num1, num2, 2 ) AS division,
 div( num1, num2 ) AS div,
 mod( num1, num2 ) AS mod,
 num1 + num2 + @gv_offset AS sum,
 abs( num1 - num2 ) AS abs,
 @gv_decimal AS decimal,
 ceil( @gv_decimal ) AS ceil,
 floor( @gv_decimal ) AS floor,
 round( @gv_decimal, 2 ) AS round
 WHERE id EQ @space
 AND num1 EQ 14
 AND num2 EQ 8
 INTO @DATA(gs_results).
IF sy-subrc EQ 0.
 cl_demo_output=>display( gs_results ).
ENDIF.
