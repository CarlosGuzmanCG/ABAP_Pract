*&---------------------------------------------------------------------*
*& Report Z_SQL_2_14_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SQL_2_14_ALFA02.

SELECT SINGLE FROM demo_expressions
 FIELDS dats1
 WHERE id EQ 'F'
 INTO @DATA(gv_dats1).
IF sy-subrc NE 0.
 INSERT demo_expressions FROM @( VALUE #( id = 'F'
 dats1 = '20230329'
 dats2 = '20240329' ) ).
ENDIF.
SELECT SINGLE FROM demo_expressions
 FIELDS id,
 dats1,
 dats2,
 dats_is_valid( dats1 ) AS valid,
 dats_days_between( dats1, dats2 ) AS days_between,
 dats_add_days( dats1, 30 ) AS add_days,
 dats_add_months( dats1, -2 ) AS add_months
 WHERE id EQ 'F'
 INTO @DATA(ls_result).
IF sy-subrc EQ 0.
 cl_demo_output=>display( ls_result ).
ENDIF.
