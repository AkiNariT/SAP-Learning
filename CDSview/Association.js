@AbapCatalog.sqlViewName: 'ZVSDHDR02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Header with Customer Association'
define view ZI_SD_SO_HEADER_A
  as select from vbak
    association [0..1] to kna1 as _SoldToParty
      on $projection.SoldToParty = _SoldToParty.kunnr
{
  key vbak.vbeln as SalesOrder,

      vbak.auart as SalesDocumentType,
      vbak.vkorg as SalesOrganization,
      vbak.kunnr as SoldToParty,

      _SoldToParty.name1 as SoldToPartyName,

      // 公开 association，别的 CDS 可以继续用
      _SoldToParty
}
