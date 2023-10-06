@EndUserText.label: 'Ejercicio - Definir Table Function'
define table function ZB_13_ALFA02
with parameters 
    @Environment.systemField: #CLIENT
    clnt : abap.clnt,
    Plant : werks_d,
    StorageLocation : lgort_d
returns {
    Client : abap.clnt;
    Material : matnr;
    MaintenanceStatus : pstat_d;
    FiscalYear : lfgja;
}
implemented by method ZCL_01_ALFA02=>get_materials;
