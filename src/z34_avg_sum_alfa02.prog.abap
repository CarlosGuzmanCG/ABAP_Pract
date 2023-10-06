*&---------------------------------------------------------------------*
*& Report Z34_AVG_SUM_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z34_AVG_SUM_ALFA02.

  data: gwa_zs type zsflightalfa02,
        promedio type p decimals 2,
        sumat type i.

  select avg( price ) sum( price )
    from zsflightalfa02
    into ( promedio,sumat )
    where currency = 'USD'.

  IF sy-subrc eq 0.
     write: / 'Prodmedio: ', promedio, 'Suma: ',sumat.
  ENDIF.
