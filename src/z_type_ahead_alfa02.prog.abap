*&---------------------------------------------------------------------*
*& Report Z_TYPE_AHEAD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_TYPE_AHEAD_ALFA02.

DATA: GV_BP_ID TYPE SNWD_PARTNER_ID.

CALL SCREEN 2000.

INCLUDE: Z_TYPE_AHEAD_ALFA02_PBO,
         Z_TYPE_AHEAD_ALFA02_PAI.
