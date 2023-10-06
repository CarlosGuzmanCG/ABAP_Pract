*&---------------------------------------------------------------------*
*& Report z01_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_alfa02.

SELECT FROM ZB_11_ALFA02 AS ZB FIELDS ZB~*
    INTO TABLE @DATA(GT_ZB11).

    if SY-SUBRC EQ 0.
      cl_demo_output=>display( GT_ZB11 ).
    ELSE.
        write 'null'.
    endif.
