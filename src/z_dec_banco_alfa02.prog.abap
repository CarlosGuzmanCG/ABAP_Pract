*&---------------------------------------------------------------------*
*& Report Z_DEC_BANCO_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_dec_banco_alfa02.

INCLUDE  z_dec_banco_alfa02_top.

INCLUDE z_dec_banco_alfa02_sel.

INCLUDE Z_DEC_BANCO_ALFA02_F01.

AT SELECTION-SCREEN ON p_perio.

PERFORM CHECK_VALUES.

START-OF-SELECTION.

PERFORM EXECUTE_TASK.

INITIALIZATION.

PERFORM do_init.

* PERFORM LIST_ALL_RECORDS.
