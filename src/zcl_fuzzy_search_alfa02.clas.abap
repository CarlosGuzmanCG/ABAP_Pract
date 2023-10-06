CLASS zcl_fuzzy_search_alfa02 DEFINITION
  PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.

    interfaces if_amdp_marker_hdb.

    types ty_threshold type p length 3 DECIMALS 1.

    class-METHODS get_customers IMPORTING value(iv_name)      type s_custname
                                          value(iv_threshold) type ty_threshold
                                EXPORTING value(et_customers) type ty_customers.

ENDCLASS.

CLASS zcl_fuzzy_search_alfa02 IMPLEMENTATION.

  METHOD get_customers BY DATABASE procedure FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING scustom.

    et_customers = select * from scustom
            where CONTAINS (name, :iv_name, fuzzy( :iv_threshold ) );

  ENDMETHOD.

ENDCLASS.
