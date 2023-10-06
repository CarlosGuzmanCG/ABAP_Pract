*&---------------------------------------------------------------------*
*& Report Z39_DYNAMIC_TABLE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z39_DYNAMIC_TABLE_ALFA02.

  parameters pa_table type c length 16.

  types: begin of gty_content,
    carrid type s_carr_id,
    commid type s_conn_id,
    end of gty_content.

  data gt_content type table of gty_content.

try.
    select carrid commid from (pa_table)
      into table gt_content.
CATCH cx_sy_dynamic_osql_semantics.
  write 'El nombre de la tabla no existe'.
endtry.

IF sy-subrc eq 0 and gt_content[] is not initial.
   cl_demo_output=>display( gt_content ).
ENDIF.
