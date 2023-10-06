*&---------------------------------------------------------------------*
*& Report ZPOO_52_TEMPLATE_METHOD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_52_TEMPLATE_METHOD_ALFA02.

CLASS lcl_juego definition ABSTRACT.

  protected section.


  data contador_juego type i.

  methods: inicializar_juego abstract,
           crear_juego abstract importing jugador type i,

           finalizar_juego abstract RETURNING VALUE(finalizado) type abap_bool,

           imprimir_ganador abstract,

           jugar final importing jugadores type i.

ENDCLASS.


class lcl_juego implementation.

  method jugar.

    data: lv_jugador type i.

    me->contador_juego = jugadores.

    inicializar_juego( ).

    WHILE finalizar_juego( ) ne abap_false.

      crear_juego( jugador = lv_jugador ).

      lv_jugador = lv_jugador + 1.

    ENDWHILE.

    imprimir_ganador( ).


  endmethod.

endclass.
