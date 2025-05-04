@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_ACARRIR_0901
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_ACARRIR_0901
{
  key Carrid,
  CarrName,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
