*&---------------------------------------------------------------------*
*& Report zdppalfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdppalfa02.

data: iv_seg_value type ZIF_ZDPP_ALFA02=>iv_seg_value,
      it_work_tab  type table of ZIF_ZDPP_ALFA02=>it_work_tab,
      et_out type table of ZIF_ZDPP_ALFA02=>et_out.

      call DATABASE PROCEDURE zdpp_alfa02
        EXPORTING
          iv_seg_value = iv_seg_value
          it_work_tab  = it_work_tab
        IMPORTING
          et_out       = et_out.

      cl_demo_output=>display( et_out ).
