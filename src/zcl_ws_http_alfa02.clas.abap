class ZCL_WS_HTTP_ALFA02 definition
  public
  inheriting from ZCL_CONEXION_HTTP_ALFA02
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !PROTOCOLO_WS type STRING .
protected section.
private section.

  data PROTOCOLO_WS type STRING .
ENDCLASS.



CLASS ZCL_WS_HTTP_ALFA02 IMPLEMENTATION.


  method CONSTRUCTOR.

    super->constructor( request_method =  'OSI').

    me->protocolo_ws = protocolo_ws.

  endmethod.
ENDCLASS.
