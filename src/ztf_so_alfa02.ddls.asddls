@EndUserText.label: 'Select Options con Table Function'
define table function ZTF_SO_ALFA02
with parameters 
@Environment.systemField: #CLIENT
    CLNT : abap.clnt,
    SEL_OPT : abap.char(1000),
    LANG : spras
returns {
      MANDT : abap.clnt;
      MATERIAL : matnr;
      PLANT : werks_d;
      DESCRIPTION : maktx;
  
}
implemented by method ZCL_TF_SO_ALFA02=>GET;
