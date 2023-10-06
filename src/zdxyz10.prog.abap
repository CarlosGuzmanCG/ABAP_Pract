*&---------------------------------------------------------------------*
*& Report ZDXYZ10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDXYZ10.

INCLUDE ZDXYZ10_FORM .
*&SPWizard: Data incl. inserted by SP Wizard. DO NOT CHANGE THIS LINE!
INCLUDE ZDXYZ10_TYPE .

*&SPWizard: Include inserted by SP Wizard. DO NOT CHANGE THIS LINE!
INCLUDE ZDXYZ10_PBO .
INCLUDE ZDXYZ10_PAI .

selection-SCREEN begin of block b1.

  PARAMETERS: p_emo_id type char10.

SELECTION-SCREEN END OF block b1.

START-OF-SELECTION.

select single * from zemp_data_alfa02 into @data(ls_emp_data)
  WHERE EMP_ID EQ @p_emo_id.

  IF sy-subrc is not initial.

    clear ls_emp_data.

  ENDIF.

end-of-SELECTION.

call screen 100.
