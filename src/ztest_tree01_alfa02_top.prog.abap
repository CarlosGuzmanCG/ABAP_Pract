*&---------------------------------------------------------------------*
*& Include          ZTEST_TREE01_ALFA02_TOP
*&---------------------------------------------------------------------*

TABLES zco_clientes.

DATA: go_custom_container TYPE REF TO cl_gui_custom_container. " *
DATA: go_salv_tree type ref to cl_salv_tree.
DATA gt_mmc_temp_tree type table of zco_ma_mo_cl_tree.
DATA: gt_mmc_tree  type table of zco_ma_mo_cl_tree.
data gv_first_time type abap_bool.
