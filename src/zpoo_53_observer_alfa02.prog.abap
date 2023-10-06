*&---------------------------------------------------------------------*
*& Report ZPOO_53_OBSERVER_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_53_observer_alfa02.

CLASS lcl_procesos DEFINITION.

  PUBLIC SECTION.

  METHODS establecer_estado IMPORTING estado TYPE string.

  EVENTS estado_modificado EXPORTING VALUE(nuevo_estado) TYPE string.

  PRIVATE SECTION.

  DATA estado_actual  TYPE string.

ENDCLASS.

CLASS lcl_procesos IMPLEMENTATION.

  METHOD establecer_estado.

    estado_actual = estado.

    SKIP 2.

    WRITE: / 'Nuevo estado en los procesos....', estado_actual.

    RAISE EVENT estado_modificado EXPORTING nuevo_estado = estado_actual.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_observador DEFINITION ABSTRACT.

  PUBLIC SECTION.

  METHODS on_estado_modificado ABSTRACT
  FOR EVENT estado_modificado OF lcl_procesos IMPORTING nuevo_estado.

ENDCLASS.

CLASS lcl_dep_ventas DEFINITION INHERITING FROM lcl_observador.

  PUBLIC SECTION.

  METHODS on_estado_modificado REDEFINITION.

ENDCLASS.

CLASS lcl_dep_ventas IMPLEMENTATION.

  METHOD on_estado_modificado.

    WRITE: / 'Departamento de ventas - Nuevo estado en el proceso....', nuevo_estado.

   ENDMETHOD.

ENDCLASS.


CLASS lcl_dep_facturacion DEFINITION INHERITING FROM lcl_observador.

  PUBLIC SECTION.

  METHODS on_estado_modificado REDEFINITION.


ENDCLASS.

CLASS lcl_dep_facturacion IMPLEMENTATION.

  METHOD on_estado_modificado.

    WRITE: / 'Departamento de facturacion  - Nuevo estado en el proceso....', nuevo_estado.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

DATA: gr_procesos     TYPE REF TO lcl_procesos,
      gr_dep_ventas   TYPE REF TO lcl_dep_ventas,
      gr_dep_fact     TYPE REF TO lcl_dep_facturacion.


" Instanciamos los objetos
  CREATE OBJECT: gr_procesos   ,
                 gr_dep_ventas ,
                 gr_dep_fact   .

  " Establecemos manejadores
  SET HANDLER :
                gr_dep_ventas->on_estado_modificado FOR gr_procesos,
                gr_dep_fact->on_estado_modificado FOR gr_procesos.

  " Establecer nuevos estados

  gr_procesos->establecer_estado( estado =  'Producto 1' ).

  gr_procesos->establecer_estado( estado =  'Producto 2' ).
