class ZCL_CONEXION_HTTP_ALFA02 definition
  public
  create public .

public section.

  interfaces ZIF_GRUPO_ALFA02 .

  aliases SET_METODO
    for ZIF_GRUPO_ALFA02~SET_METODO .
  aliases AVISAR_CANAL_DISTRIBUICION
    for ZIF_GRUPO_ALFA02~AVISAR_CANAL_DISTRIBUICION .

  events ERROR_CONEXION .

  methods SET_REQUEST
    importing
      !REQUEST_URL type STRING .
  methods GET_REQUEST
    exporting
      !REQUEST_URL type STRING .
  methods SET_SERVER_PROTOCOL
    importing
      !SERVER_PROTOCOL type STRING .
  methods GET_SERVER_PROTOCOL
    exporting
      !SERVER_PROTOCOL type STRING .
  methods CONSTRUCTOR
    importing
      !REQUEST_METHOD type STRING .
  class-methods CLASS_CONSTRUCTOR .
  methods CREA_CONEXION .
  methods COMPRUEBA_AUTORIZACION .
protected section.

  aliases DES_MERCANCIA
    for ZIF_GRUPO_ALFA02~DES_MERCANCIA .
  aliases GRUPO_CLIENTE
    for ZIF_GRUPO_ALFA02~GRUPO_CLIENTE .
private section.

  aliases DETALLES_GRUPO
    for ZIF_GRUPO_ALFA02~DETALLES_GRUPO .
  aliases DOCUMENTOS
    for ZIF_GRUPO_ALFA02~DOCUMENTOS .

  data REQUEST_URL type STRING .
  data SERVER_PROTOCOL type STRING .
  data REQUEST_METHOD type STRING .

  class-events SIN_AUTORIZACION .
ENDCLASS.



CLASS ZCL_CONEXION_HTTP_ALFA02 IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.
  endmethod.


  method COMPRUEBA_AUTORIZACION.

    raise event sin_autorizacion.

  endmethod.


  method CONSTRUCTOR.
    me->REQUEST_METHOD = REQUEST_METHOD.
  endmethod.


  method CREA_CONEXION.

    raise event error_conexion.

  endmethod.


  method GET_REQUEST.
    request_url = me->request_url.
  endmethod.


  method GET_SERVER_PROTOCOL.

    server_protocol = me->server_protocol.

  endmethod.


  method SET_REQUEST.
    me->request_url = request_url.
  endmethod.


  method SET_SERVER_PROTOCOL.
    me->server_protocol = server_protocol.
  endmethod.
ENDCLASS.
