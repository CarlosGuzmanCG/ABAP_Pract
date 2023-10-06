*&---------------------------------------------------------------------*
*& Report Z_CONDES_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_CONDES_ALFA02.

DATA EXPEDIENTE TYPE STRING VALUE 'Expediente  laboral  con   estado en trámite'.

CONDENSE EXPEDIENTE.

WRITE EXPEDIENTE.
