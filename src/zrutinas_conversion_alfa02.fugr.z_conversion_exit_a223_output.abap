FUNCTION Z_CONVERSION_EXIT_A223_OUTPUT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     VALUE(OUTPUT) TYPE  CLIKE
*"----------------------------------------------------------------------

CALL 'CONVERSION_EXIT_ALPHA_OUTPUT' ID 'INPUT' FIELD input
                                    ID 'OUTPUT' FIELD output.




ENDFUNCTION.
