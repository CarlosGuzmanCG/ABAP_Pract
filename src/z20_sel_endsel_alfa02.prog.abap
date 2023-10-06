*&---------------------------------------------------------------------*
*& Report Z20_SEL_ENDSEL_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z20_SEL_ENDSEL_ALFA02.

  data: gwa_zs type zspflialfa02,
        gt_zs type table of zspflialfa02.

  select * from zspflialfa02 into gwa_zs.

    IF gwa_zs-distid <> 'MI'.

       gwa_zs-distid = 'MI'.

       MULTIPLY gwa_zs-distance by '0.621371'.

    ENDIF.

    APPEND gwa_zs to gt_zs.

  endselect.


  IF sy-subrc eq 0.

     cl_demo_output=>display( gt_zs ).

  ENDIF.
