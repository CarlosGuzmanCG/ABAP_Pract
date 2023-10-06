FUNCTION Z_F4_TIPO_MAT.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) TYPE  DDSHF4CTRL
*"----------------------------------------------------------------------

DATA NAME  TYPE SYUNAME.

NAME = SY-UNAME.

IF CALLCONTROL-STEP = 'DISP'.

  IF SY-UNAME = NAME.

      DELETE RECORD_TAB WHERE STRING+3(4) NE 'ERSA'.

  ENDIF.

ENDIF.


ENDFUNCTION.
