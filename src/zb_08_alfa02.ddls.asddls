@AbapCatalog.sqlViewName: 'ZVB_08_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Vista intermedia'

@VDM.viewType: #BASIC

define view ZB_08_ALFA02 as select from mara {
    key matnr,
    ersda,
    ernam,
    laeda,
    brgew,
    ntgew,
    gewei,
    volum,
    voleh
}
