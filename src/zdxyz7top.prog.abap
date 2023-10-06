*&---------------------------------------------------------------------*
*& Include ZDXYZ7TOP                                - Module Pool      ZDXYZ8
*&---------------------------------------------------------------------*
PROGRAM ZDXYZ8.

TYPES: BEGIN OF TY_KNA1,
  KUNNR TYPE KNA1-kunnr,
  LAND1 TYPE kna1-land1,
  name1 type kna1-name1,
  ort01 type kna1-ort01,
end of TY_KNA1.

types: begin of ty_vbak,
  vbeln type vbak-vbeln,
  erdat type vbak-erdat,
  ernam type vbak-ernam,
  auart type vbak-auart,
  kunnr type vbak-kunnr,
end of ty_vbak.

data: it_kna1 type table of ty_kna1,
      wa_kna1 type ty_kna1,
      it_vbak type table of ty_vbak,
      wa_vbak type ty_vbak,
      akunnr  type kna1-kunnr.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'GET'.
      select kunnr land1 name1 ort01 from kna1 into table it_kna1 where kunnr = akunnr.

        IF it_kna1 is not INITIAL .
          select vbeln erdat ernam auart kunnr from vbak into table it_vbak where kunnr = akunnr.
        ENDIF.

    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.
