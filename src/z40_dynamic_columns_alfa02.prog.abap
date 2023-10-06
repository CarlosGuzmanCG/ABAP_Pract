*&---------------------------------------------------------------------*
*& Report Z40_DYNAMIC_COLUMNS_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z40_DYNAMIC_COLUMNS_ALFA02.

  parameters: pa_table type c length 16,
              pa_col   type c length 50.

  types: begin of gty_content,
    carrid type s_carr_id,
    connid type s_conn_id,
   end of gty_content.

   data gt_content type STANDARD TABLE OF gty_content.

 TRY.
   select (pa_col) from (pa_table)
     into corresponding fields of table gt_content.

 CATCH cx_sy_dynamic_osql_semantics.
     write 'El nombre de la tabla no existe'.
 ENDTRY.

 IF sy-subrc eq 0 and gt_content[] is not initial.
    cl_demo_output=>display( gt_content ).
 ENDIF.
