@AbapCatalog.sqlViewName: 'ZVSDOR01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Standard Sales Order Only'
define view ZI_SD_STANDARD_ORDER
  as select from vbak
{
  key vbeln as SalesOrder,
      auart as SalesDocumentType,
      vkorg as SalesOrganization,
      kunnr as SoldToParty,
      erdat as CreatedOn
}
where auart = 'OR'
