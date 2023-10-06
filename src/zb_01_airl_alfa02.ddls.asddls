@AbapCatalog.sqlViewName: 'ZV_01_ALFA02' -- NOMBRE
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED  -- TIPO DE ACCESO
@EndUserText.label: 'Airline' --PLANTILLA
@VDM.viewType: #BASIC


define view ZB_01_AIRL_ALFA02 
with parameters p_airlinecode : s_carr_id
as select from scarr {
   key carrid   as AIRLINE, -- clave de la vista
   @Semantics.currencyCode: true --moneda
   currcode as AIRLINELOCALCURRENCY,
   @Semantics.url: {
       mimeType: 'AirlineUrl'
   }
   url      as AirlineUrl
}

where carrid = $parameters.p_airlinecode
