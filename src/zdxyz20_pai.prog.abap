*&---------------------------------------------------------------------*
*& Include ZDXYZ20_PAI
*&---------------------------------------------------------------------*

*&SPWIZARD: INPUT MODULE FOR TC 'TBLE_CNT1'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
MODULE TBLE_CNT1_USER_COMMAND INPUT.
  OK_CODE = SY-UCOMM.
  PERFORM USER_OK_TC USING    'TBLE_CNT1'
                              'LT_EMP'
                              ' '
                     CHANGING OK_CODE.
  SY-UCOMM = OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE SY-UCOMM.
    WHEN 'GT'.

      SELECT * FROM ZEMP_DATA_ALFA02 INTO TABLE lt_emp UP TO 10 ROWS.

        IF SY-SUBRC IS INITIAL.
          SORT lt_emp BY EMP_ID.
        ENDIF.

    WHEN 'EXT'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  FILED_SELECTION  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE filed_selection INPUT.

  CASE SY-UCOMM.

   WHEN 'DEL'.

   READ TABLE lt_emp INTO ls_emp INDEX TBLE_CNT1-current_line.

   IF SY-SUBRC IS INITIAL.

     DELETE ZEMP_DATA_ALFA02 FROM ls_emp.

     IF SY-SUBRC IS INITIAL.
       COMMIT WORK AND WAIT.

       MESSAGE 'RECORD DELETE SUCCESSFULLY' TYPE 'S'.

     ENDIF.

   ENDIF.

  ENDCASE.

ENDMODULE.
