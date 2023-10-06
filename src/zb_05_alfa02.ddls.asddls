@AbapCatalog.sqlViewName: 'ZVB_05_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'v2'

@VDM.viewType: #BASIC

define view ZB_05_ALFA02
with parameters p_param:abap.char( 4 ),
                p_StorageLoc:abap.char( 4 )
as select from ZB_02_ALFA02( p_param: $parameters.p_param ) as mat
association [0..1] to ZB_04_ALFA02 as _ZVB04
    on mat.matnr= _ZVB04.Material
    and mat.werks = _ZVB04.Plant
{
    mat.matnr,
    mat.werks,
    _ZVB04(p_StorageLoc:$parameters.p_StorageLoc).StorageLocation,
    _ZVB04
    
}
