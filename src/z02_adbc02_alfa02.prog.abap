*&---------------------------------------------------------------------*
*& Report Z02_ADBC02_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z02_ADBC02_ALFA02.

DATA: go_connection TYPE REF TO cl_sql_connection, "referencia de la clase estandar
      go_statement  TYPE REF TO cl_sql_statement,   "para crear sentencia sql
      go_result     TYPE REF TO cl_sql_result_set, "resultado que devuelve el select

      gx_root       TYPE REF TO cx_sql_exception,

      gv_sql        TYPE string,
      gv_flight     TYPE REF TO data,
      gt_flight     TYPE STANDARD TABLE OF sflight.

TRY.

    go_connection = cl_sql_connection=>get_connection( 'HANADB' ). "CONEXION

    CREATE OBJECT go_statement EXPORTING con_ref = go_connection.

    go_statement = NEW  #( )."cl_sql_statement(  ).
"{ sy-mandt }
    gv_sql = |SELECT * FROM "SAPS4H"."SFLIGHT" WHERE MANDT = '{ sy-mandt }' and carrid = 'LH'|.

    go_result = go_statement->execute_query( gv_sql ).

    GET REFERENCE OF gt_flight INTO gv_flight. "

    go_result->set_param_table( gv_flight ). " TABLA INTERNA

    go_result->next_package(  ).

    go_result->close(  ).

  CATCH cx_sql_exception INTO gx_root.
    WRITE gx_root->get_text(  ).
ENDTRY.

IF NOT gt_flight IS INITIAL.
  cl_demo_output=>display( gt_flight ).
ELSE.
  WRITE 'no hay datos'.
ENDIF.
