*&---------------------------------------------------------------------*
*& Report zdpp_seg_lang_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdpp_seg_lang_alfa02.

data: lt_seg_key type table of ZIF_ZDPP_SEG_LANG_ALFA02=>it_seg_key,
      et_relevance_value type table of ZIF_ZDPP_SEG_LANG_ALFA02=>et_relevance_value.

try.

call DATABASE PROCEDURE zdpp_seg_lang_alfa02
  EXPORTING
    it_seg_key         = lt_seg_key
  IMPORTING
    et_relevance_value = et_relevance_value.


catch cx_sy_db_procedure_sql_error into data(go_excep).

write go_excep->get_text( ).

ENDTRY.

cl_demo_output=>display( et_relevance_value ).
