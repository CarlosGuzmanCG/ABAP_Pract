*&---------------------------------------------------------------------*
*& Include          ZMAT_ITEMS_ALFA02_F1
*&---------------------------------------------------------------------*

FORM init_2000.

*check ok_code = 'EXEC'. " equals a if, code of funtion in screens, for a function code

" Yes there are more function code that we deal with this, for multyple code of function.

CHECK ok_code IS NOT INITIAL.

              "REPLACE BY TABLE 1
SELECT * FROM zmat_alfa02 INTO CORRESPONDING FIELDS OF TABLE gt_mat_items
  WHERE ersda GE gs_items-ersda. " this value goes in the screen 'gs_items-ersda'


  IF sy-subrc EQ 0.
    gt_mat_original = gt_mat_items. "copy of table original
  ENDIF.

CASE ok_code.

  WHEN 'EXEC'.
    PERFORM display_alv.

  WHEN 'UNDO'.
    PERFORM free_resources.

  WHEN OTHERS.
ENDCASE.

*cl_demo_output=>display( gt_mat_items ).

ENDFORM.


" Creation of tha subroutine. CASE 'EXEC' --> Creation of tha subrutina
" Have everything modulated
FORM display_alv.

  " VARIFIC THE VALUE OF DATA. IS WITH: IS INITIALS
  IF NOT go_custom_container IS BOUND. " call a funtion

    go_custom_container = NEW #( container_name = 'ALV' ).

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE' "LVC_FIELDCATALOG_MERGE
    EXPORTING
      i_structure_name       =     'ZMAT_ALFA02'   "'ZST_MAT_ITEMS_ALFA_02'          " Structure name (structure, table, view)
    CHANGING
      ct_fieldcat            =      gt_fieldcat            " Field Catalog with Field Descriptions
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3
    .
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  go_alv_mat_items = NEW #( i_parent = go_custom_container ).

  "Configuration layout
  gs_layout-zebra = abap_true.
  gs_layout-edit  = abap_true.
*  gs_layout-cwidth_opt = abap_true. " adaptation of the screen for the data

  " add

  IF NOT go_events IS BOUND. " if our event is not initialized we initialize it

    go_events = NEW #( ). "instance of object

" set handler warn to the standard= establecer manejador
    SET HANDLER: go_events->handle_data_changed          FOR go_alv_mat_items, " events of modify the data
                 go_events->handle_double_click          FOR go_alv_mat_items,
                 go_events->handle_user_command          FOR go_alv_mat_items,
                 go_events->handle_toolbar               FOR go_alv_mat_items, "call to handler
                 go_events->handle_data_changed_finished FOR go_alv_mat_items.
  ENDIF.



  " Show ALV

  go_alv_mat_items->set_table_for_first_display(
    EXPORTING
*      i_buffer_active               =                  " Buffering Active
*      i_bypassing_buffer            =                  " Switch Off Buffer
*      i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*      i_structure_name              =                  " Internal Output Table Structure Name
*      is_variant                    =                  " Layout
*      i_save                        =                  " Save Layout
*      i_default                     = 'X'              " Default Display Variant
      is_layout                     =   gs_layout               " Layout
*      is_print                      =                  " Print Control
*      it_special_groups             =                  " Field Groups
*      it_toolbar_excluding          =                  " Excluded Toolbar Standard Functions
*      it_hyperlink                  =                  " Hyperlinks
*      it_alv_graphics               =                  " Table of Structure DTC_S_TC
*      it_except_qinfo               =                  " Table for Exception Quickinfo
*      ir_salv_adapter               =                  " Interface ALV Adapter
    CHANGING
      it_outtab                     =  gt_mat_items            " Output Table
      it_fieldcatalog               =  gt_fieldcat            " Field Catalog
*      it_sort                       =                  " Sort Criteria
*      it_filter                     =                  " Filter Criteria
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  ELSE.

  go_alv_mat_items->refresh_table_display(  ).

ENDIF.

ENDFORM.

"Release resource
FORM free_resources.

  "call a the function while funtion is initial 'display_alv'

  IF go_custom_container IS BOUND. " Release ALV
  " CONTAINER
    go_custom_container->free( ).

    CLEAR: go_custom_container,
           go_alv_mat_items,
           gt_fieldcat,
           gt_mat_items,
           go_events.

  gs_items = ''.

  ENDIF.

ENDFORM.
