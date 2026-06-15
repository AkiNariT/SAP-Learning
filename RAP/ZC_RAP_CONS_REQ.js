@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Consumable Request Projection View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_RAP_CONS_REQ
  provider contract transactional_query
  as projection on ZI_RAP_CONS_REQ
{
      key RequestID,

      RequestDate,
      Requester,
      ItemText,

      Quantity,
      Unit,

      CostCenter,
      Status,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
