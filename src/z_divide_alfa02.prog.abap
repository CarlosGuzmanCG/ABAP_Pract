*&---------------------------------------------------------------------*
*& Report Z_DIVIDE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DIVIDE_ALFA02.

DATA: TARIFA_EJERCICIO TYPE I,
      TARIFA_PERIODO TYPE I,
      TARIFA_APLICADA TYPE P LENGTH 8 DECIMALS 2.


TARIFA_EJERCICIO = 38.
TARIFA_PERIODO = 4.
TARIFA_APLICADA = TARIFA_EJERCICIO / TARIFA_PERIODO.

DIVIDE TARIFA_APLICADA BY 3.

WRITE: 'Resultado: ', TARIFA_APLICADA.
