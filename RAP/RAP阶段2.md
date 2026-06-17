## Behavior Implementation 业务逻辑

<details>
  
 <summary><h2>1.默认值代入</h2></summary>

Determination：自动代入默认值

先修改： `ZI_RAP_CONS_REQ`

```cds

managed implementation in class zbp_i_rap_cons_req unique;
strict ( 2 );
with draft;

define behavior for ZI_RAP_CONS_REQ alias ConsReq
persistent table ztrap_cons_req
draft table ztrap_cons_req_d
lock master total etag LastChangedAt
authorization master ( global )
etag master LocalLastChangedAt
{
  create;
  update;
  delete;

  draft action Edit;
  draft action Activate optimized;
  draft action Discard;
  draft action Resume;
  draft determine action Prepare;

  //创建数据时，自动执行 setDefaultValues 这个 determination
  determination setDefaultValues on modify { create; }  //在这个位置.

  field ( readonly )
  //从用户必填字段里拿掉，并改成后端自动控制。
    RequestDate,
    Status,    
  //
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt;

  field ( mandatory )
//    RequestDate,
    Requester,
    ItemText,
    Quantity,
    UnitCode,
    CostCenter;
//    Status;
  ......

```

然后修改Behavior Implementation Class

在修对象： `ZBP_I_RAP_CONS_REQ`

```js
METHODS setDefaultValues
  FOR DETERMINE ON MODIFY
  IMPORTING keys FOR ConsReq~setDefaultValues.

```

然后实现method
```js
METHOD setDefaultValues.

  //该行就是 EML，也就是 Entity Manipulation Language。
  //理解:
  //RAP 里不要直接 UPDATE 数据库表
  //而是通过 MODIFY ENTITIES 修改业务对象
  MODIFY ENTITIES OF zi_rap_cons_req IN LOCAL MODE

    ENTITY ConsReq
      UPDATE FIELDS ( RequestDate Status )
      WITH VALUE #(
        FOR key IN keys
        (
          //%tky是 RAP 的技术键。
          //告诉 RAP：我要修改当前这条正在创建的记录
          %tky        = key-%tky
          RequestDate = cl_abap_context_info=>get_system_date( )
          Status      = 'NEW'
        )
      )
    REPORTED DATA(update_reported).

  reported = CORRESPONDING #( DEEP update_reported ).

ENDMETHOD.
```

</details>

<details>
  
 <summary><h2>2.保存前校验</h2></summary>

Validation：保存前校验

假设有个重要的规则：Quantity 必须大于 0

也就是用户输入：Quantity 小于0时一定要报错，不许保存。

修改 `ZI_RAP_CONS_REQ`

在determination 后面，追加一行：

```cds
  .....
  draft action Edit;
  draft action Activate optimized;
  draft action Discard;
  draft action Resume;
  draft determine action Prepare;

  determination setDefaultValues on modify { create; }  

  //在保存时执行 checkQuantity
  //创建和修改时都检查
  //当 Quantity 字段相关时触发
  validation checkQuantity on save { create; update; field Quantity; }

  field ( readonly )
    RequestDate,
    Status, 
  .....

```

再修改: ZBP_I_RAP_CONS_REQ

```js
    METHODS checkQuantity
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR ConsReq~checkQuantity.

```

然后实现method

```js

  METHOD checkQuantity.
    //从当前 RAP 事务上下文读取数据
    READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      ENTITY ConsReq

        //这里只读取 Quantity 字段
        FIELDS ( Quantity )
        WITH CORRESPONDING #( keys )<img width="1917" height="1047" alt="image" src="https://github.com/user-attachments/assets/b03b0738-cbc9-4944-91d9-633cc2867969" />

      RESULT DATA(requests).

    LOOP AT requests ASSIGNING FIELD-SYMBOL(<request>).

      IF <request>-Quantity <= 0.

        //告诉 RAP：这条数据校验失败
        //如果不写 failed，有时消息显示了，但保存流程不一定被正确阻止。
        APPEND VALUE #( %tky = <request>-%tky )
          TO failed-consreq.

        //把错误消息返回给 Fiori 画面
        APPEND VALUE #(
          %tky = <request>-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Quantity must be greater than 0' )

        //把错误标记到 Quantity 字段上
          %element-Quantity = if_abap_behv=>mk-on
        ) TO reported-consreq.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

```

效果
<img width="1917" height="1047" alt="image" src="https://github.com/user-attachments/assets/bc022f89-31e3-4ad6-a1fc-48e24d1a9b0f" />

重点：<br>
validation = 保存前检查<br>
failed     = 阻止保存<br>
reported   = 返回消息给画面<br>

</details>

<details>
  
 <summary><h2>3.自定义 Action</h2></summary>

目标：点击 Submit → Status 从 NEW 改成 SUBMITTED

1.修改 Interface Behavior Definition  `ZI_RAP_CONS_REQ`<br>

```cds
  .....
  draft action Edit;
  draft action Activate optimized;
  draft action Discard;
  draft action Resume;
  draft determine action Prepare;

  determination setDefaultValues on modify { create; }  
  validation checkQuantity on save { create; update; field Quantity; }

  //定义一个后端业务动作 submit
  //执行后返回当前对象本身
  action submit result [1] $self;

  field ( readonly )
    RequestDate,
    Status, 

  .....
```

2.修改： `ZC_RAP_CONS_REQ `
```cds
  .....
  projection;
  strict ( 2 );
  use draft;

  define behavior for ZC_RAP_CONS_REQ alias ConsReq
  {
    use create;
    use update;
    use delete;

    use action Edit;
    use action Activate;
    use action Discard;
    use action Resume;
    use action Prepare;

    //底层 ZI_ 有 submit action
    //ZC_ 对外也开放 submit action
    use action submit;
  }


  .....
```

3.再修改: ZBP_I_RAP_CONS_REQ

```js
    METHODS submit
      FOR MODIFY
      IMPORTING keys FOR ACTION ConsReq~submit RESULT result.

```

然后实现method

把当前选中的申请记录 Status 改成 SUBMITTED<br>
然后重新读取更新后的数据<br>
最后把更新后的对象返回给 Fiori<br>

```js
  METHOD submit.

    MODIFY ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      ENTITY ConsReq
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky   = key-%tky
            Status = 'SUBMITTED'
          )
        )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      ENTITY ConsReq
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(updated_requests).

    result = VALUE #(
      FOR updated_request IN updated_requests
      (
        %tky   = updated_request-%tky
        %param = updated_request
      )
    ).

  ENDMETHOD.

```

4.修改 `ZUI_RAP_CONS_REQ`

```cds

annotate entity ZC_RAP_CONS_REQ with
{
  @UI.facet: [
    {
      id: 'General',
      purpose: #STANDARD,
      type: #IDENTIFICATION_REFERENCE,
      label: 'General Information',
      position: 10
    }
  ]

  //元代码
  //@UI.lineItem:       [{ position: 10, label: 'Request ID' }]
  //@UI.identification: [{ position: 10, label: 'Request ID' }]
  //RequestID;

  //本次修改
  @UI.lineItem: [
    { position: 10, label: 'Request ID' },
    { position: 90, type: #FOR_ACTION, dataAction: 'submit', label: 'Submit' }
  ]
  @UI.identification: [
    { position: 10, label: 'Request ID' },
    { position: 90, type: #FOR_ACTION, dataAction: 'submit', label: 'Submit' }
  ]
  RequestID;

  @UI.lineItem:       [{ position: 20, label: 'Request Date' }]
  @UI.identification: [{ position: 20, label: 'Request Date' }]
  @UI.selectionField: [{ position: 10 }]
  RequestDate;


```


让按钮显示在 Fiori 上



</details>
