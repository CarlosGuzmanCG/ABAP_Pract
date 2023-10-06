@AbapCatalog.sqlViewName: 'ZVB_11_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@VDM.viewType: #BASIC
@EndUserText.label: 'Ejercicio - Access Control - Instance Role'

@Metadata.allowExtensions: true 

define view ZB_11_ALFA02 as select from marc {
    key matnr  as MATERIAL,
    key werks as PLANT,
        pstat  as MAINTENANCESTATUS,
        ekgrp as PURCHASINGGROUP
}
