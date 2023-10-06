*&---------------------------------------------------------------------*
*& Report Z33_GROUP_BY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z33_group_by_alfa02.

types: begin of gty_count,
    count type i,
    end of gty_count.

  DATA: gt_count type table of gty_count,
        gv_count TYPE i.

  SELECT COUNT( * ) FROM zspflialfa02
    INTO gv_count
    GROUP BY carrid.

    WRITE gv_count.

  ENDSELECT.

  select count( DISTINCT cityfrom ) from zspflialfa02
    into table gt_count
*    where carrid eq 'LH'
    GROUP BY carrid.

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_count ).
    ENDIF.
