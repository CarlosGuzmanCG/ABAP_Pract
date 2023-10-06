*&---------------------------------------------------------------------*
*& Report Z03_ADBBC_HANA_VIEW_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z03_adbbc_hana_view_alfa02.

TYPES: BEGIN OF gty_flights,
         carrid    TYPE s_carr_id,
         connid    TYPE s_conn_id,
         fldate    TYPE s_date,
         countryfr TYPE land1,
         cityfrom  TYPE s_from_cit,
         price     TYPE s_price,
         currency  TYPE s_currcode,
         countryto TYPE land1,
         cityto    TYPE s_to_city,
         deptime   TYPE s_dep_time,
         arrtime   TYPE s_arr_time,
       END OF gty_flights.
DATA: go_statement      TYPE REF TO cl_sql_statement,
      go_result         TYPE REF TO cl_sql_result_set,
      gx_sql_excep      TYPE REF TO cx_sql_exception,
      gx_abap_inv_param TYPE REF TO
                          cx_abap_invalid_param_value,
      gv_sql            TYPE string,
      gr_flights        TYPE REF TO data,
      gt_flights        TYPE TABLE OF gty_flights.
PARAMETERS: p_carrid TYPE s_carr_id.
TRY.
    IF NOT cl_abap_dbfeatures=>use_features( EXPORTING
   connection = 'HANADB'

   requested_features = VALUE #( (
   cl_abap_dbfeatures=>external_views ) ) ).
      WRITE 'El sistema de base de datos no soporta el procedimiento invocado'.
      RETURN.
    ENDIF.
  CATCH cx_abap_invalid_param_value INTO gx_abap_inv_param.
    WRITE gx_abap_inv_param->get_text( ).
ENDTRY.

TRY.
    go_statement = NEW #( con_ref =
   cl_sql_connection=>get_connection( 'HANADB' ) ).
    gv_sql = |SELECT * FROM "_SYS_BIC"."ZABAP_SEC_HANA_TRAINING.ZGVALER/ZGVALER_FLIGHTS " WHERE carrid = '{ p_carrid }'|.
    GET REFERENCE OF gt_flights INTO gr_flights.
    go_result = go_statement->execute_query( gv_sql ).
    go_result->set_param_table( gr_flights ).
    go_result->next_package( ).
    go_result->close( ).
  CATCH cx_sql_exception INTO gx_sql_excep.
    WRITE gx_sql_excep->get_text( ).
ENDTRY.
IF NOT gt_flights IS INITIAL.
  cl_demo_output=>display( gt_flights ).
ELSE.
  WRITE 'No hay datos'.
ENDIF.
