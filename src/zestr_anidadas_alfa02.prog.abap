*&---------------------------------------------------------------------*
*& Report ZESTR_ANIDADAS_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zestr_anidadas_alfa02.


DATA: Gs_DATOS_EMPLEADOS TYPE zestr_datos_empl_alfa02,
      GS_unidad_org      TYPE zestr_und_org_alfa02.


  Gs_DATOS_EMPLEADOS-nombre = 'ALBERTO'.
  Gs_DATOS_EMPLEADOS-apellido1 = 'RUIZ'.
  Gs_DATOS_EMPLEADOS-direccion-num_dir = '0876'.

  GS_unidad_org-res_ventas-nombre = 'CARLOS'.
  GS_unidad_org-res_ventas-apellido1 = 'Carrero'.
  GS_unidad_org-res_ventas-direccion-num_dir = '0899'.

  gs_unidad_org-empleado = gs_datos_empleados.

  write: / 'Empleado = ', gs_unidad_org-empleado-nombre.
