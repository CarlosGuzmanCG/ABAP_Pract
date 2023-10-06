@AbapCatalog.sqlViewName: 'ZV_12_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VISTA DE CONSUMO'
@VDM.viewType: #CONSUMPTION
@Analytics.query: true

@OData.publish: true  -- Servicio ODATA

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZC_12_CONSUM_ALFA02 as select from zi_11_cube2_alfa02 {
    @AnalyticsDetails.query.axis: #ROWS
    Carrid,
    @AnalyticsDetails.query.axis: #ROWS
    FLIGHTconnection,
    @AnalyticsDetails.query.axis: #ROWS
    Fldate,
    @AnalyticsDetails.query.axis: #COLUMNS
    Price,
    @AnalyticsDetails.query.axis: #COLUMNS
    Currency,
    @AnalyticsDetails.query.axis: #COLUMNS
    Seatsmax,
    @AnalyticsDetails.query.axis: #COLUMNS
    Seatsocc,
    @AnalyticsDetails.query.axis: #COLUMNS
    @DefaultAggregation: #FORMULA
    @EndUserText.label: 'Available seats'
    Seatsmax - Seatsocc as NUMBEROFAVAILABLESEARS,
    @AnalyticsDetails.query.axis: #COLUMNS
    Paymentsum
}
