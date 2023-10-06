@AbapCatalog.sqlViewName: 'ZVB_04_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ejercicio 3_6'
define view ZB_04_ALFA02 
with parameters p_StorageLoc:abap.char( 4 )
as select from mard as mard
{
    key matnr as Material,
    key werks as Plant,
    lgort as StorageLocation,
    pstat as MaintStatus,
    lfgja as FiscalYear,
    lfmon as Period
}
where lgort = $parameters.p_StorageLoc
