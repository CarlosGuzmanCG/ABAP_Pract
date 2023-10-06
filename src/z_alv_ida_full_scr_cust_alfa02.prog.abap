*&---------------------------------------------------------------------*
*& Report Z_ALV_IDA_FULL_SCR_CUST_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_ALV_IDA_FULL_SCR_CUST_ALFA02.

CL_SALV_GUI_TABLE_IDA=>create( iv_table_name = 'SCUSTOM' )->fullscreen( )->display( ).
