*&---------------------------------------------------------------------*
*& Report Z_TAB_INTERNAS_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_tab_internas_alfa02.

* Tabla estándar - Standard table
DATA gt_materiales_sta TYPE STANDARD TABLE OF mara.

* Tabla ordenada -Sorted table
DATA gt_materiales_ord TYPE SORTED TABLE OF mara WITH NON-UNIQUE KEY matnr.

*Tabla hashed.
DATA gt_materiales_has TYPE HASHED TABLE OF mara WITH UNIQUE KEY matnr.
