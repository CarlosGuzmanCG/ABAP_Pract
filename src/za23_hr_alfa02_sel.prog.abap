*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF SCREEN 3008 AS SUBSCREEN.
  SELECT-OPTIONS gv_date FOR sy-datum  NO-EXTENSION.
SELECTION-SCREEN END OF SCREEN 3008.
