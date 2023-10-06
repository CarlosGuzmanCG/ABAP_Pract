@AbapCatalog.sqlViewName: 'ZVB_04_01_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZB_04_01_ALFA02'

@VDM.viewType: #BASIC

define view ZB_04_01_ALFA02 as select from sflight
association [1] to saplane as _PLANE
    on sflight.planetype = _PLANE.planetype 
{
        sflight.carrid,
        sflight.connid,
        sflight.planetype,
        _PLANE
}
