*&---------------------------------------------------------------------*
*& Report Z33_MIN_MAX_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z33_MIN_MAX_ALFA02.

  data: gwa_zs type zsflightalfa02,
        min1 type S_SUM,
        max1 type S_SUM.

  select min( paymentsum ) max( paymentsum )
    from zsflightalfa02
    into ( min1 , max1 ).

  IF sy-subrc eq 0.
    write: min1 , max1.
  ENDIF.
