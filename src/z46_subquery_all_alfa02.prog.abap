*&---------------------------------------------------------------------*
*& Report Z46_SUBQUERY_ALL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z46_SUBQUERY_ALL_ALFA02.

  types: begin of gty_spfli,
    carrid type s_carr_id,
    count type i,
    end of gty_spfli.

    data gt_spfli type STANDARD TABLE OF gty_spfli.

    SELECT CARRID COUNT(*) AS COUNT
      from zspflialfa02
      into table gt_spfli
      group by carrid
      having count( * ) >= all ( select count( * ) from zspflialfa02 group by carrid ).

  IF sy-subrc eq 0.
     cl_demo_output=>display( gt_spfli ).
  ENDIF.
