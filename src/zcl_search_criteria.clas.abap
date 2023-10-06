class ZCL_SEARCH_CRITERIA definition
  public
  create public .

public section.

  methods SEARCH .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SEARCH_CRITERIA IMPLEMENTATION.


  METHOD search.

    cl_dsh_dynpro_properties=>enable_type_ahead(
     EXPORTING
      fields           = VALUE #( ( CONV string('GV_BP_ID') ) )
      overwrite        = abap_true
      in_table_control = abap_false
      limit_length     = abap_false
   ).

  ENDMETHOD.
ENDCLASS.
