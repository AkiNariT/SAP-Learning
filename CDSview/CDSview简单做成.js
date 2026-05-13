@AbapCatalog.sqlViewName: 'ZCDS_STUDY1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'test1'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_STUDY_TESTC as select from sflight
{
  key sflight.carrid as airline_id,
  key sflight.connid as flight_id,
  key sflight.fldate as flight_date,
  sflight.price as price,
  sflight.seatsmax as max_seat
}
