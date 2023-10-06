*&---------------------------------------------------------------------*
*& Report Z_LLAMADA_MF_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_llamada_mf_alfa02.

data gt_facturas type table of vbrk.

CALL FUNCTION 'Z_LISTAR_FACTURAS_ALFA02'
  EXPORTING
    iv_fecha             = '20210726'
    iv_listar            = abap_true
 TABLES
   TABLA_FACTURAS       = gt_facturas
          EXCEPTIONS
            EX_SIN_FACTURAS = 1
            .


IF sy-subrc = 1.
              write / 'No existe facturas '.
            ENDIF.

if gt_facturas is not initial.

  write / 'Existen facturas'.

endif.
