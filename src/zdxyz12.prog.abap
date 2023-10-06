*&---------------------------------------------------------------------*
*& Report ZDXYZ12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDXYZ12.

data: gv_url         type char255,
      go_container   type ref to cl_gui_custom_container,
      go_html_viewer type ref to cl_gui_html_viewer,
      GV_FRAME        TYPE C.

INCLUDE ZTEST_URL_FORM.

START-OF-SELECTION.

call screen 100.
