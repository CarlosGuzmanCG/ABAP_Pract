*&---------------------------------------------------------------------*
*& Report ZSQL_02_04_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSQL_02_04_ALFA02.

SELECT FROM MARA
    FIELDS MATNR, LAEDA, MEINS
    INTO TABLE @DATA(LT_MARA) UP TO 5 ROWS.

    IF SY-SUBRC EQ 0.
        CL_DEMO_OUTPUT=>display( LT_MARA ).
    ENDIF.
