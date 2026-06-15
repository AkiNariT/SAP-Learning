@EndUserText.label : 'RAP Consumable Request Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztrap_cons_req {

  key client            : abap.clnt not null;
  key request_id        : sysuuid_x16 not null;

  request_date          : abap.dats;
  requester             : abap.char(40);
  item_text             : abap.char(80);


  quantity              : abap.dec(13,3);

  unit                  : abap.char(3);

  cost_center           : abap.char(10);
  status                : abap.char(20);

  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  last_changed_by       : abp_lastchange_user;
  last_changed_at       : abp_lastchange_tstmpl;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;

}
