*&---------------------------------------------------------------------*
*& Report Z_ALV_IDA_CUT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_ALV_IDA_CUT_ALFA02.

DATA: GO_ALV_DISPLAY TYPE REF TO IF_SALV_GUI_TABLE_IDA,
      GO_CUST_CONT TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GS_SCUSTOM TYPE SCUSTOM.

START-OF-SELECTION.

  SELECT-OPTIONS SO_LANGU FOR GS_SCUSTOM-langu.

END-OF-SELECTION.

CALL SCREEN 2000.
*&---------------------------------------------------------------------*
*& Module STATUS_2000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_2000 OUTPUT.
 SET PF-STATUS 'STATUS_2000'.
 SET TITLEBAR 'TITLE_2000'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_2000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_2000 OUTPUT.
  PERFORM INIT_2000.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form INIT_2000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_2000 .

  IF go_cust_cont IS NOT BOUND.

    go_cust_cont = NEW #( 'ALV_CONT' ).
    go_alv_display = CL_SALV_GUI_TABLE_IDA=>create(
                       iv_table_name         = 'SCUSTOM'
                       io_gui_container      =  go_cust_cont ).

    DATA lo_collector type ref to cl_salv_range_tab_collector.

    lo_collector = NEW CL_SALV_RANGE_TAB_COLLECTOR( ).

    lo_collector->add_ranges_for_name(
      EXPORTING
        iv_name   = 'LANGU'
        it_ranges = SO_LANGU[]  ).


    lo_collector->get_collected_ranges(
      IMPORTING
        et_named_ranges = data(lt_name_ranges) ).

    go_alv_display->set_select_options(
      EXPORTING
        it_ranges    = lt_name_ranges ).

  ENDIF.

ENDFORM.
