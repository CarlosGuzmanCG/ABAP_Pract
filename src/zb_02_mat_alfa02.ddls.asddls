@AbapCatalog.sqlViewName: 'ZV_02_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - Inner Join - Material'
define view ZB_02_MAT_ALFA02
with parameters p_storage : abap.char( 4 )  -- search with parameters
 as select from mara as material  -- table y alias
 inner join marc as plant         -- table y alias
    
    on material.matnr = plant.matnr  
    
 inner join  mard as storagelocation 
    on plant.matnr  = storagelocation.matnr and
        plant.werks = storagelocation.werks
        
  -- column [name_column as alias ]
  {
    key material.matnr    as material,
    plant.werks           as plant,
    storagelocation.lgort as storage
   } 
   --use of parameters [alias.column_name = $parameters.name_parameters ]
   where storagelocation.lgort = $parameters.p_storage
