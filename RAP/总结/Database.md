# 1. Database 控制什么
部分代码讲解：<br>
下述这些代码叫`Annotation`，注解 / 元数据。<br>


```text
@EndUserText.label : 'RAP Consumable Request Item Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
......
```

<br>

`@EndUserText.label :`<br>
表对象的短文本说明。<br>
<br>
`@AbapCatalog.enhancement.category :`<br>
它控制这张表以后能不能被增强 / append 字段。<br>
| 值                               | 含义                       |
| ------------------------------- | ------------------------ |
| `#NOT_EXTENSIBLE`               | 不允许增强                    |
| `#EXTENSIBLE_CHARACTER`         | 允许增强，但追加字段应是字符类字段        |
| `#EXTENSIBLE_CHARACTER_NUMERIC` | 允许增强，追加字段可以是字符类或数值类      |
| `#EXTENSIBLE_ANY`               | 允许增强，追加字段可以是任意类型，包括更复杂类型 |
| `#NOT_CLASSIFIED`               | 未分类，老对象里可能看到，新开发不建议用     |

<br>

`@AbapCatalog.tableCategoryc :`<br>
它控制表的表类别。<br>
| 值                   | 含义           | RAP 里常用吗    |
| ------------------- | ------------ | ----------- |
| `#TRANSPARENT`      | 透明表，正常持久化表   | 常用          |
| `#GLOBAL_TEMPORARY` | 全局临时表，保存临时数据 | RAP 业务表一般不用 |

<br>

`@AbapCatalog.deliveryClass :`<br>
它控制这张表的数据在不同场景下怎么处理。
| 值    | 含义                       | 你现在是否常用   |
| ---- | ------------------------ | --------- |
| `#A` | 应用表，主数据/业务数据             | 最常用       |
| `#C` | Customizing 表，客户配置数据     | 配置表会用     |
| `#L` | 临时数据表                    | 少用        |
| `#G` | 客户表，SAP 可追加数据但不修改/删除客户数据 | 很少自己用     |
| `#E` | 系统表，但客户可以维护部分内容          | 很少自己用     |
| `#S` | SAP 系统表，SAP 交付预置数据       | 不用于普通 Z 表 |
| `#W` | 系统管理数据表                  | 不用于普通 Z 表 |

<br>
<br>

`@AbapCatalog.dataMaintenance :`<br>
它控制这张表的数据是否允许通过 Data Preview、SE16、SM30/SM31 等方式显示或维护。<br>
| 值                       | 大概含义                  |
| ----------------------- | --------------------- |
| `#RESTRICTED`           | 限制维护，RAP 业务表常用        |
| `#ALLOWED`              | 允许显示/维护表内容            |
| `#NOT_ALLOWED`          | 不允许显示/维护              |
| `#DISPLAY` / `#LIMITED` | 通常偏向只显示、不直接维护，具体看系统版本 |


## 其他注解
`@AbapCatalog.enhancement.fieldSuffix :`<br>
它用于限制扩展字段名的后缀。<br>
通常和`@AbapCatalog.enhancement.category :`联用。<br>
```abap
@AbapCatalog.enhancement.category    : #EXTENSIBLE_CHARACTER_NUMERIC
@AbapCatalog.enhancement.fieldSuffix : 'ZZ1'
```

<br>

`@AbapCatalog.replacementObject :`<br>
这个比较特殊。<br>
它表示对某张表的读取可以被替换到某个 CDS entity 上。普通 RAP 自建表不要用。<br>
这是特殊兼容/替换场景，不是 RAP 初学重点。<br>


## 字段级别常见注解
### 金额和货币
```abap
@Semantics.amount.currencyCode : 'zrap_cons_req_i.currency_code'
amount        : abap.curr(15,2);
currency_code : abap.cuky;
```
意思是：amount 这个金额字段，对应的货币字段是 currency_code。

### 数量和单位
```abap
@Semantics.quantity.unitOfMeasure : 'zrap_cons_req_i.unit'
quantity : abap.quan(13,3);
unit     : meins;
```
意思是：quantity 这个数量字段，对应的单位字段是 unit。

### 外键相关注解
```abap
@AbapCatalog.foreignKey.label
@AbapCatalog.foreignKey.keyType
@AbapCatalog.foreignKey.screenCheck
@AbapCatalog.foreignKey.messageClass
@AbapCatalog.foreignKey.messageNumber
```
初学 RAP 时不用先深入。RAP 的业务关联主要先通过 CDS association / composition 来表达。
