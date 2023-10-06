*&---------------------------------------------------------------------*
*& Report Z03_ADBBC_HANA_PALM_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z03_ADBBC_HANA_PALM_ALFA02.

TYPES: BEGIN OF gty_overview,
 param TYPE string,
 value TYPE string,
 END OF gty_overview.
TYPES: BEGIN OF gty_flights,
 carrid TYPE s_carr_id,
 connid TYPE s_conn_id,
 fldate TYPE s_date,
 price TYPE s_price,
 cityfrom TYPE s_from_cit,
 cityto TYPE s_to_city,
 END OF gty_flights.
DATA: go_statement TYPE REF TO cl_sql_statement,
 go_result TYPE REF TO cl_sql_result_set,
 gx_sql_excep TYPE REF TO cx_sql_exception,
 gx_abap_inv_param TYPE REF TO
cx_abap_invalid_param_value,
 gv_sql TYPE string,
 gr_flights TYPE REF TO data,
 gt_overview TYPE STANDARD TABLE OF
gty_overview,
 gt_flights TYPE STANDARD TABLE OF gty_flights.
PARAMETERS: p_cntr_f TYPE land1,
 p_cntr_t TYPE land1.
TRY.
 IF NOT cl_abap_dbfeatures=>use_features( EXPORTING
connection = 'HANADB'

requested_features = VALUE #( (
cl_abap_dbfeatures=>call_database_procedure ) ) ).
 WRITE 'El sistema de base de datos no soporta el procedimiento invocado'.
 RETURN.
 ENDIF.
 CATCH cx_abap_invalid_param_value INTO gx_abap_inv_param.
 WRITE gx_abap_inv_param->get_text( ).
ENDTRY.


TRY.
 go_statement = NEW #( con_ref =
cl_sql_connection=>get_connection( 'HANADB' ) ).
 gv_sql = |call "_SYS_BIC"."ZABAP_SEC_HANA_TRAINING.ZGVALER::sp_gvaler_flig hts"('{ p_cntr_f }', '{ p_cntr_t }', null) with overview|.
 go_result = go_statement->execute_query( gv_sql ).
 GET REFERENCE OF gt_overview INTO gr_flights.
 go_result->set_param_table( gr_flights ).
 go_result->next_package( ).
 READ TABLE gt_overview ASSIGNING FIELD-SYMBOL(<ls_overview>) WITH KEY param = 'ET_FLIGHTS'.
 IF sy-subrc EQ 0.
 gv_sql = |SELECT * FROM { <ls_overview>-value } |.
 go_result = go_statement->execute_query( gv_sql ).
 GET REFERENCE OF gt_flights INTO gr_flights.
 go_result->set_param_table( gr_flights ).
 go_result->next_package( ).
 ENDIF.
 go_result->close( ).
 CATCH cx_sql_exception INTO gx_sql_excep.
 WRITE gx_sql_excep->get_text( ).
ENDTRY.
IF NOT gt_flights IS INITIAL.
 cl_demo_output=>display( gt_flights ).
ELSE.
 WRITE 'No hay datos'.
ENDIF.
