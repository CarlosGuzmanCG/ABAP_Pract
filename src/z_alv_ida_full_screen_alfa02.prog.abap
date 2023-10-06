*&---------------------------------------------------------------------*
*& Report Z_ALV_IDA_FULL_SCREEN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_ALV_IDA_FULL_SCREEN_ALFA02.
*
*DATA: GO_ALV_IDA TYPE REF TO IF_SALV_GUI_TABLE_IDA,
*      go_ida_fullscreen type ref to if_salv_gui_fullscreen_ida.
*
*
*go_alv_ida = CL_SALV_GUI_TABLE_IDA=>create( iv_table_name = 'SFLIGHT' ).
*
*go_ida_fullscreen = go_alv_ida->fullscreen( ).

*go_ida_fullscreen->display( ).

CL_SALV_GUI_TABLE_IDA=>create( iv_table_name = 'SFLIGHT' )->fullscreen( )->display( ).
