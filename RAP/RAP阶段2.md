## Behavior Implementation 业务逻辑

常用的RAP技术字段表：

| 技术字段           | 常见位置                                                              | 作用                                               | 你现在的例子                                        |
| -------------- | ----------------------------------------------------------------- | ------------------------------------------------ | --------------------------------------------- |
| `%tky`         | `READ ENTITIES` 结果、`failed`、`reported`、`result`、`MODIFY ENTITIES` | RAP 技术键，用来定位当前事务中的一条记录。Draft 场景下尤其重要。            | `%tky = request-%tky`                         |
| `%key`         | 部分 EML 结果结构                                                       | 业务 key 结构，更接近 CDS 里的 key 字段。                     | 例如包含 `RequestID`                              |
| `%is_draft`    | Draft 场景                                                          | 标识当前数据是否是 Draft。                                 | 判断草稿/正式数据                                     |
| `%cid`         | `CREATE` 场景                                                       | 创建时的临时 correlation id，用来识别本次请求中新建的数据。            | Header/Item 深层创建常见                            |
| `%cid_ref`     | `CREATE BY _association` 场景                                       | 引用上级或前一步创建数据的 `%cid`。                            | 创建 Header 后再创建 Item                           |
| `%param`       | Action / Function result                                          | 放 Action 返回给前端的数据。                               | `%param = updated_request`                    |
| `%msg`         | `reported-xxx`                                                    | 返回消息给 Fiori / OData 消费端。                         | `new_message_with_text( ... )`                |
| `%element-字段名` | `reported-xxx`                                                    | 把消息绑定到某个字段上。                                     | `%element-Quantity = if_abap_behv=>mk-on`     |
| `%action-动作名`  | `get_instance_features`                                           | 控制某个 action 按钮是否可用。                              | `%action-submit = if_abap_behv=>fc-o-enabled` |
| `%field-字段名`   | `get_instance_features`                                           | 动态控制字段可编辑、只读等。                                   | `%field-CostCenter = ...`                     |
| `%assoc-关联名`   | `get_instance_features`                                           | 动态控制某个 association / create-by-association 是否可用。 | `%assoc-_Item = ...`                          |
| `%control-字段名` | `MODIFY ENTITIES` 输入                                              | 标记某个字段本次是否被传入/修改。                                | `%control-Status = if_abap_behv=>mk-on`       |
| `%state_area`  | state message 场景                                                  | 给持久消息分区，用来清除或管理状态消息。                             | validation 持久消息会用                             |
| `%path`        | 子节点消息 / composition 场景                                            | 指明消息属于哪条路径上的子对象。                                 | Header-Item 报错时常见                             |


常用的6个变量：
| 字段               | 必须掌握程度 | 简单理解            |
| ---------------- | -----: | --------------- |
| `%tky`           |     必须 | “是哪一条数据”        |
| `%msg`           |     必须 | “返回什么消息”        |
| `%element-字段名`   |     必须 | “消息标在哪个字段上”     |
| `%action-submit` |     必须 | “Submit 按钮能不能点” |
| `%param`         |     必须 | “Action 返回什么对象” |
| `%control-字段名`   |    先知道 | “本次修改了哪个字段”     |



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


<details>
  
 <summary><h2>4.自定义 Action 追加 Error check</h2></summary>
暂定check： <br>
只有 Status = NEW 的数据可以 Submit。<br>
如果已经是 SUBMITTED，再点 Submit 要报错。<br>

1.先修改： `ZBP_I_RAP_CONS_REQ`

method submit的代码换成下述。


```js
METHOD submit.

  DATA has_valid_request TYPE abap_bool VALUE abap_false.

  //这段是 RAP 里的 EML。
  //READ ENTITIES 读取当前业务对象
  //读取 RAP Business Object：ZI_RAP_CONS_REQ
  READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
    ENTITY ConsReq
      //表示只读取 Status 字段。
      FIELDS ( Status )
      //根据用户选中的 keys 去读取对应的数据
      WITH CORRESPONDING #( keys )
    //把读取结果放到内部表：
    RESULT DATA(requests).

  LOOP AT requests ASSIGNING FIELD-SYMBOL(<request>).

    IF <request>-Status <> 'NEW'.

      APPEND VALUE #( %tky = <request>-%tky )
        //failed-consreq 的作用是：告诉 RAP：这条记录处理失败
        TO failed-consreq.

      APPEND VALUE #(
        //%tky 是RAP技术键
        //在 Draft 场景下，业务主键不一定足够标识当前操作中的记录，所以 RAP 经常用 %tky 来准确定位当前对象。
        %tky = <request>-%tky
        %msg = new_message_with_text(
                 //表示消息等级是错误。
                 //常见还有：
                 //severity-warning
                 //severity-warning
                 //severity-success
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Only requests with status NEW can be submitted' )
        %element-Status = if_abap_behv=>mk-on
      //reported-consreq 的作用是：把消息返回给 Fiori 画面
      ) TO reported-consreq.

    ELSE.
      //意思是这批数据里至少有一条可以处理
      has_valid_request = abap_true.

    RETURN.

    ENDIF.

  ENDLOOP.


  IF has_valid_request = abap_true.

    MODIFY ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      ENTITY ConsReq
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          FOR request IN requests
          WHERE ( Status = 'NEW' )
          (
            %tky   = request-%tky
            Status = 'SUBMITTED'
          )
        )
      FAILED DATA(modify_failed)
      REPORTED DATA(modify_reported).

    APPEND LINES OF modify_failed-consreq TO failed-consreq.
    APPEND LINES OF modify_reported-consreq TO reported-consreq.

    READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      ENTITY ConsReq
        ALL FIELDS
        WITH VALUE #(
          FOR request IN requests
          WHERE ( Status = 'NEW' )
          (
            %tky = request-%tky
          )
        )
      RESULT DATA(updated_requests).

    result = VALUE #(
      FOR updated_request IN updated_requests
      (
        %tky   = updated_request-%tky
        %param = updated_request
      )
    ).

  ENDIF.

ENDMETHOD.

```
Action 内部也可以做业务校验。<br>

它和 Validation 的区别：
| 类型           | 触发时机          |
| ------------ | ------------- |
| `validation` | 保存时自动检查       |
| `action` 内校验 | 用户点击某个业务按钮时检查 |


</details>


<details>
 <summary><h2>5.Instance Feature：根据每条数据状态，动态控制按钮是否可用。</h2></summary>

举例：
```text
Status = NEW        → Submit 按钮可点
Status = SUBMITTED  → Submit 按钮不可点
```

第 1 步：修改 Interface Behavior <br>
修改`ZI_RAP_CONS_REQ`。<br>

```CDS
...
  determination setDefaultValues on modify { create; }
  validation checkQuantity on save { create; update; field Quantity; }
  //旧代码
  //action submit result [1] $self;
  action ( features : instance ) submit result [0..1] $self;
...
```

新加部分`features : instance`<br>
含义：这个 action 的可用性，由每一条实例数据自己决定。<br>

第 2 步：新方法 get_instance_features

修改`ZBP_I_RAP_CONS_REQ`
```js
METHODS get_instance_features
  FOR INSTANCE FEATURES
  IMPORTING keys REQUEST requested_features FOR ConsReq RESULT result.

```

实现`get_instance_features`

```js
METHOD get_instance_features.
  //515-517行含义位读取当前行的Status。
  READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
    ENTITY ConsReq
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
    RESULT DATA(requests).

  result = VALUE #(
    FOR request IN requests
    (
      %tky = request-%tky
      %action-submit = COND #(
        //如果 Status = NEW
        WHEN request-Status = 'NEW'
        //Submit 按钮可用
        THEN if_abap_behv=>fc-o-enabled
        //Submit 按钮禁用
        ELSE if_abap_behv=>fc-o-disabled
      )
    )
  ).

ENDMETHOD.
```

</details>


<details>
  
 <summary><h2>6.动态字段控制：提交后不允许再改字段。</h2></summary>
设计：

```text
Status = NEW        → 字段可以编辑
Status = SUBMITTED  → 字段变成只读
```

先修改`ZI_RAP_CONS_REQ Behavior Definition`<br>
添加代码<br>

```cds
field ( features : instance )
  Requester,
  ItemText,
  Quantity,
  UnitCode,
  CostCenter;
```

需要修改`ZBP_I_RAP_CONS_REQ`

```js
METHOD get_instance_features.

  READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
    ENTITY ConsReq
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
    RESULT DATA(requests).

  result = VALUE #(
    FOR request IN requests
    (
      %tky = request-%tky

      %action-submit = COND #(
        WHEN request-Status = 'NEW'
        THEN if_abap_behv=>fc-o-enabled  //操作可用
        ELSE if_abap_behv=>fc-o-disabled //操作不可用
      )
      //下述代码是本次追加的
      %field-Requester = COND #(
        WHEN request-Status = 'NEW'
        THEN if_abap_behv=>fc-f-unrestricted  //字段不限制，允许编辑
        ELSE if_abap_behv=>fc-f-read_only     //字段只读
      )

      %field-ItemText = COND #(
        WHEN request-Status = 'NEW'
        THEN if_abap_behv=>fc-f-unrestricted  
        ELSE if_abap_behv=>fc-f-read_only
      )

      %field-Quantity = COND #(
        WHEN request-Status = 'NEW'
        THEN if_abap_behv=>fc-f-unrestricted
        ELSE if_abap_behv=>fc-f-read_only
      )

      %field-UnitCode = COND #(
        WHEN request-Status = 'NEW'
        THEN if_abap_behv=>fc-f-unrestricted
        ELSE if_abap_behv=>fc-f-read_only
      )

      %field-CostCenter = COND #(
        WHEN request-Status = 'NEW'
        THEN if_abap_behv=>fc-f-unrestricted
        ELSE if_abap_behv=>fc-f-read_only
      )
    )
  ).

ENDMETHOD.
```

RAP 根据字段名自动生成 feature 控制字段：
```text
%field-Requester
%field-ItemText
%field-Quantity
%field-UnitCode
%field-CostCenter
```
</details>

<details>
  
 <summary><h2>7.Side Effects</h2></summary>

Side Effects 不是业务逻辑。它本身不修改数据。<br>
它的作用是告诉 Fiori Elements：局部重新取数 / 重新计算 UI 状态,不是整个浏览器刷新。<br>

第 1 步：修改 `ZI_RAP_CONS_REQ`

```cds

  draft action Activate optimized;
  draft action Discard;
  draft action Resume;
  draft determine action Prepare;

  determination setDefaultValues on modify { create; }
  validation checkQuantity on save { create; update; field Quantity; }
  action ( features : instance ) submit result [0..1] $self;

  side effects { action submit affects $self; }

```

</details>


<details>
  
 <summary><h2>8.Value Help：给字段做搜索帮助 / 下拉选择。</h2></summary>
设计。给 UnitCode 做自建 Value Help。用户可以从候选里选。<br>
现在的 UnitCode 是手动输入。<br>


第 1 步：创建单位 Value Help 表

创建 Database Table：`ZTRAP_UNIT_VH`
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/a86d575f-fe9a-4457-8dfa-1c97154eb6be" />
<img width="611" height="265" alt="image" src="https://github.com/user-attachments/assets/83199352-30c4-4229-b707-11d6d0355599" />

第 2 步：创建 Value Help CDS View
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/7ecbab0b-e559-45aa-83e8-7103782f0001" />
<img width="615" height="227" alt="image" src="https://github.com/user-attachments/assets/86885e43-1fa9-4e26-a11b-db4b25853a02" />

第 3 步：准备测试数据
创建 Class：ZCL_RAP_FILL_VH_DATA
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/2d0846dc-b61c-444d-9377-d2ec09351b13" />

```js
CLASS zcl_rap_fill_vh_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_rap_fill_vh_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DELETE FROM ztrap_unit_vh.

    INSERT ztrap_unit_vh FROM TABLE @(
      VALUE #(
        ( client = sy-mandt unit_code = 'EA' unit_text = 'Each' )
        ( client = sy-mandt unit_code = 'PC' unit_text = 'Piece' )
        ( client = sy-mandt unit_code = 'KG' unit_text = 'Kilogram' )
        ( client = sy-mandt unit_code = 'L'  unit_text = 'Liter' )
        ( client = sy-mandt unit_code = 'M'  unit_text = 'Meter' )
      )
    ).

    COMMIT WORK.

    out->write( 'Unit value help data created.' ).

  ENDMETHOD.

ENDCLASS.
```


第 4 步：给 UnitCode 加 Value Help 注解
找到 ZC_RAP_CONS_REQ 的 Data Definitions 开始修改。<br>
<img width="632" height="727" alt="image" src="https://github.com/user-attachments/assets/81eb2cfa-dba1-428f-b08e-83ee24edb634" />

第 5 步：Service Definition 里也暴露 Value Help
修改`ZSD_RAP_CONS_REQ`。
```cds
@EndUserText.label: 'Consumable Request Service Definition'
define service ZSD_RAP_CONS_REQ {
  expose ZC_RAP_CONS_REQ as ConsumableRequest;

  //追加代码
  expose ZI_RAP_UNIT_VH as UnitValueHelp;
}

```

为什么要暴露？<br>
因为 Fiori Elements 需要通过 OData 服务读取 Value Help 候选值。<br>

</details>

<details>
  
 <summary><h2>9.Association：关联其他 CDS / 主数据  (已经关联到OData)</h2></summary>
做数据关联，例如 UnitCode = EA 
我们要做成在选择 UnitCode = EA 时自动带出他的 UnitText 。

前提住准备：<br>
```text
ZTRAP_UNIT_VH      单位表
ZI_RAP_UNIT_VH     单位 CDS View
```

<img width="496" height="280" alt="image" src="https://github.com/user-attachments/assets/5a8ae8be-2281-44b3-8d9a-6a10cde5d8f6" />


第 1 步：修改 ZI_RAP_CONS_REQ
先修改：ZI_RAP_CONS_REQ
```CDS
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Consumable Request Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_RAP_CONS_REQ 
  as select from ztrap_cons_req
  //本次追加代码
  association [0..1] to ZI_RAP_UNIT_VH as _Unit
    on $projection.UnitCode = _Unit.UnitCode
{
    
  key request_id as RequestID,

      request_date as RequestDate,
      requester    as Requester,
      item_text    as ItemText,

      quantity     as Quantity,
      unit         as UnitCode,

      cost_center  as CostCenter,
      status       as Status,

      @Semantics.user.createdBy: true
      created_by as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      //本次追加代码
      _Unit
}


```

第 2 步：修改 ZC_RAP_CONS_REQ
```CDS
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Consumable Request Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_RAP_CONS_REQ 
    provider contract transactional_query
    as projection on ZI_RAP_CONS_REQ
{
  key RequestID,

      RequestDate,
      Requester,
      ItemText,

      Quantity,
      //本次追加
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'ZI_RAP_UNIT_VH',
            element: 'UnitCode'
          }
        }
      ]
      UnitCode,

      CostCenter,
      Status,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      //本次追加代码
      _Unit
}

```

第 3 步：修改Behavior Definition： ZI_RAP_CONS_REQ
UnitText，建议把它放到 readonly 里。
```CDS
...
field ( readonly )
  RequestDate,
  Status,
  //本次追加
  UnitText,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt;
...

```

<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/0a34400a-4e81-47f9-8ca8-a876eaee29c4" />
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/e68e52c3-7be3-4171-b83e-b6c9c36ccee3" />
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/8a3e7ea1-8af0-464b-9a26-072d841a7bca" />
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/fbc87dbd-3934-43fb-b6cb-9c2711b2286d" />
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/b47b0220-99e9-40e6-b116-4490227a8777" />
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/b2de4d5a-75fb-4014-a533-481dbca3e6e3" />


http code是200。证明请求成功。<br>


$top=5<br>
再Odata中意思取得前多少数据。<br>

再JSON文件中我们看见类似下述，证明取得成功。<br>
```JSON
"UnitCode": "EA",
"_Unit": {
  "UnitCode": "EA",
  "UnitText": "Each"
}

```
</details>



<details>
  
 <summary><h2>10.Association深入讲解(一)：Association 到底和 Join 有什么区别</h2></summary>

<img width="702" height="587" alt="image" src="https://github.com/user-attachments/assets/a3acf3b4-fc74-444c-bf3d-cf38c8738ca5" />

该状态说明RAP OData服务器里已经有了一个导航关系：<br>
ConsumableRequest → _Unit → UnitValueHelp<br>

<img width="641" height="321" alt="image" src="https://github.com/user-attachments/assets/370f7467-0440-4c65-9a35-5e600a28cb66" />

| 写法       | 含义         | 典型例子           |
| -------- | ---------- | -------------- |
| `[0..1]` | 可能没有，最多一条  | 申请 → 单位说明      |
| `[1..1]` | 必须有，且只有一条  | Item → Header  |
| `[0..*]` | 可能没有，也可能多条 | Header → Items |
| `[1..*]` | 至少一条，可能多条  | 理论可用，但项目里谨慎    |




含义是：每一条 ConsumableRequest，根据 UnitCode，最多能找到一条 UnitValueHelp。<br>
所以 _Unit 本身不是字段，它是通往另一个实体的路径。<br>

Association 和 Join 的核心区别：<br>
Join 是“马上拼表”。<br>
  
Association 是“先定义关系，不一定马上取”<br>
Association 是：ConsumableRequest 可以通过 _Unit 找到 UnitValueHelp。<br>
平时只查：ConsumableRequest。<br>
它不一定马上去取 _Unit。只有你明确要求：$expand=_Unit。<br>
它才把 _Unit 展开出来。<br>

</details>


<details>
  
 <summary><h2>11.Composition</h2></summary>

注意：因为 Composition 会改动对象结构，记得保存。



## Association 和 Composition 的区别
| 项目      | Association | Composition |
| ------- | ----------- | ----------- |
| 关系强度    | 普通关联        | 父子从属        |
| 例子      | 申请 → 单位说明   | 申请头 → 申请明细  |
| 生命周期    | 各自独立        | 子对象依附父对象    |
| 删除父对象   | 不一定影响目标对象   | 子对象通常一起处理   |
| RAP 重要性 | 数据导航        | 业务对象建模核心    |


这一阶段我们会做什么：
```text
ConsumableRequest
  └─ Items
```

目标结构：
```text
ZTRAP_CONS_REQ       Header 表
ZTRAP_CONS_ITEM      Item 表

ZI_RAP_CONS_REQ      Header Root View
ZI_RAP_CONS_ITEM     Item Child View

ZC_RAP_CONS_REQ      Header Projection
ZC_RAP_CONS_ITEM     Item Projection

Behavior Definition 里追加：
composition [0..*] of ZI_RAP_CONS_ITEM as _Items
```

## 第 1 步：创建 Item 明细表。<br>
已有 Header 表：ZTRAP_CONS_REQ<br>
新增 Item 表：ZTRAP_CONS_ITEM<br>

以后结构会变成：
```text
Consumable Request Header
  └─ Consumable Request Items
```
即一张申请 Header，可以有多条申请明细 Item。

### 创建 Database Table
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/0d8cd24a-c399-420c-b35c-958821d4ac9d" />

```CDS
@EndUserText.label : 'RAP Consumable Request Item Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztrap_cons_item {

  key client            : abap.clnt not null;
  key item_uuid         : sysuuid_x16 not null;
  request_id            : sysuuid_x16 not null;
  item_no               : abap.numc(6);
  item_text             : abap.char(80);
  unit_code             : abap.char(3);
  quantity              : abap.dec(13,3);
  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  last_changed_by       : abp_lastchange_user;
  last_changed_at       : abp_lastchange_tstmpl;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;

}
```

### 创建 Draft Table
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/0dc4c57b-5f76-4d76-90e9-13c2d17414c6" />

```cds
@EndUserText.label : 'Draft table for entity ZTRAP_CONS_ITEM'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztrap_cons_ite_d {

  key client         : abap.clnt not null;
  key itemuuid       : sysuuid_x16 not null;
  requestid          : sysuuid_x16 not null;
  itemno             : abap.numc(6);
  itemtext           : abap.char(80);
  unitcode           : abap.unit(3);
  @Semantics.quantity.unitOfMeasure : 'ztrap_cons_ite_d.unitcode'
  quantity           : abap.quan(13,3);
  createdby          : abp_creation_user;
  createdat          : abp_creation_tstmpl;
  lastchangedby      : abp_lastchange_user;
  lastchangedat      : abp_lastchange_tstmpl;
  locallastchangedat : abp_locinst_lastchange_tstmpl;
  "%admin"           : include sych_bdl_draft_admin_inc;

}
```


## 第 2 步：创建 Item的Interface CDS : View ZI_RAP_CONS_ITEM

新建 Data Definition :ZI_RAP_CONS_ITEM
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/0bb2c2a2-b56c-4f2d-9cfd-69af7ddd6c90" />
```cds
@EndUserText.label: 'RAP Consumable Request Item Interface View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_RAP_CONS_ITEM
  as select from ztrap_cons_item
  association to parent ZI_RAP_CONS_REQ as _Request
    on $projection.RequestID = _Request.RequestID
{
  key item_uuid  as ItemUUID,

      request_id as RequestID,
      item_no    as ItemNo,
      item_text  as ItemText,

      unit_code  as UnitCode,
      quantity   as Quantity,

      @Semantics.user.createdBy: true
      created_by as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Request
}

```

## 第 3 步：在Header的 ZI_RAP_CONS_REQ 里追加 Composition _Items。
```cds
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Consumable Request Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_RAP_CONS_REQ 
  as select from ztrap_cons_req
  //本次追加代码
  composition [0..*] of ZI_RAP_CONS_ITEM as _Items
  association [0..1] to ZI_RAP_UNIT_VH as _Unit
    on $projection.UnitCode = _Unit.UnitCode
{
    
  key request_id as RequestID,

      request_date as RequestDate,
      requester    as Requester,
      item_text    as ItemText,

      quantity     as Quantity,
      unit         as UnitCode,

      cost_center  as CostCenter,
      status       as Status,

      @Semantics.user.createdBy: true
      created_by as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Unit,
      //本次追加代码
      _Items
}

```

## 第 3 步：让 RAP runtime 认识 Header-Item 关系。
现在已经追加的东西。
```text
ZTRAP_CONS_ITEM        Item 数据库表
ZI_RAP_CONS_ITEM       Item Interface View
ZI_RAP_CONS_REQ        Header 里追加 composition _Items
```

本次修改 Behavior Definition : ZI_RAP_CONS_REQ<br>


</details>
