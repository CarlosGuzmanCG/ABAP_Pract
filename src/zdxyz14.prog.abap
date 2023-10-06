*&---------------------------------------------------------------------*
*& Report ZDXYZ14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDXYZ14.

DATA: LS_EMP    TYPE ZEMP_DATA_ALFA02,
      EMPID_VAR TYPE CHAR20,
      FIRST_VAR TYPE CHAR20,
      LAST_VAR  TYPE CHAR20.

INCLUDE ZTEST_LABEL_FORM.

SELECTION-SCREEN BEGIN OF BLOCK B1.

  PARAMETERS: P_EMP TYPE CHAR10.

SELECTION-SCREEN END OF BLOCK B1.

START-OF-SELECTION.

SELECT SINGLE * FROM ZEMP_DATA_ALFA02 INTO LS_EMP WHERE EMP_ID = p_emp.

  IF SY-SUBRC IS NOT INITIAL.
    CLEAR LS_EMP.
  ENDIF.

  CALL SCREEN 100.
