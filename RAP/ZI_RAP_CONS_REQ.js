@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Consumable Request Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_RAP_CONS_REQ as select from ZTRAP_CONS_REQ
{
    
  key request_id as RequestID,

      request_date as RequestDate,
      requester    as Requester,
      item_text    as ItemText,

      @Semantics.quantity.unitOfMeasure: 'UnitCode'
      quantity     as Quantity,

      @Semantics.unitOfMeasure: true
      unit_code    as UnitCode,

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
