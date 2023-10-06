*&---------------------------------------------------------------------*
*& Report ZDXYZ17
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDXYZ17.

data: gs_emp    type zemp_data_alfa02,
      gv_ful_nm type char20.

call screen 200.
*&---------------------------------------------------------------------*
*&      Module  FIELD_VALIDATION  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE field_validation INPUT.

  CASE SY-UCOMM.
    WHEN 'DISP'.

      IF GS_EMP-fname IS INITIAL OR gs_emp-LNAME IS INITIAL.

        MESSAGE 'FIRST NAME OR LAST NAME SHOULD NOT BE BLANK' TYPE 'E'.

      ELSE.

        CONCATENATE GS_EMP-FNAME gs_emp-lname INTO gv_ful_nm SEPARATED BY SPACE.

      ENDIF.

    WHEN 'CLR'.

      CLEAR: gs_emp, gv_ful_nm.

  ENDCASE.

ENDMODULE.
