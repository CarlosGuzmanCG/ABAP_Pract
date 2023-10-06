@AbapCatalog.sqlViewName: 'ZV_11_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'vista intermedia'
@Analytics: {
    dataCategory:#CUBE
}
@VDM:{
    viewType: #COMPOSITE
}
define view zi_11_cube2_alfa02 
    as select from sflight
    association [0..1] to zb_10_spfli_alfa02 as _FLIGHTconnection
    on $projection.Carrid = _FLIGHTconnection.Carrid and 
        $projection.FLIGHTconnection = _FLIGHTconnection.Connid 
        
{
    key sflight.carrid as Carrid,
    key sflight.connid as FLIGHTconnection,
    key sflight.fldate as Fldate,
    @Semantics.amount: {
        currencyCode: 'Currency'
    }
    @DefaultAggregation: #MIN
    sflight.price as Price,
    @Semantics.currencyCode: true
    sflight.currency as Currency,
    @DefaultAggregation: #SUM
    sflight.planetype as Planetype,
    @DefaultAggregation: #SUM
    sflight.seatsmax as Seatsmax,
    @DefaultAggregation: #SUM
    sflight.seatsocc as Seatsocc,
    @Semantics.amount: {
        currencyCode: 'Currency'
    }
    @DefaultAggregation: #SUM
    sflight.paymentsum as Paymentsum,
    _FLIGHTconnection
}
