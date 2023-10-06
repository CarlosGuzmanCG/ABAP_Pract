*&---------------------------------------------------------------------*
*& Report Z_DIV_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DIV_ALFA02.

DATA: NUM_A TYPE I,
      NUM_B TYPE I,
      RESULTADO TYPE P LENGTH 4 DECIMALS 2.

NUM_A = 17.
NUM_B = 4.

RESULTADO = NUM_A DIV NUM_B.

WRITE: 'Resultado: ', RESULTADO.
