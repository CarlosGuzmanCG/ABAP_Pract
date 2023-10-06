*&---------------------------------------------------------------------*
*& Report Z26_LIKE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z26_LIKE_ALFA02.

  PARAMETERS pa_str type c length 20.

  data gt_text type table of doktl.

  " Cualquier caracter string
  pa_str = '%' && pa_str && '%'.

  "_ Cualquier caracter antes *12
*  pa_str = '_' && pa_str.

  select * from doktl
    into table gt_text
    up to 3 rows
    where doktext like pa_str.

    IF sy-subrc eq 0.
        cl_demo_output=>display( gt_text ).
    ENDIF.
