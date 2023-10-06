@AbapCatalog.sqlViewName: 'ZVB_09_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Vista intermedia 02'

@Analytics.dataCategory: #CUBE
@VDM:{
    viewType: #COMPOSITE
}


define view ZB_09_ALFA02 as select from marc
association [1] to ZB_08_ALFA02 as _ZB_08
    on marc.matnr = _ZB_08.matnr 
{
    key _ZB_08.matnr as material,
    key marc.werks as plant,
    @Semantics.businessDate.at: true
    _ZB_08.ersda as createdon,
    @Semantics.name.fullName: true
    _ZB_08.ernam as personnamecreated,
    @Semantics.businessDate.at: true
    _ZB_08.laeda as LastChangeDate,
    @Semantics.quantity.unitOfMeasure:'WeightUnit'
    _ZB_08.brgew as GrossWeight,
    @Semantics.quantity.unitOfMeasure:'WeightUnit'
    _ZB_08.ntgew as NetWeight,
    @Semantics.unitOfMeasure: true
    _ZB_08.gewei as WeightUnit,
    @Semantics.quantity.unitOfMeasure:'VolumeUnit'
    _ZB_08.volum as Volume,
    @Semantics.unitOfMeasure: true
    _ZB_08.voleh as VolumeUnit
} 
