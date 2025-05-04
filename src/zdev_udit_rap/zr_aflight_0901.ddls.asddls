@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_AFLIGHT_0901
  as select from zaflight_0901 as Flight
{
  key uuid                  as Uuid,
      carrid                as Carrid,
      connid                as Connid,
      airport_from          as AirportFrom,
      country_from          as CountryFrom,
      city_from             as CityFrom,
      airport_to            as AirportTo,
      country_to            as CountryTo,
      city_to               as CityTo,
      price,
      currency              as Currency,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt

}
