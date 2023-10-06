*&---------------------------------------------------------------------*
*& Report Z_WHILEEND_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_WHILEEND_ALFA02.

DATA CONTADOR TYPE I VALUE 0.

WHILE CONTADOR LE 20.

  IF CONTADOR <= 10.
    WRITE CONTADOR.
  ENDIF.

  ADD 1 TO CONTADOR.

ENDWHILE.
