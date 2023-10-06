*&---------------------------------------------------------------------*
*& Report Z_REEMP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_REEMP_ALFA02.

DATA SOLICITUD TYPE STRING.

SOLICITUD = 'SOL-327-ACCESO-28'.

REPLACE ALL OCCURENCES OF '-' IN SOLICITUD WITH '/'.

WRITE SOLICITUD.
