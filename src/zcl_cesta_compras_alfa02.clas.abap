class ZCL_CESTA_COMPRAS_ALFA02 definition
  public
  create public
  shared memory enabled .

public section.

  data DOC_COMPRAS type ME_EKPO .

  methods SET_DOC_COMPRAS
    importing
      !DOC_COMPRAS type ME_EKPO .
  methods GET_DOC_COMPRAS
    exporting
      !DOC_COMPRAS type ME_EKPO .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CESTA_COMPRAS_ALFA02 IMPLEMENTATION.


  method GET_DOC_COMPRAS.

    doc_compras = me->doc_compras.

  endmethod.


  method SET_DOC_COMPRAS.

    me->doc_compras = doc_compras.

  endmethod.
ENDCLASS.
