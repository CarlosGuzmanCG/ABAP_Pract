*&---------------------------------------------------------------------*
*& Report Z41_DYNAMIC_COND_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z41_DYNAMIC_COND_ALFA02.

  parameters: pa_table type c length 16,
              pa_col   type c length 50,
              pa_where type c length 50.

  field-symbols <gt_itab> type STANDARD TABLE.

  data: gr_tref type ref to data,
        grx_exception type ref to cx_root.

try.
  data(gr_comp_table) = cast cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( pa_table ) )->get_components( ).

  data(gr_struct_type) = cl_abap_structdescr=>create( gr_comp_table ).

  data(gr_table_type) = cl_abap_tabledescr=>create( gr_struct_type ).

  create data gr_tref type handle gr_table_type.

  ASSIGN gr_tref->* to <gt_itab>.

  select (pa_col) from (pa_table)
    into corresponding fields of table <gt_itab>
    where (pa_where).

  catch cx_root into grx_exception.
    write grx_exception->get_text( ).

  endtry.

  IF <gt_itab> is not initial.
    cl_demo_output=>display( <gt_itab> ).
  ENDIF.
