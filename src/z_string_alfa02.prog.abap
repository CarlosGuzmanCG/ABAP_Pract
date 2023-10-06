*&---------------------------------------------------------------------*
*& Report Z_STRING_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_STRING_ALFA02.

DATA: CARLOS TYPE STRING,
      HEXADECIMAL TYPE XSTRING.

CARLOS = 'ALFA02'.
HEXADECIMAL = 'AF01'.

WRITE: CARLOS,
       / HEXADECIMAL.
