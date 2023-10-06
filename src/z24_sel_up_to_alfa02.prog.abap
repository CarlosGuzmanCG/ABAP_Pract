*&---------------------------------------------------------------------*
*& Report Z24_SEL_UP_TO_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z24_SEL_UP_TO_ALFA02.

  data: gt_zs1 type table of zsflightalfa02,
        gt_zs2 type table of zsflightalfa02.

  select * from zsflightalfa02
    into table gt_zs1 Up To 3 rows.


  IF sy-subrc eq 0.

     select * from zsflightalfa02
       into table gt_zs2 for all entries in gt_zs1
       where carrid eq gt_zs1-carrid and connid eq gt_zs1-connid.

       IF sy-subrc eq 0.

          write sy-dbcnt.

         cl_demo_output=>display( gt_zs2 ).

       ENDIF.

  ENDIF.
