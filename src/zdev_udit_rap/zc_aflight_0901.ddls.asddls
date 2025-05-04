@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_AFLIGHT_0901
  provider contract transactional_query
  as projection on ZR_AFLIGHT_0901
{
  key Uuid,
  Carrid,
  Connid,
  AirportFrom,
  CountryFrom,
  CityFrom,
  AirportTo,
  CountryTo,
  CityTo,
  price,
  Currency,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
