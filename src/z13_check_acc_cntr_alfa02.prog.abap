*&---------------------------------------------------------------------*
*& Report z13_check_acc_cntr_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z13_check_acc_cntr_alfa02.

select from ZB_13_AIRL_ALFA02
        fields *
        order by Airline
        into table @data(gt_result).

if  sy-subrc eq 0.
    cl_demo_output=>display( gt_result ).
else.
    write 'No hay datos para listar'.
endif.
