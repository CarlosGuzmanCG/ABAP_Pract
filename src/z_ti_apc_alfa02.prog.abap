*&---------------------------------------------------------------------*
*& Report Z_TI_APC_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_TI_APC_ALFA02.

data gt_empleado type standard table OF zemp_alfa02 with header line.

gt_empleado-id = '56864720P'.
gt_empleado-email = 'LUIS_TAL@LOGALIGROUP.COM'.
gt_empleado-ape1 = 'GONZALES'.
gt_empleado-ape2 = 'TALAVERA'.
gt_empleado-nombre = 'LUIS'.
gt_empleado-fechan = '19900726'.
gt_empleado-fechann = '19900726'.


APPEND gt_empleado.
