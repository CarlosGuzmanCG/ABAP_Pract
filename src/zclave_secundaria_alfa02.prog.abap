*&---------------------------------------------------------------------*
*& Report ZCLAVE_SECUNDARIA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCLAVE_SECUNDARIA_ALFA02.

types:
     begin of ty_empleados,
      nombre type znombre_alfa02,
      apellido1 type zapellido1_alfa02,
      apellido2 type zapellido2_alfa02,
      cat_prof type zcateg_prof_alfa02,
      status type zstatus_alfa02,
     end of ty_empleados.

     types:
            tt_empleados type STANDARD TABLE OF ty_empleados
            with key nombre apellido1 " Con llave primaria
            with non-UNIQUE SORTED KEY cat_status components "Ordenado
            cat_prof status.

     data: gt_empleados type tt_empleados,
           gs_empleados type ty_empleados.

     CONSTANTS: gc_cat_prof type zcateg_prof_alfa02 value '05', "Programador
                gc_status   type zstatus_alfa02     value 'A'. " Alta

     LOOP AT gt_empleados into gs_empleados where nombre eq 'Alberto'
       and apellido1 eq 'Ruiz'.

     ENDLOOP.


     " Busqueda ordenada
     LOOP AT gt_empleados into gs_empleados using key cat_status
           where cat_prof eq gc_cat_prof
           and status eq gc_status.

     ENDLOOP.

     read table gt_empleados into gs_empleados
          with key cat_status components cat_prof = gc_cat_prof
                                         status   = gc_status.

     data: gt_empl1 type ZTT_DATOS_EMPL_ALFA02,
           gs_empl      type zestr_datos_empl_alfa02.

     loop at gt_empl1 into gs_empl
             using key cat_status
             where cat_prof eq gc_cat_prof
             and status eq gc_status.

     endloop.
