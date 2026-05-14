@AbapCatalog.sqlViewName: 'ZVSDHDR01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Header Basic View'
define view ZI_SD_SO_HEADER
  as select from vbak
{
  key vbeln as SalesOrder,
      auart as SalesDocumentType,
      vkorg as SalesOrganization,
      vtweg as DistributionChannel,
      spart as Division,
      kunnr as SoldToParty,
      erdat as CreatedOn,
      ernam as CreatedBy
}
