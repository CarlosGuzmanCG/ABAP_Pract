*&---------------------------------------------------------------------*
*& Report Z36_COUNT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z36_COUNT_ALFA02.

  data: cnt type i,
        gwa_zs type ZSPFLIALFA02.

  select count(*) from ZSPFLIALFA02
    into (cnt)
    where carrid eq 'JL'.

  IF sy-subrc eq 0.
     write cnt.
  ENDIF.
