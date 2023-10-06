*&---------------------------------------------------------------------*
*& Report ZTEST_DYN_BTN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_DYN_BTN.

data: r1, r2, r3.

data: lv_btn type char10.

call SCREEN 1000.
*&---------------------------------------------------------------------*
*& Module STATUS_1000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_1000 OUTPUT.

  IF R1 IS INITIAL AND R2 IS INITIAL AND R3 IS INITIAL.
    R1 = ABAP_TRUE.
  ENDIF.


  IF r1 eq abap_true.
    LOOP AT SCREEN.
      IF SCREEN-name = 'LV_BTN'.
        lv_btn = 'Employee'.
        Modify SCREEN.
      ENDIF.
    ENDLOOP.

    ELSEIF R2 EQ abap_true.
      LOOP AT SCREEN.
        IF SCREEN-name = 'LV_BTN'.
          lv_btn = 'Manager'.
          Modify SCREEN.
        ENDIF.
      ENDLOOP.

    ELSEIF R3 EQ abap_true.
      LOOP AT SCREEN.
        IF SCREEN-name = 'LV_BTN'.
          lv_btn = 'HR'.
          Modify SCREEN.
        ENDIF.
      ENDLOOP.

  ENDIF.

ENDMODULE.
