managed implementation in class zbp_i_rap_cons_req unique;
strict ( 2 );
with draft;

define behavior for ZI_RAP_CONS_REQ alias ConsReq
persistent table ztrap_cons_req
draft table ztrap_cons_req_d
lock master total etag LastChangedAt
authorization master ( global )
etag master LocalLastChangedAt
{
  create;
  update;
  delete;

  draft action Edit;
  draft action Activate optimized;
  draft action Discard;
  draft action Resume;
  draft determine action Prepare;

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
