*&---------------------------------------------------------------------*
*& Include ZD11TOP                                  - Module Pool      ZDXYZ6
*&---------------------------------------------------------------------*
PROGRAM zdxyz6.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
" DATA V_KUNNR TYPE KNA1-KUNNR.
" SELECT-OPTIONS SO_KUNNR FOR V_KUNNR.

  TYPES: BEGIN OF ty_kunnr,
    kunnr TYPE kna1-kunnr,
    land1 TYPE kna1-land1,
    name1 TYPE kna1-name1,
    ort01 TYPE kna1-ort01,
  END OF ty_kunnr.

  DATA: it_kunnr TYPE TABLE OF ty_kunnr,
        wa_kunnr TYPE ty_kunnr,
        io1      TYPE kna1-kunnr,
        io2      TYPE kna1-kunnr,
        akunnr   TYPE kna1-kunnr,
        aland1   TYPE kna1-land1,
        aname1   TYPE kna1-name1,
        Aort01   TYPE kna1-ort01,
        lv_lines type i.

  CONTROLS tbc TYPE TABLEVIEW USING SCREEN 100.

  RANGES ra_kunnr FOR io1.

MODULE user_command_0100 INPUT.
CASE sy-ucomm.

  WHEN 'EXIT'.
    LEAVE PROGRAM.
  WHEN 'DATA'.

    ra_kunnr-low  = io1.
    ra_kunnr-high = io2.
    ra_kunnr-sign = 'I'.

    IF io2 IS NOT INITIAL.
      ra_kunnr-option = 'BT'.
    ELSE.
      ra_kunnr-option = 'EQ'.
    ENDIF.

    APPEND ra_kunnr.

    SELECT kunnr land1 name1 ort01 FROM kna1 INTO TABLE it_kunnr WHERE kunnr IN ra_kunnr.

ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module ABC OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE abc OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

    akunnr = wa_kunnr-kunnr.
    aland1 = wa_kunnr-land1.
    aname1 = wa_kunnr-name1.
    aort01 = wa_kunnr-ort01.

    clear:wa_kunnr.
    refresh it_kunnr.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module ABC1 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE abc1 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
  CLEAR: lv_lines,tbc.
  describe table it_kunnr lines lv_lines.
  lv_lines  = lv_lines + 1.
  tbc-lines = lv_lines.
ENDMODULE.
