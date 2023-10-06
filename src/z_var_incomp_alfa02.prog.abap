*&---------------------------------------------------------------------*
*& Report Z_VAR_INCOMP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_VAR_INCOMP_ALFA02.

DATA: SOCIEDAD TYPE C LENGTH 6,
      TARIFA TYPE P LENGTH 8 DECIMALS 2,
      CODIGO_SOCIEDAD TYPE N LENGTH 4,
      DATOS TYPE X LENGTH 5.

CODIGO_SOCIEDAD = '921'.
DATOS = 'AFD12'.

SOCIEDAD = 'LOGALI'.
TARIFA = '1489.36'.



WRITE: SOCIEDAD,
      / TARIFA,
      / CODIGO_SOCIEDAD,
      / DATOS.
