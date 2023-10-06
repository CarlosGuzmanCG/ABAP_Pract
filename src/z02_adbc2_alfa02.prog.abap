*&---------------------------------------------------------------------*
*& Report Z02_ADBC2_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_adbc2_alfa02.

DATA: go_connection TYPE REF TO cl_sql_connection,
      go_statement  TYPE REF TO cl_sql_statement,
      go_result     TYPE REF TO cl_sql_result_set,
      gx_sql_excep  TYPE REF TO cx_sql_exception,
      gv_sql        TYPE string,
      gr_flight     TYPE REF TO data,
      gt_flight     TYPE STANDARD TABLE OF spfli.
TRY.
    IF NOT cl_abap_dbfeatures=>use_features( EXPORTING
   connection = 'HANADB'

   requested_features = VALUE #( (
   cl_abap_dbfeatures=>external_views )

   ( cl_abap_dbfeatures=>call_amdp_method ) ) ).

      WRITE 'El sistema de base de datos no soporta el procedimiento invocado'.
      RETURN.
    ENDIF.
    go_connection = cl_sql_connection=>get_connection( 'HANADB' ).
    CREATE OBJECT go_statement EXPORTING con_ref = go_connection.
    gv_sql = |SELECT * FROM "_SYS_BIC"."SPFLI" WHERE mandt = '{ sy-mandt }' AND carrid = 'SQ'|.
    go_result = go_statement->execute_query( gv_sql ).
    GET REFERENCE OF gt_flight INTO gr_flight.
    go_result->set_param_table( gr_flight ).
    go_result->next_package( ).
    go_result->close( ).

  CATCH cx_sql_exception INTO gx_sql_excep.
    WRITE gx_sql_excep->get_text( ).
ENDTRY.
IF NOT gt_flight IS INITIAL.
  cl_demo_output=>display( gt_flight ).
ELSE.
  WRITE 'No hay datos'.
ENDIF.
