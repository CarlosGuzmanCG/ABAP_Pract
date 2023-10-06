class ZCL_PEDIDO_ALFA02 definition
  public
  create public
  shared memory enabled .

public section.

  methods SET_FECHA_CREACION
    importing
      !FECHA_CREACION type SYDATUM .
  methods GET_FECHA_CREACION
    exporting
      !FECHA_CREACION type SYDATUM .
  methods SET_HORA_PEDIDO
    importing
      !HORA_PEDIDO type SYUZEIT .
  methods GET_HORA_PEDIDO
    exporting
      !HORA_PEDIDO type SYUZEIT .
protected section.
private section.

  data FECHA_CREACION type SYDATUM .
  data HORA_PEDIDO type SYUZEIT .
ENDCLASS.



CLASS ZCL_PEDIDO_ALFA02 IMPLEMENTATION.


  method GET_FECHA_CREACION.

    fecha_creacion = me->fecha_creacion.

  endmethod.


  method GET_HORA_PEDIDO.

    hora_pedido = me->hora_pedido.

  endmethod.


  method SET_FECHA_CREACION.

    me->fecha_creacion = fecha_creacion.

  endmethod.


  method SET_HORA_PEDIDO.

    me->hora_pedido = hora_pedido.

  endmethod.
ENDCLASS.
