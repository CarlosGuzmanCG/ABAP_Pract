@AbapCatalog.sqlViewName: 'ZV_05_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ASSOCIATION WITH PARAM'

@VDM.viewType: #BASIC

define view ZB_05_AIRL_P_ALFA02 
with parameters p_airlinecode_a:s_carr_id,
                p_localcurrency:s_currcode
as select from sflight as flight
association [1] to ZB_01_AIRL_ALFA02 as _airline
    on flight.carrid = _airline.AIRLINE
    
{
    key flight.carrid as Carrid,
    key flight.connid as Connid,
    key flight.fldate as Fldate,
        flight.price as Price,
             --parametro del cds : parametro
    _airline(p_airlinecode:$parameters.p_airlinecode_a )
            -- filtro del cds ZB_01_AIRL_ALFA02
            [AIRLINELOCALCURRENCY = $parameters.p_localcurrency ].AIRLINELOCALCURRENCY,
    _airline(p_airlinecode:$parameters.p_airlinecode_a ).AirlineUrl
}
where carrid = $parameters.p_airlinecode_a
