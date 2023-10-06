*&---------------------------------------------------------------------*
*& Report Z_SQL_2_16_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SQL_2_16_ALFA02.

CONSTANTS: lc_ambos_menor TYPE c LENGTH 20 VALUE 'Ambos < 20',
 lc_ambos_mayor TYPE c LENGTH 20 VALUE 'Ambos > 20',
 lc_ambos_igual TYPE c LENGTH 20 VALUE 'Ambos = 20',
 lc_otro TYPE c LENGTH 20 VALUE 'Otro'.
DATA(lcl_random) = cl_abap_random_int=>create(
 seed = CONV i( sy-uzeit )
 min = 1
 max = 40 ).
DELETE FROM demo_expressions WHERE id BETWEEN 0 AND 9.
INSERT demo_expressions FROM TABLE @( VALUE #(
 FOR i = 0 UNTIL i > 9
 ( id = i num1 = lcl_random->get_next( ) num2 =
lcl_random->get_next( )
 ) ) ).
SELECT FROM demo_expressions
 FIELDS num1, num2,
 CASE WHEN num1 < 20 AND num2 < 20 THEN
@lc_ambos_menor
 WHEN num1 > 20 AND num2 > 20 THEN
@lc_ambos_mayor
 WHEN num1 = 20 AND num2 = 20 THEN
@lc_ambos_igual
 ELSE @lc_otro
 END AS grupo
 WHERE id BETWEEN 0 AND 9
 ORDER BY grupo
 INTO TABLE @DATA(lt_results).
IF sy-subrc EQ 0.
 cl_demo_output=>display( lt_results ).
ENDIF.
