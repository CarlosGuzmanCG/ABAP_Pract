*&---------------------------------------------------------------------*
*& Report Z_BUSQ_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_BUSQ_ALFA02.

DATA: EMPRESA TYPE STRING,
      CARACT TYPE STRING,
     POSI TYPE I.

EMPRESA = 'SYSTEME ANWENDUNGEN PRODUKTE AG'.

CARACT = 'PRO'.

SEARCH EMPRESA FOR CARACT ABBREVIATED.

POSI = SY-FDPOS + 1.


WRITE POSI.
