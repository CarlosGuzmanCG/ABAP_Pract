*&---------------------------------------------------------------------*
*& Report ZDXYZ13
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDXYZ13.

data: lt_emp type STANDARD TABLE OF zemp_data_alfa02,
      ls_emp type zemp_data_alfa02,
      GV_EMP TYPE CHAR10.

INCLUDE ZTEST_POP_UP_FORMS.

selection-SCREEN begin of block b1.

  PARAMETERS: p_emp type char10.

SELECTION-SCREEN end of BLOCK b1.

START-OF-SELECTION.

ls_emp-emp_id = p_emp.

gv_emp = p_emp.

call SCREEN 100.
