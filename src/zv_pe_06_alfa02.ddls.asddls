@AbapCatalog.sqlViewName: 'ZV_PE_ALFA02'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PATH EXPRESSIONS'


define view ZV_PE_06_ALFA02 as select from spfli
association [1] to sflight as _flights
    on      spfli.mandt  =  _flights.mandt
        and spfli.carrid =  _flights.carrid
        and spfli.connid =  _flights.connid
    
association [1..1] to sairport as _airports
    on  SPFLI.mandt = _airports.mandt
    and spfli.airpfrom = _airports.id
{
    _flights,
    _airports,
    spfli.mandt,
    spfli.carrid,
    spfli.connid,
    spfli.airpfrom
}
