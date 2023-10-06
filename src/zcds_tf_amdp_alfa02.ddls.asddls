@EndUserText.label: 'Table Function con AMDP'
define table function ZCDS_TF_AMDP_ALFA02
with parameters 
    @Environment.systemField: #CLIENT
    clnt : abap.clnt
returns {
    MANDT : abap.clnt;
    PLANETYPE : s_planetye;
    SEATSMAX : s_seatsmax;
    PRODUCER : s_prod;
}
implemented by method ZCL_TF_AMDP_ALFA02=>GET_PLANES;
