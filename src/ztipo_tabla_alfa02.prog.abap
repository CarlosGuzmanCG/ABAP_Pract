*&---------------------------------------------------------------------*
*& Report ZTIPO_TABLA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztipo_tabla_alfa02.

CLASS lcl_empresa DEFINITION.

  PUBLIC SECTION.

  METHODS: alta_empleados IMPORTING tabla_empleados TYPE ZTT_DATOS_EMPL_ALFA02,
           listar_empleados.

  PRIVATE SECTION.

  DATA tabla_empleados TYPE ztt_datos_empl_alfa02.

ENDCLASS.

CLASS lcl_empresa IMPLEMENTATION.

  METHOD alta_empleados.

    me->tabla_empleados = tabla_empleados.

  ENDMETHOD.

  METHOD listar_empleados.

    DATA ls_empleados TYPE zestr_datos_empl_alfa02. "tipo de linea

    LOOP AT me->tabla_empleados INTO ls_empleados.

    WRITE / ls_empleados-nombre.

    ENDLOOP.

   ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  data: gt_empleados type ZTT_DATOS_EMPL_ALFA02,
        gs_empleados type zestr_datos_empl_alfa02,
        gr_empresa type ref to lcl_empresa.

  gs_empleados-nombre = 'ALEJANDRO'.

  APPEND GS_EMPLEADOS TO GT_EMPLEADOS.

    gs_empleados-nombre = 'LORENA'.

  APPEND GS_EMPLEADOS TO GT_EMPLEADOS.

  CREATE OBJECT gr_empresa.

  gr_empresa->alta_empleados( tabla_empleados = gt_empleados ).

  gr_empresa->listar_empleados( ).
