@AbapCatalog.sqlViewName: 'ZV_03_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COUNTRY TEXT'

@VDM.viewType: #BASIC
@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'countrykey' --clave

define view ZB_03_COUNTRY_T_ALFA02 
//with parameters p_countrykey : abap.char( 3 ) 
as select from t005t 
{
    
    key land1 as countrykey,
    @Semantics.language: true -- la siguiente columna es de tipo idioma
    key spras as language,
    @Semantics.text: true
    @EndUserText.label: 'Country Name'
    landx50   as countryname
}
//where land1 = $parameters.p_countrykey
