FUNCTION z_f4_filter_mat_alfa02.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) TYPE  DDSHF4CTRL
*"----------------------------------------------------------------------


IF callcontrol-step = 'DISP'.

  IF sy-uname = 'ALFA02'.

      DELETE RECORD_TAB WHERE STRING+3(4) NE 'FERT'.

  ENDIF.

ENDIF.



ENDFUNCTION.
