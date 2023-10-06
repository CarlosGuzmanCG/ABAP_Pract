*&--------------------------------------------------------------------*
*& Report ZESTR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zestr_alfa02.

TYPES: BEGIN OF empleados,
        num_dir         TYPE znum_dir_alfa02, " Elemento de datos
        pais            TYPE land1,
        poblacion       TYPE ad_city1,
        distrito        TYPE ad_city2,
        agr_reg         TYPE regiogroup,
        code_post_pobl 	TYPE ad_pstcd1,
        END OF empleados.

   DATA ls_empleados1 TYPE empleados.

        ls_empleados1-num_dir     = 1.

 data ls_empleados2 type zestr_empleados_alfa02.

 ls_empleados2-num_dir = 2.
