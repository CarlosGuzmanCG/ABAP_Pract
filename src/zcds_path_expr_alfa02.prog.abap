*&---------------------------------------------------------------------*
*& Report ZCDS_PATH_EXPR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCDS_PATH_EXPR_ALFA02.

data gv_carrid type s_carr_id.

cl_demo_input=>request( changing field = gv_carrid ). " entrada

select from zv_pe_07_alfa02 as cds
    fields cds~carrname as carrname,
           \_flights-connid as connid, " asociacion
           \_flights\_flights-fldate as fldate,
           \_flights\_airports-name as name
           where cds~carrid eq @gv_carrid
           into table @data(gt_results).

if sy-subrc eq 0.
    cl_demo_output=>display( gt_results ) ." salida
endif.
