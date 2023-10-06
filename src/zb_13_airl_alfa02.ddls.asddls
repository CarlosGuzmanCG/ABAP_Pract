@AbapCatalog.sqlViewName: 'ZV_13_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK

@VDM: {

  viewType: #BASIC
}

define view ZB_13_AIRL_ALFA02  
as select from scarr {

key carrid as Airline,
@Semantics.currencyCode: true

currcode as AirlineLocalCurrency,
@Semantics.url: {
  mimeType: 'AirlineUrl'
  }

   url as AirlineUrl
}
