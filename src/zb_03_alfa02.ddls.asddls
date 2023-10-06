@AbapCatalog.sqlViewName: 'ZVB_03_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Categoría de datos Texto'

@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'Unit'

define view ZB_03_ALFA02 as select from t006a as T0 {
    T0.spras as Language,
    T0.msehi as Unit,
    T0.mseh3 as CommercialFormat,
    T0.mseh6 as MaterialType,
    T0.mseht as TechnicalFormat,
    T0.msehl as UnitText
}
