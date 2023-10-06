@AbapCatalog.sqlViewName: 'ZV_CUSTOMER'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view Z_CDS_CUSTOMER
 as select from scustom
 join sbook
 on scustom.id = sbook.customid
 {
 @EndUserText.label: 'Customer ID'
 scustom.id,
 @EndUserText.label: 'Customer Name'
 scustom.name,
 @EndUserText.label: 'Customer Booking ID'
 sbook.bookid
 }
