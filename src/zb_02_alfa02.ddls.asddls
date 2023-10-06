@AbapCatalog.sqlViewName: 'ZVB_02_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EJERCICIO 3_02'
define view ZB_02_ALFA02 
with parameters p_param:abap.char( 4 )
as select from mara
left outer join marc
    on mara.matnr = marc.matnr 
{
    key mara.matnr,
    marc.werks
}
where marc.werks = $parameters.p_param
