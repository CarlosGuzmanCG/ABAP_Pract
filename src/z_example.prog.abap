*&---------------------------------------------------------------------*
*& Report Z_EXAMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_EXAMPLE.

*DATA: result1 TYPE f,
*      result2 TYPE decfloat34.

*result1 = 815 / 1000.

*result2 = 815 / 1000.

*cl_demo_output=>display( |Binary  floating point: { result1 }\n| &&
*                         |Decimal floating point: { result2 }\n| ).

*CL_DEMO_OUTPUT=>display( |HOLA: | ).

DATA : LV_STRING TYPE STRING .
TYPES: BEGIN OF TY_STRING,
      STR(25) TYPE C,
      END OF TY_STRING.
DATA IT_STRING TYPE TABLE OF TY_STRING.
DATA WA_STRING TYPE TY_STRING .
LV_STRING = 'SPLIT ME AT SPACE'.
SPLIT LV_STRING AT ' ' INTO TABLE IT_STRING .
LOOP AT IT_STRING INTO WA_STRING.
  WRITE :/ WA_STRING-STR.
ENDLOOP.
