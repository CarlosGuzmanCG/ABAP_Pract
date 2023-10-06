*&---------------------------------------------------------------------*
*& Report Z17_SEL_BYPASSING_BUF_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z17_SEL_BYPASSING_BUF_ALFA02.

  data gwa_language type t002.

  select single * from t002
    into gwa_language
    where spras EQ sy-langu.

  IF sy-subrc eq 0.

     write gwa_language-laiso.

  ENDIF.

  select single * from t002 bypassing buffer
    into gwa_language
    where spras eq 'S'.

  IF sy-subrc eq 0.

     write gwa_language-laiso.

  ENDIF.
