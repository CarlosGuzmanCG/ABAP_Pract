*&---------------------------------------------------------------------*
*& Report Z33_AVG_SUM_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z33_AVG_SUM_ALFA02.

  DATA: gv_promedio type s_seatsmax,
        gv_sum      type s_sum,
        gv_sum_max  type s_sum.
" AVG: PROMEDIO

  select avg( seatsmax ) from zsflightalfa02
    into gv_promedio.

  IF sy-subrc eq 0.
     write gv_promedio.
  ENDIF.

select sum( paymentsum ) from zsflightalfa02
  into gv_sum where carrid eq 'LH' and currency eq 'DEM'.

  IF sy-subrc eq 0.
     write / gv_sum.
  ENDIF.

  skip 2.

  clear: gv_sum, gv_promedio.

  select avg( seatsmax )
         sum( paymentsum )
         max( paymentsum )
       from zsflightalfa02
       into ( gv_promedio, gv_sum, gv_sum_max )
       where carrid eq 'LH'
        and currency eq 'DEM'.

 IF sy-subrc eq 0.
    write: / gv_promedio,
           / gv_sum,
           / gv_sum_max.
 ENDIF.
