*&---------------------------------------------------------------------*
*& Report Z_TEST02_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_TEST02_ALFA02.

DATA(text) = `"Jack." and "Jill" went up the "hill"`.

FIND ALL OCCURRENCES OF PCRE  `"(.*?)"` IN text IGNORING CASE
    RESULTS DATA(result_tab).
IF sy-subrc = 0.
  LOOP AT result_tab ASSIGNING FIELD-SYMBOL(<result>).
    cl_demo_output=>write(  substring( val = text off = <result>-offset len = <result>-length )  ).
  ENDLOOP.
ENDIF.
cl_demo_output=>display( ).
