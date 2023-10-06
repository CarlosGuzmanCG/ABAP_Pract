*&---------------------------------------------------------------------*
*& Report ztf_so_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztf_so_alfa02.

TABLES: MARC, makt.

    SELECT-OPTIONS : so_plant FOR marc-werks.
        PARAMETERS pa_lang type spras.
        DATA : gv_filter TYPE string.
    START-OF-SELECTION.

 TRY.
     gv_filter = cl_shdb_seltab=>combine_seltabs(
     EXPORTING
                   it_named_seltabs = VALUE #( ( name = 'WERKS' dref = REF #( so_plant[] ) ) ) ).
 CATCH cx_shdb_exception INTO DATA(GO_EXCP).
    WRITE GO_EXCP->get_text( ).
 ENDTRY.


     SELECT * FROM ztf_so_alfa02( sel_opt = @gv_filter, lang = @pa_lang ) INTO TABLE @DATA(gt_results).

     cl_demo_output=>display( gt_results ).
