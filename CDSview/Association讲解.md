## Association 理解成"预先写好的 Join 路线"<br>


 - 普通 Join 是
  > 我现在就要把 A 表和 B 表拼起来。

<br>

 - Association 是：
  > 我先告诉 CDS：A 和 B 怎么关联。<br>
  > 至于现在要不要真的去取 B 的字段，要看后面有没有用到这条关联路线。

---

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
最重要的部分：<br>
  ```js
association [0..1] to kna1 as _Customer
  on $projection.Customer = _Customer.kunnr
//当前 CDS 的每一条销售订单 Header，可以通过 Customer 字段，找到 KNA1 里的客户主数据。
  ```

---

### 简单对比：<br>
普通 Join:
  ```js
define view ZI_SO_HEADER_JOIN
  as select from vbak
    left outer join kna1
      on vbak.kunnr = kna1.kunnr
{
  key vbak.vbeln as SalesOrder,
      vbak.kunnr as Customer,
      kna1.name1 as CustomerName
}
  ```
Association 写法：
  ```js
define view ZI_SO_HEADER_ASSOC
  as select from vbak
  association [0..1] to kna1 as _Customer
    on $projection.Customer = _Customer.kunnr
{
  key vbak.vbeln as SalesOrder,
      vbak.kunnr as Customer,

      _Customer.name1 as CustomerName
}
  ```
| 写法 | 含义 |
|---|---|
| association ... as _Customer | 定义一条关联路线 |
| { ..., _Customer } | 把路线公开给别人用 |
| { ..., _Customer.name1 } | 当前 CDS 自己使用路线取字段，这时会变成 Join | 
| 外部 CDS 用 Header._Customer.name1 | 外部使用这条路线，也会触发 Join | 

---
### 为什么 Association 名字通常带 _？
这不是语法强制，纯粹是为了区分。<br>
项目里看到 _xxx，你基本可以先判断它是 association。
  ```abap
Customer      是字段
_Customer     是关联对象
  ```

### [0..1] 是什么？
[0..1] 叫 Cardinality，日语可以叫：カーディナリティ。<br>
它表示当前这一条源数据，最多能找到几条目标数据。
  ```js
association [0..1] to kna1 as _Customer
  ```
| Cardinality | 意思 | 例子 |
|---|---|---|
| [0..1] | 可能没有，也最多一条 | 销售订单 Header → 客户主数据 |
| [1..1] | 必须有，而且只有一条 | 明确一定存在的主数据关系 |
| [0..*] | 可能没有，也可能多条 | 销售订单 Header → 销售订单明细 |
| [1..*] | 至少一条，可能多条 | 理论上订单 Header → 明细，但实际不常这么写 |

### [0..1] 不等于系统帮你检查唯一
