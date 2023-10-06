*&---------------------------------------------------------------------*
*& Report Z_NEW_SQL_EXERCISE_ALFA01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_NEW_SQL_EXERCISE_ALFA02.

SELECT MATNR, LAEDA, MEINS FROM MARA
    INTO TABLE @DATA(LT_MARA) UP TO 5 ROWS.

    IF sy-subrc eq 0.
        cl_demo_output=>display( LT_MARA ).
    endif.
