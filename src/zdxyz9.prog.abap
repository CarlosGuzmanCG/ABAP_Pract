*&---------------------------------------------------------------------*
*& Report ZDXYZ9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
" DATA BASE ZEMP_DATA_ALFA02

REPORT ZDXYZ9.

data: r1,
      r2,
      r3.

data: gv_screen type sy-dynnr.

include ZDXYZ9_form.

selection-SCREEN begin of BLOCK b1.

  parameters: p_emp_id type char10.

SELECTION-SCREEN end of block b1.

START-OF-SELECTION.

SELECT SINGLE * FROM ZEMP_DATA_ALFA02 INTO @DATA(LS_EMP_DATA)
  WHERE emp_id = @p_emp_id.

  IF sy-subrc is not INITIAL.
    clear ls_emp_data.
  ENDIF.

end-of-SELECTION.

  call SCREEN 2000.
