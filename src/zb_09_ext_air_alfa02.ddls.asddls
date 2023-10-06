@AbapCatalog.sqlViewAppendName: 'ZEV_09_ALFA02'
@EndUserText.label: 'CDS - Extend'
extend view ZB_01_AIRL_ALFA02 with ZB_09_EXT_AIR_ALFA02 
{
    scarr.carrname as airlinename
}
