*&---------------------------------------------------------------------*
*& Report ZDXYZ11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDXYZ11.
" icon
DATA: LS_EMP_DATA TYPE ZEMP_DATA_ALFA02,
      STATUS_ICON TYPE ICONS-text,
      LIGHT       TYPE CHAR30,
      RAD1,
      RAD2,
      RAD3.

INCLUDE ZTEST_STATUS_FORM.

SELECTION-SCREEN BEGIN OF BLOCK B1.

  PARAMETERS: P_EMP TYPE CHAR10.

SELECTION-SCREEN END OF BLOCK B1.

START-OF-SELECTION.

SELECT SINGLE * FROM ZEMP_DATA_ALFA02 INTO ls_emp_data.

  IF SY-SUBRC IS NOT INITIAL.

    CLEAR ls_emp_data.

  ENDIF.

call SCREEN 100.
