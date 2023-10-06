@AbapCatalog.sqlViewName: 'ZV_PE01_ALFA02'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PATH EXPRESSION'

define view ZV_PE_07_ALFA02 as select from scarr
association [1] to ZV_PE_06_ALFA02 as _flights
    on scarr.mandt = _flights.mandt 
    and scarr.carrid = _flights.carrid
{
    _flights,
    scarr.mandt,
    scarr.carrid,
    scarr.carrname
}
