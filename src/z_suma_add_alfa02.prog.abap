*&---------------------------------------------------------------------*
*& Report Z_SUMA_ADD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SUMA_ADD_ALFA02.

DATA: TARIFA_BASE             Type i,
      TARIFA_AREA_CORP        Type i,
      TARIFA_SER_MEDICO       Type i,
      TARIFA_TOTAL            Type i.

TARIFA_BASE     = 20.
TARIFA_AREA_CORP = 10.
TARIFA_SER_MEDICO = 15.
TARIFA_TOTAL   = TARIFA_BASE + TARIFA_AREA_CORP + TARIFA_SER_MEDICO.

add 5 TO TARIFA_TOTAL.

WRITE:  'Resultado: ',TARIFA_TOTAL.
