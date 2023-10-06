@AbapCatalog.sqlViewName: 'ZVB_12_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ACCESS CONTROL IMPEDIR ACCESO'
@VDM.viewType: #BASIC
define view ZB_12_ALFA02 as select from marc {
    key matnr as Material ,
    key werks as Plant ,
    pstat as MaintenanceStatus,
    ekgrp as PurchasingGroup
}
