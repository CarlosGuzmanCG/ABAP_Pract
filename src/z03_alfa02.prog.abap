*&---------------------------------------------------------------------*
*& Report z03_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z03_alfa02.

SELECT FROM ZB_13_ALFA02( plant = 'TG0011' , storagelocation = '301B' )
    FIELDS * INTO TABLE @DATA(GT_ZB13).

    IF SY-SUBRC EQ 0.
        cl_demo_output=>display( GT_ZB13 ).
    ENDIF.
