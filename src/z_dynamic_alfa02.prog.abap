*&---------------------------------------------------------------------*
*& Report Z_DYNAMIC_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DYNAMIC_ALFA02.

DATA: WA_SPFLI TYPE SPFLI.

SELECT SINGLE * FROM SPFLI INTO WA_SPFLI.

PERFORM write_any_line using WA_SPFLI.

FORM write_any_line using u_line type any.

  FIELD-SYMBOLS <fs_comp> type any.

  DO.
    ASSIGN COMPONENT sy-index of STRUCTURE u_line to <fs_comp>.
    IF sy-subrc <> 0.
      exit.
    ENDIF.
    write / <fs_comp>.
  ENDDO.

endform.
