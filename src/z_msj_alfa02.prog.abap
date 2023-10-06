*&---------------------------------------------------------------------*
*& Report Z_MSJ_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_MSJ_ALFA02.

PARAMETERS parac_m type c length 1.

CASE parac_m.
  WHEN 'I'.
    MESSAGE i012(sabapdocu).
  WHEN 'S'.
    MESSAGE s015(sabapdocu).
  WHEN 'A'.
    MESSAGE a016(sabapdocu).

ENDCASE.
