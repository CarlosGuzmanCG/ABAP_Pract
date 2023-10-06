*&---------------------------------------------------------------------*
*& Report ZPOO_51_FACTORY_METHOD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_51_FACTORY_METHOD_ALFA02.

interface if_forma.

  methods dibujar_forma.

ENDINTERFACE.

class lcl_circulo definition.

  public section.

  interfaces if_forma.

  aliases dibujar_forma for if_forma~dibujar_forma.

endclass.

class lcl_circulo IMPLEMENTATION.

  method dibujar_forma.

    write 'Dibujar circulo'.

   ENDMETHOD.

endclass.

class lcl_triangulo definition.

  public section.

  interfaces if_forma.

  aliases dibujar_forma for if_forma~dibujar_forma.

endclass.

class lcl_triangulo IMPLEMENTATION.

  method dibujar_forma.

    write 'Dibujar triangulo'.

   ENDMETHOD.

endclass.

  class lcl_factoria definition.

  public section.

    METHODs obtener_forma importing tipo_forma type string
      RETURNING VALUE(objeto_forma) type ref to if_forma.

 ENDCLASS.

 class lcl_factoria implementation.

   method obtener_forma.

     CASE TIPO_FORMA.
     	WHEN 'CIRCULO'.
        create object objeto_forma type lcl_circulo.

      WHEN 'TRIANGULO'.
        create object objeto_forma type lcl_triangulo.

        when OTHERS.

     ENDCASE.

   ENDMETHOD.

 endclass.

 START-OF-SELECTION.


 data: gr_forma     type ref to if_forma,
       gr_factoria  type ref to lcl_factoria.

 CREATE object gr_factoria.

 gr_forma = gr_factoria->obtener_forma( tipo_forma = 'CIRCULO' ).

 gr_forma->dibujar_forma( ).

 gr_forma = gr_factoria->obtener_forma( tipo_forma = 'TRIANGULO' ).

 gr_forma->dibujar_forma( ).
