*&---------------------------------------------------------------------*
*& Report Z07_SQL_NUM_FUNC_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z07_SQL_NUM_FUNC_ALFA02.

data(gv_offset) = 1000.

data gv_decimal type p LENGTH 13 DECIMALS 4 value '14.0589'.

select from demo_expressions
  FIELDS id,
         num1,
         num2,
  CAST( num1 as FLTP ) as num1_fltp, "punto flotante de la columna num1
  CAST( num1 AS FLTP ) / CAST( num2 as FLTP ) as ratio,
  DIVISION( num1, num2, 2 ) as division,
  div( num1, num2 ) as div,
  mod( num1, num2 ) as mod,
  @gv_offset + num1 + num2 as sum,
  abs( num1 - num2 ) as abs,
  @gv_decimal as decimal,
  ceil( @gv_decimal ) as ceil,
  FLOOR( @gv_decimal ) as floor,
  ROUND( @gv_decimal, 2 ) as round
  ORDER BY sum DESCENDING
  into table @data(gt_results).

IF sy-subrc eq 0.
  cl_demo_output=>display( gt_results ).
ENDIF.
