*&---------------------------------------------------------------------*
*& Include          ZMAT_ITEMS_ALFA02_CL
*&---------------------------------------------------------------------*

CLASS lcl_event_alv DEFINITION.

  PUBLIC SECTION.

  METHODS handle_double_click FOR EVENT double_click
  OF cl_gui_alv_grid
  IMPORTING es_row_no
            e_column
            e_row.

  METHODS handle_data_changed FOR EVENT data_changed
  OF cl_gui_alv_grid
  IMPORTING er_data_changed
            e_onf4
            e_onf4_after
            e_onf4_before
            e_ucomm
            sender.

  METHODS handle_data_changed_finished FOR EVENT data_changed_finished
  OF cl_gui_alv_grid
  IMPORTING et_good_cells
            e_modified. " this variable is modify when the user makes changes, his value happens to be: abap_true

  METHODS handle_user_command FOR EVENT user_command
  OF cl_gui_alv_grid
  IMPORTING e_ucomm " code of function
            sender.

    METHODS handle_toolbar FOR EVENT toolbar
  OF cl_gui_alv_grid
  IMPORTING e_interactive
            e_object.

ENDCLASS.

CLASS lcl_event_alv IMPLEMENTATION.

  " When the user finishes modifying the record
  METHOD handle_data_changed_finished.

    "Only records enabled to modify

    "checking variable e_modified is apab_true, to continue with the logic program

    CHECK e_modified = abap_true.

    LOOP AT et_good_cells ASSIGNING FIELD-SYMBOL(<ls_cells>). " data modify in the screen of user

     "read table gt_mat_items ASSIGNING FIELD-SYMBOL(<ls_items>) index <ls_cells>-row_id.

     READ TABLE gt_mat_items ASSIGNING FIELD-SYMBOL(<ls_items>) INDEX <ls_cells>-row_id. " to save resources

     IF sy-subrc EQ 0.
       <ls_items>-bbdd = abap_true.
     ENDIF.

    ENDLOOP.

  ENDMETHOD.

  " new obtion in the toolbar -->personalized by us
  METHOD handle_toolbar. " add to handle
    "all buttons of the screen
    APPEND INITIAL LINE TO e_object->mt_toolbar ASSIGNING FIELD-SYMBOL(<ls_toolbar>). "pointer FIELD-SYMBOL(<ls_toolbar>)
    "COnfiguration pointer
    <ls_toolbar>-function = 'A_SAVE'. " Code funtion
    <ls_toolbar>-quickinfo = 'SAVE'. " INFORMATION THE TOOLBAR AS YOU PASS MOUSE
    <ls_toolbar>-icon  = '@F_SAVE@4'. " search of icon in internet --> abap icon save https://gist.github.com/hugo-dc/2876488


  ENDMETHOD.

  METHOD handle_double_click.

  ENDMETHOD.

  METHOD handle_data_changed.

    " VPSTA
    DATA lv_vpsta TYPE vpsta. " local variable

  LOOP AT er_data_changed->mt_good_cells ASSIGNING FIELD-SYMBOL(<ls_cells>). " pointer in time of execute ASSIGNING FIELD-SYMBOL(<ls_cells>)

    CASE <ls_cells>-fieldname.
      WHEN 'VPSTA'. " get column
        " method for get the valuer inserted}
        er_data_changed->get_cell_value(
          EXPORTING
            i_row_id    =    <ls_cells>-row_id             " Row ID,  of the line
*            i_tabix     =                  " Table Index
            i_fieldname =    <ls_cells>-fieldname              " Field Name, for this columns the value insert by the user
          IMPORTING
            e_value     =    lv_vpsta           " Cell Content
        ).


        IF lv_vpsta(1) NE 'K'. " YES the firts value not's equals to 'K' give me the next error

           " MESSAGE OF ERROR
          er_data_changed->add_protocol_entry(
            EXPORTING
              i_msgid     =        'ZMSG_27' " CLASS OF MESSAGE          " Message ID
              i_msgty     =        'E'           " Message Type
              i_msgno     =        '000'          " Message No.
*              i_msgv1     =                  " Message Variable1
*              i_msgv2     =                  " Message Variable2
*              i_msgv3     =                  " Message Variable3
*              i_msgv4     =                  " Message Variable4
              i_fieldname =      <ls_cells>-fieldname            " Field Name
              i_row_id    =       <ls_cells>-row_id            " RowID
*              i_tabix     =                  " Table Index
          ).

        ENDIF.

    ENDCASE.
   ENDLOOP.
  ENDMETHOD.

  METHOD handle_user_command.

    DATA: lt_bbdd_items TYPE TABLE OF zmat_ALFA02,
          ls_bbdd_items TYPE zmat_ALFA02. " carrier data

   CASE e_ucomm. " multy code of function

    WHEN 'A_SAVE'. " to know when the save has clicked

      LOOP AT gt_mat_items ASSIGNING FIELD-SYMBOL(<ls_items>) WHERE bbdd EQ abap_true. "iteration, filter only value modified with the 'where' when his value is 'X'

        " correct way
        MOVE-CORRESPONDING <ls_items> TO ls_bbdd_items.

        APPEND ls_bbdd_items TO lt_bbdd_items.

      ENDLOOP.

      IF lt_bbdd_items IS NOT INITIAL.
          "commit work.
          MODIFY zmat_ALFA02 FROM TABLE lt_bbdd_items.

          IF sy-subrc EQ 0.

             MESSAGE s001(zmsg_27).

          ENDIF.

      ENDIF.

      "delete
      REFRESH lt_bbdd_items.

      LOOP AT gt_mat_original  ASSIGNING <ls_items>.

        READ TABLE gt_mat_items TRANSPORTING NO FIELDS WITH KEY matnr = <ls_items>-matnr.

            IF sy-subrc NE 0.

               MOVE-CORRESPONDING <ls_items> TO ls_bbdd_items.

               APPEND ls_bbdd_items TO lt_bbdd_items.

            ENDIF.

      ENDLOOP.

      IF lt_bbdd_items IS NOT INITIAL.

       DELETE zmat_alfa02 FROM TABLE lt_bbdd_items.

        IF sy-subrc EQ 0.

         COMMIT WORK.

         MESSAGE s002(zmsg_27).

        ENDIF.

      ENDIF.

   ENDCASE.

  ENDMETHOD.


ENDCLASS.
