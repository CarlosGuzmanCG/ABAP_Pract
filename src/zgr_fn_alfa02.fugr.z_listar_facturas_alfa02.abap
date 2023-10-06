FUNCTION z_listar_facturas_alfa02 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_FECHA) TYPE  FKDAT
*"     REFERENCE(IV_LISTAR) TYPE  FLAG OPTIONAL
*"  TABLES
*"      TABLA_FACTURAS STRUCTURE  VBRK OPTIONAL
*"  EXCEPTIONS
*"      EX_SIN_FACTURAS
*"----------------------------------------------------------------------

  DATA iwa_facturas TYPE vbrk.

  SELECT * FROM vbrk
    INTO TABLE tabla_facturas
    WHERE fkdat EQ iv_fecha.

  IF sy-subrc EQ 0 AND iv_listar EQ 'X'.

    LOOP AT tabla_facturas INTO iwa_facturas.

      WRITE / iwa_facturas-vbeln.

    ENDLOOP.

  ELSEIF sy-subrc NE 0.

    RAISE ex_sin_facturas.

  ENDIF.


ENDFUNCTION.
