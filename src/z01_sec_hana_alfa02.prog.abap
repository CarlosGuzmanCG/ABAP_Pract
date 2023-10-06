*&---------------------------------------------------------------------*
*& Report Z01_SEC_HANA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z01_SEC_HANA_ALFA02.

select * "carrid, connid, cityfrom, cityto
    from spfli
        up to 10 rows
            connection hanadb
            into table @data(gt_spfli).


if sy-subrc eq 0.
 cl_demo_output=>display( gt_spfli ).
else.
 write 'sin datos'.
endif.
