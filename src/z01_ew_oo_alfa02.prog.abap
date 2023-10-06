*&---------------------------------------------------------------------*
*& Report Z01_EW_OO_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z01_EW_OO_ALFA02.
*REPORT Z02_NEW_TI_ALFA02.

CLASS lcl_factura DEFINITION.

  public section.

  types: begin of ty_factura,  " tipo local
    importe_base type i,
    iva type i,
  end of ty_factura.

  types tt_factura type table of ty_factura.

  METHODS: add_item IMPORTING it_item type tt_factura,
           add_Structure IMPORTING is_item type ty_factura,
           constructor IMPORTING iv_value type char2.

ENDCLASS.

class lcl_factura IMPLEMENTATION.

  method add_item.



  endmethod.

  METHOD constructor.



  ENDMETHOD.

  METHOD add_Structure.

  ENDMETHOD.

endclass.

START-OF-SELECTION.

data go_factura_old type ref to lcl_factura.

create OBJECT go_factura_old
  EXPORTING
    iv_value = 'AA'
  .

" formas de crear un objeto

data go_factura_new_1 type ref to lcl_factura.

go_factura_new_1 = new #( iv_value = 'BB' ).

data(go_factura_new_2) = new lcl_factura( iv_value = 'CC' ).

go_factura_new_1->add_item( it_item = value #(
            ( importe_base = '10' iva = '2' ) ) ).


cl_abap_codepage=>convert_to( source = conv #( sy-uname ) ).

DATA gt_facturas type lcl_factura=>tt_factura.


gt_facturas = value #( ( importe_base = '10' iva = '1' )
                       ( importe_base = '20' iva = '2' ) ).
