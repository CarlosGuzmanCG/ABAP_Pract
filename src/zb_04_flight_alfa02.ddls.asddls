@AbapCatalog.sqlViewName: 'ZV_04_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS ASSOCIATION'

@VDM.viewType: #BASIC

define view ZB_04_FLIGHT_ALFA02 
with parameters p_airline:abap.char( 2 ),
                p_lenguage:abap.char( 1 )
                
as select from spfli as flight
                -- vista                     nombre
association [1] to ZB_03_COUNTRY_T_ALFA02 as _countrynamefrom
     --alias                    
    on $projection.countryfromkey = _countrynamefrom.countrykey and
       _countrynamefrom.language = $parameters.p_lenguage
       
association [1] to ZB_03_COUNTRY_T_ALFA02 as _countrynameto
     --alias                    
    on flight.countryto = _countrynameto.countrykey and
       _countrynameto.language = $parameters.p_lenguage

{ ---vista
    key flight.carrid                as airline,
    key flight.connid                as flightconnection,
        flight.cityfrom              as cityfrom,
        flight.countryfr             as countryfromkey,
        _countrynamefrom.countryname as countrynamefrom,
        flight.cityfrom              as cityto,
        flight.countryto             as countrytp,
        _countrynameto.countryname   as countrynameto
}
where flight.carrid = $parameters.p_airline
