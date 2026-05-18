## Association 理解成"预先写好的 Join 路线"<br>


 - 普通 Join 是
  > 我现在就要把 A 表和 B 表拼起来。

<br>

 - Association 是：
  > 我先告诉 CDS：A 和 B 怎么关联。<br>
  > 至于现在要不要真的去取 B 的字段，要看后面有没有用到这条关联路线。

<br>
简单例子：<br>

  ```js
@AbapCatalog.sqlViewName: 'ZVSOH001'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Header with Association'
define view ZI_SO_HEADER
  as select from vbak
  association [0..1] to kna1 as _Customer
    on $projection.Customer = _Customer.kunnr
{
  key vbak.vbeln as SalesOrder,
      vbak.auart as SalesOrderType,
      vbak.kunnr as Customer,

      _Customer
}
  ```
