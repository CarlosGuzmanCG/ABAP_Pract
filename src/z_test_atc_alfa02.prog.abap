*&---------------------------------------------------------------------*
*& Report z_test_atc_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_atc_alfa02.

select * from sflight
    into table @data(gt_flights).


select * from spfli
    for all entries in @gt_flights
    where carrid eq @gt_flights-carrid
    into table @data(gt_results).



 select * from bkpf
    into table @Data(gt_invoices). "#EC CI_NOWHERE

 loop at gt_flights ASSIGNING FIELD-SYMBOL(<gs_flights>).

    select * from spfli
        into table @data(gt_spfli)
        where carrid eq @<gs_flights>-carrid.
 endloop.
