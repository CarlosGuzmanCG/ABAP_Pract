@AbapCatalog.sqlViewName: 'ZV_14_ALFA02' -- NOMBRE
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED  -- TIPO DE ACCESO
@EndUserText.label: 'Airline' --PLANTILLA
@VDM.viewType: #BASIC


define view ZB_14_AIRL_ALFA02 
as select from scarr {
   key carrid   as AIRLINE, -- clave de la vista
   @Semantics.currencyCode: true --moneda
   currcode as AIRLINELOCALCURRENCY,
   @Semantics.url: {
       mimeType: 'AirlineUrl'
   }
   url      as AirlineUrl
}
