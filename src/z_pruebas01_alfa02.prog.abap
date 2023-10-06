*&---------------------------------------------------------------------*
*& Report Z_PRUEBAS01_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_PRUEBAS01_ALFA02.

TABLES: bsid,
vbrk.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-t01.
PARAMETERS: r_new RADIOBUTTON GROUP r1 USER-COMMAND rbut DEFAULT 'X',
r_pen RADIOBUTTON GROUP r1,
r_pro RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-t02.
PARAMETERS: p_bukrs TYPE bsid-bukrs.
SELECT-OPTIONS: s_kunnr FOR bsid-kunnr MODIF ID zz1,
s_belnr FOR bsid-belnr MODIF ID zz1.

PARAMETERS: p_gjahr TYPE vbrk-gjahr MODIF ID im1.
SELECT-OPTIONS: s_bldat FOR bsid-bldat,
s_zuonr FOR vbrk-zuonr MODIF ID im2.
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN OUTPUT.
PERFORM ocultar_campos.

FORM ocultar_campos.

IF r_new EQ 'X'.
LOOP AT SCREEN.
IF screen-group1 = 'IM2'.
screen-INPUT = 0. " Campo editable
screen-invisible = 1. " Campo invisible
MODIFY SCREEN.
ENDIF.
ENDLOOP.

ELSEIF r_pen EQ 'X'.
LOOP AT SCREEN.
IF screen-group1 = 'ZZ1'.
screen-INPUT = 0. " Campo no editable/grisado
screen-invisible = 0. " Campo invisible
MODIFY SCREEN.
ENDIF.

ENDLOOP.
ELSEIF r_pro EQ 'X'.
LOOP AT SCREEN.
IF screen-group1 = 'IM1'.
screen-INPUT = 0. " Campo no editable/grisado
screen-invisible = 1. " Campo invisible
MODIFY SCREEN.
ENDIF.
ENDLOOP.
ENDIF.
ENDFORM. " OCULTAR_CAMPOS
