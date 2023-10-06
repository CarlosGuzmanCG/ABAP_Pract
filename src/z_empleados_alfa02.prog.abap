*&---------------------------------------------------------------------*
*& Report Z_EMPLEADOS_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_empleados_alfa02.

DATA: gt_empleados TYPE STANDARD TABLE OF zemp_alfa02,
      gwa_empleado TYPE zemp_alfa02.

gwa_empleado-id  = '575754'.
gwa_empleado-email = 'cas1os@cucv.com'.
gwa_empleado-ape1 = 'VfA'.
gwa_empleado-ape2 = 'AdfAS'.
gwa_empleado-nombre = 'CARdfOS'.
gwa_empleado-fechan = '19910801'.
gwa_empleado-fechann = '20200314'.

APPEND gwa_empleado TO gt_empleados.
