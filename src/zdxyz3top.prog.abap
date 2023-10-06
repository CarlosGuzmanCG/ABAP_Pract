*&---------------------------------------------------------------------*
*& Include ZDXYZ3TOP                                - Module Pool      ZDXYZ3
*&---------------------------------------------------------------------*
PROGRAM ZDXYZ3.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
CONTROLS TSC1 TYPE TABSTRIP.

data lv_v1 type i.

data lv_sno type sy-dynnr value '102'.

MODULE user_command_0100 INPUT.

  case sy-ucomm.

    when 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'HELLO'.
      tsc1-activetab = 'HELLO'.
      lv_sno = '101'.
    WHEN 'BYE'.
      tsc1-activetab = 'BYE'.
      lv_sno = '102'.

  endcase.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

  IF lv_v1 = 0.

    lv_v1 = 1.
    tsc1-activetab = 'BYE'.

  ENDIF.

ENDMODULE.
