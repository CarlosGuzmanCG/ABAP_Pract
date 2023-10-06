*&---------------------------------------------------------------------*
*& Include          ZTEST_POP_UP_FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET pf-STATUS 'ZSTAT'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE SY-UCOMM.
    WHEN 'ENTER' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE SY-UCOMM.
    WHEN 'SHOW'.
      SELECT SINGLE * FROM  ZEMP_DATA_ALFA02 INTO ls_emp WHERE EMP_ID = GV_EMP.

        IF SY-SUBRC IS NOT INITIAL.
          CLEAR ls_emp.
        ENDIF.

        CALL SCREEN 200 STARTING AT 10 08 ENDING AT 70 15.
  ENDCASE.

ENDMODULE.
