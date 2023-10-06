@EndUserText.label: 'FLIGHTS - TABLE FUNCTION'
define table function ZTF_FLIGHTS_ALFA02
with parameters 
    @Environment.systemField: #CLIENT
    clnt : abap.clnt,
    airlinecode:s_carr_id
returns { -- elementos
  client : abap.clnt;
  airlinename : s_carrname;
  flightconn : s_conn_id;
  cityfrom : s_from_cit;
  cityto : s_to_city;
}
implemented by method zcl_table_fun_alfa02=>get_flights;
