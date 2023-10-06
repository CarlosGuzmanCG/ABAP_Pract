@EndUserText.label: 'TABLE FUNCTION WITH SELECT OPTIONS'
define table function Z_TF_SO_ALFA02

with parameters 
@Environment.systemField: #CLIENT

clnt : abap.clnt,

sel_opt : abap.char( 1000 )

returns {
  mandt : abap.clnt;
  carrid : s_carr_id ;
  connid : s_conn_id;
  fldate : s_date;
  price : s_price;
}

implemented by method zcs_so_tf_alfa02=>get_flights;
