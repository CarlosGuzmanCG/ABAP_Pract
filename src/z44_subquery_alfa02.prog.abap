*&---------------------------------------------------------------------*
*& Report Z44_SUBQUERY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z44_SUBQUERY_ALFA02.

  data gwa_zs type table of zsflightalfa02.

  select * from zsflightalfa02 into table gwa_zs
    where planetype eq ( select planetype from zsaplanealfa02 where planetype
    eq '737-400' ).

IF sy-subrc eq 0.
   cl_demo_output=>display( gwa_zs ).
ENDIF.
