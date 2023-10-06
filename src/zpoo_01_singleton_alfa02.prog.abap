*&---------------------------------------------------------------------*
*& Report ZPOO_01_SINGLETON_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_01_SINGLETON_ALFA02.

class lcl_context definition create private.


  public section.

  class-methods instancia RETURNING VALUE(cont_obj) type ref to lcl_context.

  private section.

  class-data context_object type ref to lcl_context.

endclass.

class lcl_context implementation.

  method instancia.

    IF lcl_context=>context_object is not bound .

        create object lcl_context=>context_object.

        context_object = lcl_context=>context_object.

    ELSE.

       context_object = lcl_context=>context_object.

    ENDIF.

  ENDMETHOD.

endclass.

START-OF-SELECTION.

data: gr_ins1 type ref to lcl_context, gr_ins2 type ref to lcl_context.

gr_ins1 = lcl_context=>instancia( ).
gr_ins2 = lcl_context=>instancia( ).
