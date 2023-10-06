*&---------------------------------------------------------------------*
*& Report Z_EXP_CASE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_EXP_CASE_ALFA02.

DATA EMPRESA TYPE STRING.

EMPRESA = 'OTRO'.

CASE EMPRESA.
  WHEN 'LOGALI'.
    WRITE 'ACADEMIA'.
  WHEN 'SAP'.
    WRITE 'Software empresarial'.
  WHEN OTHERS.
     WRITE 'Desconocido'.
ENDCASE.
