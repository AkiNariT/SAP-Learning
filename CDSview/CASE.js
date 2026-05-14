@AbapCatalog.sqlViewName: 'ZVSDCASE01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Type Case Example'
define view ZI_SD_SO_TYPE_CASE
  as select from vbak
{
  key vbeln as SalesOrder,

      auart as SalesDocumentType,

      case auart
        when 'OR' then 'Standard Order'
        when 'RE' then 'Return Order'
        when 'FD' then 'Free of Charge'
        else 'Other'
      end as SalesDocumentTypeText,

      vkorg as SalesOrganization,
      kunnr as SoldToParty
}
