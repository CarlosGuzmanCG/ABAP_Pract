*&---------------------------------------------------------------------*
*& Report Z_MULTIPLI_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_MULTIPLI_ALFA02.
DATA:  TARIFA_SOC_FI TYPE I,
       TARIFA_SOC_CO TYPE I,
       TARIFA_MULTI TYPE I.

TARIFA_SOC_FI = 2.
TARIFA_SOC_CO = 3.

TARIFA_MULTI = TARIFA_SOC_FI * TARIFA_SOC_CO.

MULTIPLY TARIFA_MULTI BY 2.

WRITE: 'Resultado: ', TARIFA_MULTI.
