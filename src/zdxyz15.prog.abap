*&---------------------------------------------------------------------*
*& Report ZDXYZ15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdxyz15.

TABLES zemp_data_alfa02.

CALL SCREEN 100.
" CLASS: VRM_SET_VALUES
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  DATA: lv_id     TYPE vrm_id,
        lt_values TYPE vrm_values,
        ls_values LIKE LINE OF lt_values.

  SELECT * FROM zemp_data_ALFA02 INTO TABLE @DATA(lt_emp).

    IF sy-subrc IS INITIAL.

      LOOP AT lt_emp INTO DATA(ls_emp).

        ls_values-key  = ls_emp-emp_id.
        ls_values-text = ls_emp-emp_id.

        append ls_values to lt_values.
        clear ls_values.

      ENDLOOP.

    ENDIF.

    lv_id = 'zemp_data_alfa02-emp_id'.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id                    = lv_id
        values                = lt_values
     EXCEPTIONS
       ID_ILLEGAL_NAME       = 1
       OTHERS                = 2
              .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


ENDMODULE.
