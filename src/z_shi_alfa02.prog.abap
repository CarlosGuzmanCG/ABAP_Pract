*&---------------------------------------------------------------------*
*& Report Z_SHI_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SHI_ALFA02.

DATA: NO_INSTALCION   TYPE C LENGTH 10 VALUE '2015 ABCD'.

SHIFT NO_INSTALCION LEFT DELETING LEADING '20'.

WRITE NO_INSTALCION.
