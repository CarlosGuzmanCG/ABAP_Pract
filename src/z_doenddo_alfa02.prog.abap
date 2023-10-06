*&---------------------------------------------------------------------*
*& Report Z_DOENDDO_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DOENDDO_ALFA02.

DATA CONTADOR TYPE I VALUE 0.

DO 10 TIMES.

  ADD 1 TO CONTADOR.

  WRITE CONTADOR.
  IF CONTADOR eq 7.
    EXIT.
  ENDIF.
ENDDO.
