*&---------------------------------------------------------------------*
*& Report Z_SQL_2_10_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SQL_2_10_ALFA02.

DATA: LV_CHAR TYPE C LENGTH 6 VALUE 'LOGALI'.

DELETE FROM DEMO_EXPRESSIONS WHERE ID EQ 'L'.

INSERT DEMO_EXPRESSIONS FROM TABLE @( VALUE #( ( ID = 'L' CHAR1 = 'AABbCDDe' CHAR2 = '123456' ) ) ).

SELECT SINGLE FROM demo_expressions
 FIELDS id,
 char1,
 char2,
 concat( char1, char2 ) AS concat,
 concat_with_space( char1, @lv_char, 2 ) AS
concat2,
 char1 && char2 && 'HANA-' && @lv_char AS
ampersand
 WHERE id EQ 'L'
 INTO @DATA(ls_result).
IF sy-subrc EQ 0.
 cl_demo_output=>display( ls_result ).
ENDIF.
