@AbapCatalog.sqlViewName: 'ZVSDPARA01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order by Date Parameter'
define view ZI_SD_SO_BY_DATE
  with parameters
    p_date_from : abap.dats,
    p_date_to   : abap.dats
  as select from vbak
{
  key vbeln as SalesOrder,
      auart as SalesDocumentType,
      vkorg as SalesOrganization,
      kunnr as SoldToParty,
      erdat as CreatedOn
}
where erdat between $parameters.p_date_from
               and $parameters.p_date_to


   ```abap  
SELECT *
  FROM zi_sd_so_by_date(
         p_date_from = '20260101',
         p_date_to   = '20261231' )
  INTO TABLE @DATA(lt_result).
  ```
