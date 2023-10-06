*&---------------------------------------------------------------------*
*& Report Z_LISALL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_LISALL_ALFA02.

DATA: DATE_FROM type d, DATE_TO type d.

DATE_FROM = SY-DATUM.

DATE_TO = SY-DATUM.

PERFORM LIST_ALL_RECORDS IN PROGRAM Z_DEC_BANCO_ALFA02_F01 USING
      DATE_FROM DATE_TO.
