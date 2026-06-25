## Item Quantity 校验

RAP第二阶段做完，我们已经成功添加明细。<br>
下一步开始做明细的check。<br>

设计目标：<br>
Item 的 Quantity 必须大于 0<br>
其他数值时都要报错。<br>

先修改Interface Behavior：ZI_RAP_CONS_REQ

```cds
  ......
  field ( mandatory )
    ItemNo,
    ItemText,
    UnitCode,
    Quantity;
  //本次追加代码
  validation checkItemQuantity on save { create; update; field Quantity; }

  association _Request { with draft; }

  mapping for ztrap_cons_item
  {
    ItemUUID           = item_uuid;
    RequestID          = request_id;
  ......
```
