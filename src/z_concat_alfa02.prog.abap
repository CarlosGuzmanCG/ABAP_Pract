*&---------------------------------------------------------------------*
*& Report Z_CONCAT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_CONCAT_ALFA02.

DATA: EJERCICIO TYPE N LENGTH 4,
     NO_FACTURA TYPE N LENGTH 8,
     CODIGO_FACTURA TYPE STRING.

EJERCICIO = 1234.
NO_FACTURA = 048539.

CONCATENATE EJERCICIO NO_FACTURA INTO CODIGO_FACTURA SEPARATED BY '/'.

WRITE: 'EJERCICIO: ', EJERCICIO,
       / 'NO_FACTURA: ', NO_FACTURA,
       / 'CODIGO_FACTURA: ', CODIGO_FACTURA.
