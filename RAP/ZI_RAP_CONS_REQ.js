managed implementation in class zbp_i_rap_cons_req unique;
strict;

define behavior for ZI_RAP_CONS_REQ alias ConsReq
persistent table ztrap_cons_req
lock master
authorization master ( instance )
etag master LocalLastChangedAt
{
  create;
  update;
  delete;

  field ( readonly, numbering : managed ) RequestID;

  mapping for ztrap_cons_req
  {
    RequestID            = request_id;
    RequestDate          = request_date;
    Requester            = requester;
    ItemText             = item_text;
    Quantity             = quantity;
    Unit                 = unit;
    CostCenter           = cost_center;
    Status               = status;
    CreatedBy            = created_by;
    CreatedAt            = created_at;
    LastChangedBy        = last_changed_by;
    LastChangedAt        = last_changed_at;
    LocalLastChangedAt   = local_last_changed_at;
  }
}
