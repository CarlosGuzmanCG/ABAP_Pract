*&---------------------------------------------------------------------*
*& Report Z37_GROUP_BY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z37_GROUP_BY_ALFA02.

  data lv_cnt type i.

  select count(*) from zsflightalfa02
    into (lv_cnt)
    GROUP BY carrid.

    write: / lv_cnt.

    clear lv_cnt.

  ENDSELECT.
