@EndUserText.label: 'TABLE FUNCTION'
define table function ZCDS_TF_ALFA02
  with parameters
    @Environment.systemField: #CLIENT
    clnt        : abap.clnt,
    airlinecode : s_carr_id
returns
{
  client     : abap.clnt;
  airliname  : s_carrname;
  flightconn : s_conn_id;
  cityfrom   : s_from_cit;
  cityto     : s_to_city;
}
implemented by method
  ZCL_TABLE_FUN01_alfa02=>get_flights;
