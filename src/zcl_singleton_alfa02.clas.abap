class ZCL_SINGLETON_ALFA02 definition
  public
  create private .

public section.

  data HORA_CREACION type SYUZEIT read-only .

  methods CONSTRUCTOR .
  class-methods OBTENER_INSTANCIA
    exporting
      !INSTANCIA type ref to ZCL_SINGLETON_ALFA02 .
protected section.
private section.

  class-data OBJETO type ref to ZCL_SINGLETON_ALFA02 .
ENDCLASS.



CLASS ZCL_SINGLETON_ALFA02 IMPLEMENTATION.


  method CONSTRUCTOR.

    HORA_CREACION = SY-UZEIT.

  endmethod.


  method OBTENER_INSTANCIA.

    IF zcl_singleton_alfa02=>objeto is not bound.

      create object objeto.

      instancia = zcl_singleton_alfa02=>objeto.

    ELSE.

      instancia = zcl_singleton_alfa02=>objeto.

    ENDIF.



  endmethod.
ENDCLASS.
