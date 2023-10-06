*&---------------------------------------------------------------------*
*& Include ZDXYZ10_PAI
*&---------------------------------------------------------------------*

*&SPWIZARD: INPUT MODULE FOR TS 'ZTAB'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GETS ACTIVE TAB
MODULE ZTAB_ACTIVE_TAB_GET INPUT.
  OK_CODE = SY-UCOMM.
  CASE OK_CODE.
    WHEN C_ZTAB-TAB1.
      G_ZTAB-PRESSED_TAB = C_ZTAB-TAB1.
    WHEN C_ZTAB-TAB2.
      G_ZTAB-PRESSED_TAB = C_ZTAB-TAB2.
    WHEN C_ZTAB-TAB3.
      G_ZTAB-PRESSED_TAB = C_ZTAB-TAB3.
    WHEN C_ZTAB-TAB4.
      G_ZTAB-PRESSED_TAB = C_ZTAB-TAB4.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.



*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

 CASE SY-UCOMM.
   WHEN 'GT'.

     SELECT * FROM ZEMP_DATA_ALFA02 INTO TABLE LT_EMP UP TO 10 ROWS.

    IF SY-SUBRC IS INITIAL.
      SORT lt_emp BY emp_id.
    ENDIF.

 ENDCASE.

ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'TBLE_CNT'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
MODULE TBLE_CNT_USER_COMMAND INPUT.
  OK_CODE = SY-UCOMM.
  PERFORM USER_OK_TC USING    'TBLE_CNT'
                              'LT_EMP'
                              ' '
                     CHANGING OK_CODE.
  SY-UCOMM = OK_CODE.
ENDMODULE.
