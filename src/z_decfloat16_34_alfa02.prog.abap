*&---------------------------------------------------------------------*
*& Report Z_DECFLOAT16_34_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DECFLOAT16_34_ALFA02.

DATA: IMPUESTO_DIRECTO TYPE DECFLOAT16,
      IMPUESTO_INDIRECTO TYPE DECFLOAT34.

IMPUESTO_DIRECTO = '1.2'.

IMPUESTO_INDIRECTO = '2.1'.

WRITE: IMPUESTO_DIRECTO,
       / IMPUESTO_INDIRECTO.
