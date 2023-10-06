*&---------------------------------------------------------------------*
*& Include ZXYZ4TOP                                 - Module Pool      ZDXYZ4
*&---------------------------------------------------------------------*
PROGRAM ZDXYZ4.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 " FUNCTION CODE --> VRM_SET_VALUES
data: it_value type table of vrm_value,
      wa_value type vrm_value,
      lv_v1    type i,
      IO1(2) type c.

MODULE user_command_2000 INPUT.

  CASE SY-UCOMM.

    WHEN 'EXIT'.
      LEAVE PROGRAM.

    WHEN 'DROP'.
      IF IO1 = 'V1'.
        lv_v1 = 2.

      ELSEIF IO1 = 'V2'.
        lv_v1 = 3.

      ELSEIF IO1 = 'V3'.
        lv_v1 = 4.

      ENDIF.

   ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_2000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_2000 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

  IF lv_v1 = 0.

    lv_v1 = 1.

    PERFORM valueinternaltable.

    IF it_value is not INITIAL.

      CALL FUNCTION 'VRM_SET_VALUES'
        EXPORTING
          id                    = 'IO1'
          values                = IT_VALUE
       EXCEPTIONS
         ID_ILLEGAL_NAME       = 1
         OTHERS                = 2
                .
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.

  " MAKETHE TEXT FIELDS AS INVISIBLE
  PERFORM TEXTFIELDSINVISIBLE.

  ELSEIF lv_v1 = 2.
    PERFORM displayasia.

  ELSEIF lv_v1 = 3.
    PERFORM displayeurope.

  ELSEIF lv_v1 = 4.
    PERFORM displaynorthamerica.

  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Form valueinternaltable
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM valueinternaltable .

  clear wa_value.
  wa_value-key  = 'V1'.
  wa_value-text = 'ASIA'.
  APPEND wa_value to it_value.

  clear wa_value.
  wa_value-key  = 'V2'.
  wa_value-text = 'EUROPE'.
  APPEND wa_value to it_value.

  clear wa_value.
  wa_value-key  = 'V3'.
  wa_value-text = 'NORTH AMERICA'.
  APPEND wa_value to it_value.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form TEXTFIELDSINVISIBLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM textfieldsinvisible .

  LOOP AT screen.

    IF SCREEN-name = 'T2' or
       SCREEN-name = 'T3' or
       SCREEN-name = 'T4'.

      SCREEN-invisible = '1'.
      MODIFY SCREEN.

    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form displayasia
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM displayasia .

  LOOP AT SCREEN.

    IF SCREEN-name = 'T2'.
      screen-invisible = '0'.
    ELSEIF SCREEN-NAME = 'T3' OR screen-name = 'T4'.
      screen-invisible = '1'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form displayeurope
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM displayeurope .

  LOOP AT SCREEN.

    IF SCREEN-name = 'T3'.
      screen-invisible = '0'.
    ELSEIF SCREEN-NAME = 'T2' OR screen-name = 'T4'.
      screen-invisible = '1'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form displaynorthamerica
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM displaynorthamerica .

  LOOP AT SCREEN.

    IF SCREEN-name = 'T4'.
      screen-invisible = '0'.
    ELSEIF SCREEN-NAME = 'T3' OR screen-name = 'T2'.
      screen-invisible = '1'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.
