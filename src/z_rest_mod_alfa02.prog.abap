*&---------------------------------------------------------------------*
*& Report Z_REST_MOD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_REST_MOD_ALFA02.

DATA:  NUM_A TYPE I,
       NUM_B TYPE I,
       RESULTADO TYPE P LENGTH 4 DECIMALS 2.

NUM_A = 17.
NUM_B = 4.

RESULTADO = NUM_A MOD NUM_B.

WRITE: 'Resultado: ', RESULTADO.
