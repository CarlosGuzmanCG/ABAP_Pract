*&---------------------------------------------------------------------*
*& Report ZCDS_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCDS_ALFA02.

DATA gv_plan type s_planetye.

cl_demo_input=>request( changing field = gv_plan ).

select from ZB_04_01_ALFA02 as cds
    fields cds~carrid, cds~connid, cds~planetype,
    \_PLANE-seatsmax,
    \_PLANE-weight,
    \_PLANE-wei_unit
    WHERE cds~planetype EQ @gv_plan
    into table @data(gt_zvb).
