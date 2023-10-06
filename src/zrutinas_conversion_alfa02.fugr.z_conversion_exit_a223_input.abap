FUNCTION Z_CONVERSION_EXIT_A223_INPUT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     VALUE(OUTPUT) TYPE  CLIKE
*"----------------------------------------------------------------------

CALL 'CONVERSION_EXIT_ALPHA_INPUT' ID 'INPUT' FIELD input
                                   ID 'OUTPUT' FIELD output.



ENDFUNCTION.
