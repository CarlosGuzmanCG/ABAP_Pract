*&---------------------------------------------------------------------*
*& Report Z02_ADBC_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_adbc_alfa02.

TYPES: BEGIN OF gty_overview, "tipo local
        param type string,
        value type string,
END OF gty_overview.


types: begin of gty_acc_docs,
        bukrs type bukrs,
        gjahr type gjahr,
        dmbtr type dmbtr,
        wrbtr type wrbtr,
     end of gty_acc_docs.

DATA: go_statement      TYPE REF TO cl_sql_statement,
      go_result         TYPE REF TO cl_sql_result_set,

      gt_overview type STANDARD TABLE OF gty_overview,
      gt_acc_docs type STANDARD TABLE OF gty_acc_docs,

      gx_root           TYPE REF TO cx_sql_exception,
      gx_abap_inv_param TYPE REF TO cx_abap_invalid_param_value,

      gv_sql            TYPE string,
      gv_flight         TYPE REF TO data.

TRY.
    IF NOT cl_abap_dbfeatures=>use_features( EXPORTING connection = 'HANADB'
                                           requested_features = VALUE #( ( cl_abap_dbfeatures=>external_views ) ) ). "gt_req_feature

      WRITE 'El sistema de base de datos no soporta el procedimiento invocado'.
      RETURN.
    ENDIF.

  CATCH cx_abap_invalid_param_value INTO gx_abap_inv_param.
    WRITE gx_abap_inv_param->get_text( ).
ENDTRY.

TRY.

    go_statement = NEW #( con_ref = cl_sql_connection=>get_connection( 'HANADB' ) ).

    gv_sql = |call "_SYS_BIC"."ZABAP_4_HANA::SP_ACC_DOCS"( 400, 1710, 2017, NULL ) WITH OVERVIEW|. "query

    GET REFERENCE OF gt_overview INTO gv_flight.

    go_result = go_statement->execute_query( gv_sql ).
    go_result->set_param_table( gv_flight ). " TABLA INTERNA
    go_result->next_package(  ).

    read table gt_overview ASSIGNING FIELD-SYMBOL(<ls_overview>) with key param = 'OUTPUT_TABLE_DOCS'. "

    IF  sy-subrc eq 0.
        gv_sql = |SELECT * FROM { <ls_overview>-value }|.
        go_result = go_statement->execute_query( gv_sql ).

        GET REFERENCE OF gt_acc_docs INTO gv_flight.
        go_result->set_param_table( gv_flight ). " TABLA INTERNA
        go_result->next_package(  ).

    endif.

    go_result->close(  ).

  CATCH cx_sql_exception INTO gx_root.
    WRITE gx_root->get_text(  ).
ENDTRY.

IF NOT gt_acc_docs IS INITIAL.
  cl_demo_output=>display( gt_acc_docs ).
ELSE.
  WRITE 'no hay datos'.
ENDIF.
