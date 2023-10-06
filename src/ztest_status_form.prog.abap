*&---------------------------------------------------------------------*
*& Include          ZTEST_STATUS_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE SY-UCOMM.
    WHEN 'VAL'.

      IF LS_EMP_DATA-PHONE_NO IS INITIAL.
        LIGHT = icon_red_light.
      ELSEIF STRLEN( ls_emp_data-phone_no ) LT 10.
        LIGHT = icon_yellow_light.
      ELSEIF STRLEN( ls_emp_data-phone_no ) EQ 10.
        LIGHT = icon_GREEN_light.
      ENDIF.

      CALL FUNCTION 'ICON_CREATE'
        EXPORTING
          name                        = LIGHT
*         TEXT                        = ' '
*         INFO                        = ' '
*         ADD_STDINF                  = 'X'
       IMPORTING
         RESULT                      = STATUS_ICON
       EXCEPTIONS
         ICON_NOT_FOUND              = 1
         OUTPUTFIELD_TOO_SHORT       = 2
         OTHERS                      = 3
                .
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.


  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SCREEN_MODIFICATION OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE screen_modification OUTPUT.

  IF RAD1 IS INITIAL AND RAD2 IS INITIAL AND RAD3 IS INITIAL.

    RAD1 = 'X'.

  ENDIF.

  IF rad1 eq 'X'.

    loop AT SCREEN.

      IF screen-group1 = 'PQR' or screen-group1 = 'XYZ'.

        SCREEN-active = 0.

      ENDIF.

      MODIFY SCREEN.

    ENDLOOP.

  ELSEIF RAD2 EQ 'X'.

    LOOP AT SCREEN.

      IF screen-group1 = 'ABC' or screen-group1 = 'XYZ'.

        SCREEN-ACTIVE = 0.

      ENDIF.

      MODIFY SCREEN.

    ENDLOOP.

  ELSEIF RAD3 EQ 'X'.

    LOOP AT SCREEN.

      IF SCREEN-GROUP1 = 'ABC' OR SCREEN-GROUP1 = 'PQR'.

        SCREEN-ACTIVE = 0.

      ENDIF.

      MODIFY SCREEN.

    ENDLOOP.

  ENDIF.

ENDMODULE.
