*&---------------------------------------------------------------------*
*& Report ZPOO_01_TEMPLATE_METHOD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_01_TEMPLATE_METHOD_ALFA02.

class lcl_viaje definition abstract.

  public section.

  methods: realizar_viaje final,
           transporte_ida   ABSTRACT,
           dia_uno           ABSTRACT,
           dia_dos           ABSTRACT,
           transporte_vuelta ABSTRACT.

endclass.

class lcl_viaje implementation.

  method realizar_viaje.

    transporte_ida( ).
    dia_uno( ).
    dia_dos( ).
    transporte_vuelta( ).

  ENDMETHOD.

endclass.

class lcl_paquete_A definition INHERITING FROM lcl_viaje.

  public section.

  methods: transporte_ida    redefinition,
           dia_uno           redefinition,
           dia_dos           redefinition,
           transporte_vuelta redefinition.

  ENDCLASS.

  class lcl_paquete_A implementation.

    method transporte_ida.
      write / 'AVION CLASE A, IDA'.

    ENDMETHOD.

     method dia_uno .
      WRITE / 'LUGAR Y'.
    ENDMETHOD.

     method dia_dos .
      WRITE / 'LUGAR Z'.
    ENDMETHOD.

     method transporte_vuelta.
      WRITE / 'TRANSPORTE AVION CLASE A, REGRESO'.
    ENDMETHOD.

   endclass.

   class lcl_paquete_b definition INHERITING FROM lcl_viaje.

  public section.

  methods: transporte_ida    redefinition,
           dia_uno           redefinition,
           dia_dos           redefinition,
           transporte_vuelta redefinition.

  ENDCLASS.

  class lcl_paquete_B implementation.

    method transporte_ida.
      write / 'AVION CLASE B, IDA'.

    ENDMETHOD.

     method dia_uno .
      WRITE / 'LUGAR A'.
    ENDMETHOD.

     method dia_dos .
      WRITE / 'LUGAR S'.
    ENDMETHOD.

     method transporte_vuelta.
      WRITE / 'TRANSPORTE AVION CLASE B, REGRESO'.
    ENDMETHOD.

   endclass.

   START-OF-SELECTION.

   DATA: gr_pq_a type ref to lcl_paquete_A,
         gr_pq_b type ref to lcl_paquete_b.

   create object: gr_pq_a, gr_pq_b.

   gr_pq_a->realizar_viaje( ).

   gr_pq_b->realizar_viaje( ).
