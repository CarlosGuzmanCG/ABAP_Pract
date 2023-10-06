*&---------------------------------------------------------------------*
*& Report ZPOO_01_FACTORY_METHOD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_01_FACTORY_METHOD_ALFA02.

interface lif_expediente.

  methods tipo_expediente.

ENDINTERFACE.

class lcl_expediente_obra definition.

  public section.

  interfaces lif_expediente.

  aliases tipo_expediente for lif_expediente~tipo_expediente.

endclass.

class lcl_expediente_obra implementation.

  method tipo_expediente.

    write / 'EXPEDIENTE OBRA'.

  ENDMETHOD.

endclass.

class LCL_EXPEDIENTE_SUMINISTRO definition.

  public section.

  interfaces lif_expediente.

  aliases tipo_expediente for lif_expediente~tipo_expediente.

endclass.

class LCL_EXPEDIENTE_SUMINISTRO implementation.

  method tipo_expediente.

    write / 'EXPEDIENTE SUMINISTRO'.

  ENDMETHOD.

endclass.

class lcl_factoria definition.

  public section.

  methods: crear_expediente IMPORTING tipo_exp type string
                RETURNING VALUE(object_form) type ref to lif_expediente.

endclass.

class lcl_factoria implementation.

  method crear_expediente.

    CASE tipo_exp.
      WHEN 'OBRA'.
        create object object_form type lcl_expediente_obra.
      WHEN 'SUMINISTRO'.
        create object object_form type LCL_EXPEDIENTE_SUMINISTRO.
    ENDCASE.

  endmethod.

endclass.

START-OF-SELECTION.

  data: gr_if_exp type ref to lif_expediente,
        gr_factoria type ref to lcl_factoria.

  create object gr_factoria.

  gr_if_exp = gr_factoria->crear_expediente( tipo_exp = 'OBRA' ).

  gr_if_exp->tipo_expediente( ).

  gr_if_exp = gr_factoria->crear_expediente( tipo_exp = 'SUMINISTRO' ).

  gr_if_exp->tipo_expediente( ).
