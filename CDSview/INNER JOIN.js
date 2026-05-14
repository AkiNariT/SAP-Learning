@AbapCatalog.sqlViewName: 'ZVSDITM01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Header Item Join'
define view ZI_SD_SO_ITEM
  as select from vbak
    inner join vbap
      on vbak.vbeln = vbap.vbeln
{
  key vbak.vbeln as SalesOrder,
  key vbap.posnr as SalesOrderItem,

      vbak.auart as SalesDocumentType,
      vbak.vkorg as SalesOrganization,
      vbak.kunnr as SoldToParty,

      vbap.matnr as Material,
      vbap.arktx as MaterialDescription,
      vbap.kwmeng as OrderQuantity,
      vbap.vrkme as SalesUnit,
      vbap.netwr as NetAmount,
      vbap.waerk as Currency
}
