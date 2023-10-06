FUNCTION Z_MF_MATERIALES_ALFA02.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     REFERENCE(DATE_FROM) TYPE  ERSDA
*"     REFERENCE(DATE_TO) TYPE  ERSDA
*"     REFERENCE(IV_LISTAR) TYPE  FLAG OPTIONAL
*"  TABLES
*"      TI_MATERIALES STRUCTURE  MARA OPTIONAL
*"  EXCEPTIONS
*"      EX_SIN_MATERIALES
*"----------------------------------------------------------------------
DATA lwa_materiales type mara.

select * from mara
  into table TI_MATERIALES
  where ersda BETWEEN date_from and date_to.

  if sy-subrc eq 0 AND IV_LISTAR EQ ABAP_TRUE.

    LOOP AT TI_MATERIALES into lwa_materiales.

      write / lwa_materiales-MATNR.

    ENDLOOP.

    ELSE.

      raise EX_SIN_MATERIALES.

  endif.

ENDFUNCTION.
