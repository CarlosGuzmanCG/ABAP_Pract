*&---------------------------------------------------------------------*
*& Report z_tf_so_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_tf_so_alfa02.

TABLES SFLIGHT.

SELECT-OPTIONS SO_FLD FOR SFLIGHT-FLDATE.

DATA: GV_WHERE TYPE STRING.

START-OF-SELECTION.

TRY.

 gv_where =   CL_SHDB_SELTAB=>combine_seltabs(
   EXPORTING
    it_named_seltabs = VALUE #( ( name = 'FLDATE' dref = REF #( so_fld[] ) ) )
    iv_client_field = 'MANDT'
   ).
CATCH CX_SHDB_EXCEPTION INTO DATA(GO_EXCP).
    WRITE GO_EXCP->get_text( ).
ENDTRY.

WRITE  gv_where.

SELECT * FROM Z_TF_SO_ALFA02( SEL_OPT = @gv_where )
    INTO TABLE @DATA(GT_RESULT).

   IF  SY-SUBRC EQ 0.
        CL_DEMO_OUTPUT=>DISPLAY( GT_RESULT ).
    ENDIF.
