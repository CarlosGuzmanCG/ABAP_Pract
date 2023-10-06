*&---------------------------------------------------------------------*
*& Report ZTABLA_BD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTABLA_BD_ALFA02.

  data gs_empleados type zemple_alfa02.

  gs_empleados-num_dir    = 1.
  gs_empleados-nombre     = 'Lorena'.
  gs_empleados-apellido1  = 'Garcia'.
  gs_empleados-apellido2  = 'Suárez'.
  gs_empleados-cat_prof   = '07'.
  gs_empleados-status     = 'A'.

  insert zemple_alfa02 from gs_empleados.

  if sy-subrc eq 0.
    WRITE 'Registro insertado correctamente....'.

  ELSE.

    WRITE 'El registro no se ha insertado'.

  endif.
