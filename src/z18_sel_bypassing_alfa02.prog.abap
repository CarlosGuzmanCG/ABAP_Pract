*&---------------------------------------------------------------------*
*& Report Z18_SEL_BYPASSING_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z18_SEL_BYPASSING_ALFA02.

  data gts_t0 type t005.

  select single * from t005 bypassing BUFFER
    into gts_t0 where land1 eq 'ES'.

    IF sy-subrc eq 0.

       write gts_t0-lkvrz.

    ENDIF.
