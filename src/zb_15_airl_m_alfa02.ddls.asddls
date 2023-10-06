@AbapCatalog.sqlViewName: 'ZV_15_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'AIRLINES METADATA'

-- EXTENDER CDS
@Metadata.allowExtensions: true -- SE PERMITE ANADIR NUEVAS EXTENCIONES

define view ZB_15_AIRL_M_ALFA02 as select from scarr 

{
    @UI.dataPoint.title: 'CDS - AIRLINE CODE' --ANOTACION
    key carrid as AIRLINE,
    currcode as AIRLINELOCALCURRENCY
}
