*&---------------------------------------------------------------------*
*& Report ZTYPE_AHEAD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTYPE_AHEAD_ALFA02.

TABLES /CPD/VFC_D_MATNR.

CALL SCREEN 2000.

INCLUDE: ZTYPE_AHEAD_ALFA02_PBO,
         ZTYPE_AHEAD_ALFA02_PAO.
