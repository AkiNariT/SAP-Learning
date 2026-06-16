@EndUserText.label : 'Draft table for entity ZI_RAP_CONS_REQ'
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztrap_cons_req_d {

  key mandt          : mandt not null;
  key requestid      : sysuuid_x16 not null;
  requestdate        : abap.dats;
  requester          : abap.char(40);
  itemtext           : abap.char(80);
  quantity           : abap.dec(13,3);
  unitcode           : abap.char(3);
  costcenter         : abap.char(10);
  status             : abap.char(20);
  createdby          : abp_creation_user;
  createdat          : abp_creation_tstmpl;
  lastchangedby      : abp_lastchange_user;
  lastchangedat      : abp_lastchange_tstmpl;
  locallastchangedat : abp_locinst_lastchange_tstmpl;
  "%admin"           : include sych_bdl_draft_admin_inc;

}
