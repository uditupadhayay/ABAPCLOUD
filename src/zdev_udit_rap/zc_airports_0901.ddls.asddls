@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_AIRPORTS_0901
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_AIRPORTS_0901
{
  key Airport,
  Country,
  City,
  LastChangedAt,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt
  
}
