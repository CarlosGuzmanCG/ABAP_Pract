*&---------------------------------------------------------------------*
*& Include ZDXYZ5TOP                                - Module Pool      ZDXYZ5
*&---------------------------------------------------------------------*
PROGRAM ZDXYZ5.

  TYPES: BEGIN OF TY_VBAK,
    VBELN TYPE VBAK-vbeln,
    ERDAT TYPE VBAK-ERDAT,
    ERZET TYPE VBAK-erzet,
    ERNAM TYPE VBAK-ernam,
  END OF ty_vbak.

  types: begin of ty_vbap,
    vbeln type vbap-vbeln,
    posnr type vbap-posnr,
    matnr type vbap-matnr,
    netwr type vbap-netwr,
  end of ty_vbap.

  data: wa_vbak type ty_vbak,
        it_vbap type table of ty_vbap,
        wa_vbap type ty_vbap,
        kvbeln  type vbak-vbeln,
        lv_v1   type i,
        avbeln   type vbak-vbeln,
        aerdat   type vbak-erdat,
        aerzet   type vbak-erzet,
        aernam   type vbak-ernam,
        BVBELN  type vbap-vbeln,
        BPOSNR  type vbap-posnr,
        BMATNR  type vbap-matnr,
        BNETWR  type vbap-NETWR.


  COntrols TBC1 TYPE TABLEVIEW USING SCREEN 200.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.

    when 'EXIT'.
      LEAVE PROGRAM.

  endcase.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  XYZ  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE xyz INPUT.

*  MESSAGE 'AFTER PRESSING ENTER, EVENT IS GETTING TRIGGERED' TYPE 'I'.

  select single vbeln erdat erzet ernam from vbak into wa_vbak where vbeln = kvbeln.

  IF sy-subrc = 0.
    select vbeln posnr matnr netwr from vbap into table it_vbap where vbeln = kvbeln.

      IF sy-subrc = 0.
        lv_v1 = 1.
        call SCREEN 200 STARTING AT 12 12 ENDING AT 140 60.
      ENDIF.

  ELSE.
    MESSAGE 'NO DATA AVAILABLE' TYPE 'I'.
  ENDIF.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE sy-ucomm.
    when 'EXIT1'.
      leave to SCREEN 0.
  endcase.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module VBAKMAPPING OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE vbakmapping OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

  IF LV_V1 = 1.

    LV_V1 = 2.

    avbeln = wa_vbak-vbeln.
    aerdat = wa_vbak-erdat.
    aerzet = wa_vbak-erzet.
    aernam = wa_vbak-ernam.
    clear wa_vbak.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module VBAPMAPPING OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE vbapmapping OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

  BVBELN = wa_vbap-vbeln.
  BPOSNR = wa_vbap-posnr.
  BMATNR = wa_vbap-matnr.
  BNETWR = wa_vbap-NETWR.
  clear wa_vbap.

ENDMODULE.
