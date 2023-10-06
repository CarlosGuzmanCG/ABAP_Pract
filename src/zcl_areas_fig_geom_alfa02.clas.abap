class ZCL_AREAS_FIG_GEOM_ALFA02 definition
  public
  create public .

public section.
protected section.
private section.

  methods PERIMETRO_RECTANGULO
    importing
      !BASE type I
      !ALTURA type I
    exporting
      !RESULTADO type I .
ENDCLASS.



CLASS ZCL_AREAS_FIG_GEOM_ALFA02 IMPLEMENTATION.


  method PERIMETRO_RECTANGULO.

    resultado = 2 * base +  2 * altura.

  endmethod.
ENDCLASS.
