@EndUserText.label: 'RAP Consumable Request Interface View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_RAP_CONS_REQ
  as select from ztrap_cons_req
{
  key request_id as RequestID,

      request_date as RequestDate,
      requester    as Requester,
      item_text    as ItemText,

      quantity     as Quantity,
      unit         as Unit,

      cost_center  as CostCenter,
      status       as Status,

      @Semantics.user.createdBy: true
      created_by as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
