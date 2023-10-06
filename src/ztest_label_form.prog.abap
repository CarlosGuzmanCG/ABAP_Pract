*&---------------------------------------------------------------------*
*& Include          ZTEST_LABEL_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'ZLABEL'.
* SET TITLEBAR 'xxx'.

  IF ls_emp-emp_id is INITIAL and ls_emp-fname is initial and ls_emp-lname is initial.

    empid_var = 'EMP_ID'.
    FIRST_VAR = 'FNAME'.
    LAST_VAR  = 'LNAME'.

  ELSE.

    empid_var = 'EMPLOYEE_ID'.
    FIRST_VAR = 'FIRST NAME'.
    LAST_VAR  = 'LAST NAME'.

  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE SY-UCOMM.
    WHEN 'BACK' OR 'CANCEL'.

      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.
