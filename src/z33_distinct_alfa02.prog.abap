*&---------------------------------------------------------------------*
*& Report Z33_DISTINCT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z33_DISTINCT_ALFA02.

  data: gv_capacity_seats type s_smax_b,
        gv_occupied_seats type s_socc_b.

  select avg( DISTINCT seatsmax_b )
         sum( distinct seatsocc_b )
    from zsflightalfa02
    into ( gv_capacity_seats, gv_occupied_seats ).

  IF sy-subrc eq 0.
     write: / gv_capacity_seats,
            / gv_occupied_seats.
  ENDIF.
