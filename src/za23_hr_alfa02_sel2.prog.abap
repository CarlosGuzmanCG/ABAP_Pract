*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_SEL2
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 3202 AS SUBSCREEN.
*  PARAMETERS: gen_file TYPE string .
   SELECT-OPTIONS gen_file TYPE string .
SELECTION-SCREEN END OF SCREEN 3202.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR gen_file.
*  PERFORM get_file USING gen_file.
