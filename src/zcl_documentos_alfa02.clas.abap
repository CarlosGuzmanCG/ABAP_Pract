class ZCL_DOCUMENTOS_ALFA02 definition
  public
  create public .

public section.

  interfaces ZIF_DOCUMENTOS_ALFA02 .

  aliases ACTIVATION
    for ZIF_DOCUMENTOS_ALFA02~ACTIVATION .

  class-data CLAVE_OPERACION type KTOSL .

  events DOCUMENTO_CADUCADO
    exporting
      value(FECHA) type SYDATUM .

  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR
    importing
      !NUM_DOC type BELNR .
  class-methods ANADIR_CLAVE_OPERACION
    importing
      !CLAVE_OPERACION type KTOSL .
  methods SET_PLAN_CUENTAS
    importing
      !PLAN_CUENTAS type KTOPL .
  methods GET_PLAN_CUENTAS
    exporting
      !PLAN_CUENTAS type KTOPL .
  methods CREAR_AVISOS .
  class-methods GENERAR_AVISOS
    importing
      !DEUDOR type KUNNR .
protected section.

  data PLAN_CUENTAS type KTOPL .
private section.

  aliases DOC_VENTAS
    for ZIF_DOCUMENTOS_ALFA02~DOC_VENTAS .
  aliases SET_DOC_VENTAS
    for ZIF_DOCUMENTOS_ALFA02~SET_DOC_VENTAS .
  aliases DEUDOR_DESCONOCIDO
    for ZIF_DOCUMENTOS_ALFA02~DEUDOR_DESCONOCIDO .
  aliases SIN_USUARIO_RESP
    for ZIF_DOCUMENTOS_ALFA02~SIN_USUARIO_RESP .
  aliases DETALLES_DOC
    for ZIF_DOCUMENTOS_ALFA02~DETALLES_DOC .
  aliases RANGO_POS_DOC
    for ZIF_DOCUMENTOS_ALFA02~RANGO_POS_DOC .

  constants CONT_MODIF type BWMOD value '32A' ##NO_TEXT.
  data NUM_DOC type BELNR .
ENDCLASS.



CLASS ZCL_DOCUMENTOS_ALFA02 IMPLEMENTATION.


  method ANADIR_CLAVE_OPERACION.

    zcl_documentos_alfa02=>clave_operacion = !clave_operacion.

  endmethod.


  method CLASS_CONSTRUCTOR.

    write 'documentos creados '.

  endmethod.


  method CONSTRUCTOR.

    me->num_doc = num_doc.

  endmethod.


  method CREAR_AVISOS.

    raise event: documento_caducado exporting fecha = sy-datum,
                 sin_usuario_resp exporting doc_ventas  = zif_documentos_alfa02~doc_ventas.



  endmethod.


  method GENERAR_AVISOS.

    data lv_kunnr type kunnr.

    select single kunnr from kna1
      into lv_kunnr
      where kunnr eq !deudor.

      if sy-subrc ne 0.

         raise event deudor_desconocido EXPORTING deudor = !deudor.

    endif.

  endmethod.


  method GET_PLAN_CUENTAS.

    !plan_cuentas = me->plan_cuentas.

  endmethod.


  method SET_PLAN_CUENTAS.

    me->plan_cuentas = !plan_cuentas.

  endmethod.


method zif_documentos_alfa02~set_doc_ventas.

endmethod.
ENDCLASS.
