*&---------------------------------------------------------------------*
*& Include          Z_ALV_IDA_CONT_ALFA02_FO1
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form INIT_2000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_2000 .

    data lo_collector type ref to cl_salv_range_tab_collector.

    lo_collector = NEW CL_SALV_RANGE_TAB_COLLECTOR( ). "lo_collector = NEW #( ).

*     data(lo_collector) =  NEW CL_SALV_RANGE_TAB_COLLECTOR( ).

  IF go_cust_cont IS NOT BOUND.

    go_cust_cont = NEW #( 'ALV_CONT' ).

    go_alv_display = CL_SALV_GUI_TABLE_IDA=>create(
                       iv_table_name         = 'SFLIGHT'
                       io_gui_container      =  go_cust_cont ).

    lo_collector->add_ranges_for_name(
      EXPORTING
        iv_name   = 'CARRID'
        it_ranges = so_carid[]  ).

    lo_collector->add_ranges_for_name(
      EXPORTING
        iv_name   = 'CONNID' "COLUMNA
        it_ranges = so_conid[]  ).

    lo_collector->add_ranges_for_name(
      EXPORTING
        iv_name   = 'FLDATE'
        it_ranges = so_date[]  ).

    "OBTENER LOS RANGOS filtros
    lo_collector->get_collected_ranges(
      IMPORTING
        et_named_ranges = data(lt_name_ranges) ).


    go_alv_display->set_select_options(
      EXPORTING
        it_ranges    = lt_name_ranges ).

  ENDIF.

ENDFORM.
