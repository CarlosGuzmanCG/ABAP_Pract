*&---------------------------------------------------------------------*
*& Report ZPOO_54_MVC_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_54_MVC_ALFA02.

class lcl_empleado_modelo definition.

  public section.

  methods: constructor importing nombre type string
                                    roll type string,

           set_nombre importing nombre type string,
           get_nombre exporting nombre type string,

           set_roll importing roll type string,
           get_roll exporting roll type string.


  private section.

  data: nombre type string,

        roll type string.

endclass.

class lcl_empleado_modelo implementation.

  method constructor.

    me->nombre = nombre.

    me->roll = roll.

  endmethod.

  method set_nombre.
    me->nombre = nombre.
  endmethod.

  method get_nombre.
    nombre = me->nombre.
  endmethod.

  method set_roll.
    me->roll = roll.
  endmethod.

  method get_roll.
    roll = me->roll.
  endmethod.

endclass.

class lcl_empleado_vista definition.

    public section.

    methods display_empleado importing nombre type string
                                        roll  type string.

endclass.

  class lcl_empleado_vista implementation.

    method display_empleado.
      write: / 'Empleado....',
             / nombre,
             / roll.
    endmethod.

  endclass.

  class lcl_empleado_controlador definition.

    public SECTION.

    methods: set_modelo importing modelo type ref to lcl_empleado_modelo,
             get_modelo exporting modelo type ref to lcl_empleado_modelo,

             set_vista importing vista type ref to lcl_empleado_vista,
             get_vista EXPORTING vista type ref to lcl_empleado_vista.

             private section.

             data: modelo type ref to lcl_empleado_modelo,
                   vista type ref to lcl_empleado_vista.

  endclass.


  class lcl_empleado_controlador implementation.

      method set_modelo.
        me->modelo = modelo.
      ENDMETHOD.

      METHOD get_modelo.
        modelo = me->modelo.
      endmethod.

      method set_vista.

         data: lv_nombre type string,
               lv_roll type string.

         me->vista = vista.

          modelo->get_nombre(
            IMPORTING
              nombre = lv_nombre
          ).

          modelo->get_roll(
            IMPORTING
              roll = lv_roll
          ).

          vista->display_empleado(
            EXPORTING
              nombre = lv_nombre
              roll   = lv_roll
          ).

      endmethod.

      method get_vista.
        vista = me->vista.
      ENDMETHOD.

   endclass.

    parameters: pa_nomb type string,
                pa_roll type string.

   START-OF-SELECTION.

   data: gr_modelo type ref to lcl_empleado_modelo,
         gr_vista  type ref to lcl_empleado_vista,
         gr_controlador type ref to lcl_empleado_controlador.

   create object gr_modelo
     EXPORTING
       nombre = pa_nomb
       roll   = pa_roll.

   create object: gr_vista, gr_controlador.

   gr_controlador->set_modelo( modelo = gr_modelo ).

   gr_controlador->set_vista( vista = gr_vista ).
