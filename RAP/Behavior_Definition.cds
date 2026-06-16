managed implementation in class zbp_i_rap_cons_req unique;
strict ( 2 );

define behavior for ZI_RAP_CONS_REQ //alias <alias_name>
persistent table ztrap_cons_req
lock master
authorization master ( instance )
//etag master <field_name>
{
  create ( authorization : global );
  update;
  delete;
  field ( readonly, numbering : managed ) RequestID;

  field ( readonly )
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt;

  field ( mandatory )
    RequestDate,
    Requester,
    ItemText,
    Quantity,
    UnitCode,
    CostCenter,
    Status;

  mapping for ztrap_cons_req
  {
    RequestID            = request_id;
    RequestDate          = request_date;
    Requester            = requester;
    ItemText             = item_text;
    Quantity             = quantity;
    UnitCode             = unit;
    CostCenter           = cost_center;
    Status               = status;
    CreatedBy            = created_by;
    CreatedAt            = created_at;
    LastChangedBy        = last_changed_by;
    LastChangedAt        = last_changed_at;
    LocalLastChangedAt   = local_last_changed_at;
  }
}
