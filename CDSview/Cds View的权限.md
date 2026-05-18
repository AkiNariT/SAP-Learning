经常看到：<br>
  ```js
@AccessControl.authorizationCheck: #NOT_REQUIRED
  ```
练习可以这么写，但项目里不能随便写。<br>
<br>
CDS 有自己的权限控制概念，叫 ( DCL / Data Control Language )。<br>
也就是可以通过 CDS role 控制用户能看到哪些数据。<br>
SAP 官方文档说明，CDS access control 和传统 ABAP 权限概念是并存的。<br>

### 项目里你要问：<br>
 - 这个 View 是内部程序用？<br>
 - 还是 Fiori / OData 暴露出去？<br>
 - 是否需要会社コード、販売組織、プラント级别权限？<br>
----

比如你做一个销售订单 CDS：<br>
  ```js
@EndUserText.label: 'Sales Order Basic View'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_SD_SalesOrder
  as select from vbak
{
  key vbak.vbeln as SalesOrder,

      vbak.auart as SalesDocumentType,
      vbak.vkorg as SalesOrganization,
      vbak.vtweg as DistributionChannel,
      vbak.spart as Division,
      vbak.kunnr as SoldToParty,
      vbak.erdat as CreatedOn
}
  ```
这里最重要的是：<br>
  ```js
@AccessControl.authorizationCheck: #CHECK
//意思是这个 CDS View 是权限相关的，应该有 DCL 权限控制。
  ```


| 写法 | 说明 |
|---|---|
| #CHECK | 这个 CDS 期望被 DCL 权限控制 |
| #NOT_REQUIRED | 没有 DCL 也不报警；但如果有 DCL，仍然会生效 |
| #NOT_ALLOWED | 关闭 CDS Access Control，不允许这个 CDS 用 DCL 控制 | 
