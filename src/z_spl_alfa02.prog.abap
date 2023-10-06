*&---------------------------------------------------------------------*
*& Report Z_SPL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SPL_ALFA02.

DATA: REGISTRO TYPE STRING VALUE 'Ejercicio;2020;Sociedad;SAP',
      CAMPO1 TYPE STRING,
      CAMPO2 TYPE STRING,
      CAMPO3  TYPE STRING,
      CAMPO4  TYPE STRING.

SPLIT REGISTRO AT ';' INTO:
                            CAMPO1
                            CAMPO2
                            CAMPO3
                            CAMPO4.

WRITE:  'CAMPO1: ',CAMPO1     ,
       / 'CAMPO2: ',CAMPO2    ,
       / 'CAMPO3: ', CAMPO3    ,
       / 'CAMPO4: ', CAMPO4    .
