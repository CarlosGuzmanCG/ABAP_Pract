*&---------------------------------------------------------------------*
*& Report Z43_OUTER_JOIN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z43_OUTER_JOIN_ALFA02.

  types: begin of data_cl,
    planetype type ZSAPLANEALFA02-planetype,
    carrid type ZSFLIGHTALFA02-carrid,
    connid type ZSFLIGHTALFA02-connid,
    end of data_cl.

    data gt_zs type table of data_cl.

  select a~planetype b~carrid b~connid from ( ZSAPLANEALFA02 as a
    left outer join ZSFLIGHTALFA02 AS b on a~seatsmax_b = b~seatsmax_b )
    into table gt_zs order by carrid connid DESCENDING.

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_zs ).
    ENDIF.
