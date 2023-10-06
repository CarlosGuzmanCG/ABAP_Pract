*&---------------------------------------------------------------------*
*& Report Z_TI_AP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ti_ap_alfa02.

DATA: gt_empleados TYPE TABLE OF zemp_alfa02,
      gwa_empleado TYPE zemp_alfa02.

gwa_empleado-id = '1239876M'.
gwa_empleado-email = 'FERNANDO@LOGALIGROUP.COM'.
gwa_empleado-ape1 = 'DOMINGUEZ'.
gwa_empleado-ape2 = 'OTERO'.
gwa_empleado-nombre = 'FERNANDO'.
gwa_empleado-fechan = '19850924'.
gwa_empleado-fechann = '20180101'.

APPEND GWA_EMPLEADO TO GT_EMPLEADOS.
