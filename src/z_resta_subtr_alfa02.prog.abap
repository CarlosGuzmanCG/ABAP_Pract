*&---------------------------------------------------------------------*
*& Report Z_RESTA_SUBTR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_RESTA_SUBTR_ALFA02.

DATA: TARIFA_MANTENIMIENTO TYPE I,
      TARIFA_MARGEN TYPE I,
      TARIFA_BASE TYPE I.

TARIFA_MANTENIMIENTO = 30.
TARIFA_MARGEN = 10.

TARIFA_BASE = TARIFA_MANTENIMIENTO - TARIFA_MARGEN.

SUBTRACT 4 FROM TARIFA_BASE.

WRITE: 'Resultado: ', TARIFA_BASE.
