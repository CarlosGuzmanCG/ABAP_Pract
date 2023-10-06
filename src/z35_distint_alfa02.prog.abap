*&---------------------------------------------------------------------*
*& Report Z35_DISTINT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z35_DISTINT_ALFA02.

  data: suma type i,
        promedio type p decimals 2.

  select sum( DISTINCT seatsocc ) avg( DISTINCT seatsocc )
    from zsflightalfa02
    into ( suma,promedio ).

  IF sy-subrc eq 0.
      write: 'Suma: ',suma, 'Promedio: ', promedio.
  ENDIF.
