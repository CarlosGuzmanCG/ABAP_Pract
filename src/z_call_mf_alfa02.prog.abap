*&---------------------------------------------------------------------*
*& Report Z_CALL_MF_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_call_mf_alfa02.


CALL FUNCTION 'Z_MF_MATERIALES_ALFA02'
  EXPORTING
    date_from           = '20120101'
    date_to             = '20121231'
   IV_LISTAR           = ABAP_TRUE
         EXCEPTIONS ex_sin_materiales = 1 .


IF sy-subrc eq 1.
  write 'No existen materiales en el rango de fecha '.
ENDIF.
