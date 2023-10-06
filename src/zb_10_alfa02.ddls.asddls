@AbapCatalog.sqlViewName: 'ZVB_10_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZB_10_ALFA02'

@VDM.viewType: #CONSUMPTION
@Analytics.query: true

@OData.publish: true 

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZB_10_ALFA02 as select from ZB_09_ALFA02 
{
    @AnalyticsDetails.query.axis: #ROWS
    material,
    @AnalyticsDetails.query.axis: #ROWS
    plant,
    @AnalyticsDetails.query.axis: #ROWS
    createdon,
    @AnalyticsDetails.query.axis: #ROWS
    personnamecreated,
    @AnalyticsDetails.query.axis: #ROWS
    LastChangeDate,
    @AnalyticsDetails.query.axis: #COLUMNS
    WeightUnit,
    @AnalyticsDetails.query.axis: #COLUMNS
    VolumeUnit
}
