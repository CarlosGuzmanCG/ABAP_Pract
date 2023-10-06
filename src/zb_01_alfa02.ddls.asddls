@AbapCatalog.sqlViewName: 'ZV_01M_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VISTA BASICA'
@VDM.viewType: #BASIC

@Metadata.allowExtensions: true 

define view ZB_01_ALFA02 
with parameters p_createdAt_begin : abap.dats, p_createdAt_end : abap.dats
as select from mara {
    key matnr as Material,
    @Semantics.businessDate.at: true
    ersda as CreatedOn,
    @Semantics.name.fullName: true
    ernam as PersonName,
    mtart as MaterialType,
    laeng as Length,
    breit as Width,
    hoehe as Height 
}
where ersda >= $parameters.p_createdAt_begin and
      ersda <= $parameters.p_createdAt_end
