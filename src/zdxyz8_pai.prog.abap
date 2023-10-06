*&---------------------------------------------------------------------*
*& Include ZDXYZ8_PAI
*&---------------------------------------------------------------------*

*&SPWIZARD: INPUT MODULE FOR TS 'TBC3'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GETS ACTIVE TAB
MODULE TBC3_ACTIVE_TAB_GET INPUT.
  OK_CODE = SY-UCOMM.
  CASE OK_CODE.
    WHEN C_TBC3-TAB1.
      G_TBC3-PRESSED_TAB = C_TBC3-TAB1.
    WHEN C_TBC3-TAB2.
      G_TBC3-PRESSED_TAB = C_TBC3-TAB2.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.
