class ZCL_FAMILY_ALFA02 definition
  public
  create public .

public section.

  data ID_MEMBER_FAMILY type NUMC10 .

  methods INSERT_MEMBER_FAMILY
    importing
      !ID_EMPLEADO type ZA23_ID_FAMILIAR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_FAMILY_ALFA02 IMPLEMENTATION.


  method INSERT_MEMBER_FAMILY.

    write id_empleado.

  endmethod.
ENDCLASS.
