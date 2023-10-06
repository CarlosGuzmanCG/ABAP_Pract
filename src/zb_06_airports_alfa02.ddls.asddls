@AbapCatalog.sqlViewName: 'ZV_06_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'AIRPORTS'

@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'airportid'

define view ZB_06_AIRPORTS_ALFA02 as select from sairport {
    key id as airportid,
    name as airportname,
    time_zone as airporttimezone
}
