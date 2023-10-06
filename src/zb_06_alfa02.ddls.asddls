@AbapCatalog.sqlViewName: 'ZVB_06_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZB_06_ALFA02'


define view ZB_06_ALFA02 as select from demo_join1 
{
    a as COLUMNA1,
    b as COLUMNA2
}
union //all
select from demo_join2
{
    d as COLUMNA1,
    e as COLUMNA2
}
