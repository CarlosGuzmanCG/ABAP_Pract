*&---------------------------------------------------------------------*
*& Report Z38_HAVING_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z38_HAVING_ALFA02.

  data: begin of sc,
    carrid type S_CARR_ID,
    cityfrom type S_FROM_CIT,
    lv_count type i,
    end of sc.

  select carrid cityfrom count(*) from zspflialfa02
    into (sc-carrid, sc-cityfrom, sc-lv_count)
    group by carrid cityfrom HAVING cityfrom = 'FRANKFURT'
    ORDER BY carrid.

    write: / sc-carrid, sc-cityfrom, sc-lv_count.

  endselect.
