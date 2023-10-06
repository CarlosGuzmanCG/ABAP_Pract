interface ZIF_DOCUMENTOS_ALFA02
  public .

  type-pools ZTYPE .

  types ACTIVATION type ref to CL_AAB_ID .
  types:
    begin of DETALLES_DOC,
        num_doc type belnr,
        proveedor type lifnr, end of detalles_doc .
  types RANGO_POS_DOC type /CWM/R_VBELN .

  data DOC_VENTAS type VBELN_VA .

  class-events DEUDOR_DESCONOCIDO
    exporting
      value(DEUDOR) type KUNNR optional .
  events SIN_USUARIO_RESP
    exporting
      value(DOC_VENTAS) type VBELN_VA optional .

  methods SET_DOC_VENTAS
    importing
      !DOC_VENTAS type VBELN_VA .
endinterface.
