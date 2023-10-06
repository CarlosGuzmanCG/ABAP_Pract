@AbapCatalog.sqlViewName: 'ZV_07_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'expose airports'

@VDM.viewType: #BASIC

define view zb_07_exp_airport_alfa02 as select from spfli as flight
association [1] to ZB_06_AIRPORTS_ALFA02 as _airportfrom
    on flight.airpfrom = _airportfrom.airportid

{
    carrid ,
    connid ,
    countryfr ,
    cityfrom ,
    airpfrom ,
    _airportfrom.airportname, -- publicamos la informacion del cds
    _airportfrom -- expuesto la informacion
}
