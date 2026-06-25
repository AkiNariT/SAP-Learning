<details>
  
 <summary><h2>1.Item Quantity 校验</h2></summary>

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

修改 Behavior Implementation Class：ZBP_I_RAP_CONS_REQ
```abap
......

CLASS lhc_ConsItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS checkItemQuantity
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR ConsItem~checkItemQuantity.

ENDCLASS.

......
CLASS  lhc_ConsItem IMPLEMENTATION.

  METHOD checkItemQuantity.

    READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      ENTITY ConsItem
        FIELDS ( Quantity )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    LOOP AT items ASSIGNING FIELD-SYMBOL(<item>).

      IF <item>-Quantity IS INITIAL OR <item>-Quantity <= 0.

        APPEND VALUE #( %tky = <item>-%tky )
          TO failed-consitem.

        APPEND VALUE #(
          %tky = <item>-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Item quantity must be greater than 0' )
          %element-Quantity = if_abap_behv=>mk-on
        ) TO reported-consitem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

```

### 测试结果
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/56efc449-f51e-46bf-8e20-ecdfef45faab" />

</details>

<details>
  
 <summary><h2>2.Item 自动编号</h2></summary>

设计：自动编号<br>
先修改Interface Behavior：ZI_RAP_CONS_REQ

```cds
define behavior for ZI_RAP_CONS_ITEM alias ConsItem
persistent table ztrap_cons_item
draft table ztrap_cons_ite_d
lock dependent by _Request
authorization dependent by _Request
etag master LocalLastChangedAt
{
  update;
  delete;

  field ( readonly, numbering : managed ) ItemUUID;

  field ( readonly )
    RequestID,
    //本次追加
    ItemNo,
    //
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt;

  field ( mandatory )
    //本次更改代码
    //ItemNo,
    ItemText,
    UnitCode,
    Quantity;

  //本次追加代码，他影响着后面method：setItemNo的实装
  determination setItemNo on modify { create; }
  
  validation checkItemQuantity on save { create; update; field Quantity; }

  association _Request { with draft; }

  ......

```

修改 Behavior Implementation Class：ZBP_I_RAP_CONS_REQ
```abap
......
METHODS checkItemQuantity
  FOR VALIDATE ON SAVE
IMPORTING keys FOR ConsItem~checkItemQuantity.
......
METHOD setItemNo.

  TYPES:
    BEGIN OF ty_max_item,
      requestid TYPE sysuuid_x16,
      max_no    TYPE i,
    END OF ty_max_item.

  DATA max_items TYPE HASHED TABLE OF ty_max_item
    WITH UNIQUE KEY requestid.

  DATA updates TYPE TABLE FOR UPDATE zi_rap_cons_req\\ConsItem.

  "读取本次新建/修改触发 determination 的 Item
  READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
    ENTITY ConsItem
      FIELDS ( RequestID ItemNo )
      WITH CORRESPONDING #( keys )
    RESULT DATA(items).

  IF items IS INITIAL.
    RETURN.
  ENDIF.

  "通过 Item 找到对应 Header
  READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
    ENTITY ConsItem BY \_Request
      FIELDS ( RequestID )
      WITH CORRESPONDING #( keys )
    RESULT DATA(requests).

  IF requests IS INITIAL.
    RETURN.
  ENDIF.

  "读取这些 Header 下的全部 Items
  READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
    ENTITY ConsReq BY \_Items
      FIELDS ( RequestID ItemNo )
      WITH CORRESPONDING #( requests )
    RESULT DATA(all_items).

  "先计算每个 Header 下现有最大 ItemNo
  LOOP AT all_items ASSIGNING FIELD-SYMBOL(<existing_item>)
    WHERE ItemNo IS NOT INITIAL.

    DATA(current_no) = CONV i( <existing_item>-ItemNo ).

    READ TABLE max_items ASSIGNING FIELD-SYMBOL(<max_item>)
      WITH TABLE KEY requestid = <existing_item>-RequestID.

    IF sy-subrc <> 0.
      INSERT VALUE #(
        requestid = <existing_item>-RequestID
        max_no    = current_no
      ) INTO TABLE max_items.
    ELSEIF current_no > <max_item>-max_no.
      <max_item>-max_no = current_no.
    ENDIF.

  ENDLOOP.

  "给本次新增且没有 ItemNo 的 Item 编号
  LOOP AT items ASSIGNING FIELD-SYMBOL(<item>)
    WHERE ItemNo IS INITIAL.

    DATA(next_no) = 10.

    READ TABLE max_items ASSIGNING <max_item>
      WITH TABLE KEY requestid = <item>-RequestID.

    IF sy-subrc = 0.
      next_no = <max_item>-max_no + 10.
      <max_item>-max_no = next_no.
    ELSE.
      INSERT VALUE #(
        requestid = <item>-RequestID
        max_no    = next_no
      ) INTO TABLE max_items.
    ENDIF.

    DATA item_no TYPE ztrap_cons_item-item_no.
    item_no = |{ next_no WIDTH = 6 ALIGN = RIGHT PAD = '0' }|.

    APPEND VALUE #(
      %tky   = <item>-%tky
      ItemNo = item_no
    ) TO updates.

  ENDLOOP.

  IF updates IS NOT INITIAL.

    MODIFY ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      ENTITY ConsItem
        UPDATE FIELDS ( ItemNo )
        WITH updates.

  ENDIF.

ENDMETHOD.

```
自动带出成功
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/3bb93798-f5f0-4cbb-be00-305036dcfc51" />

</details>


<details>
  
 <summary><h2>3.Submit 前整单校验。</h2></summary>
设计目标：<Br>
```text
Header 有 Items → 可以 Submit
Header 没有 Items → 报错
```

### 修改 ZBP_I_RAP_CONS_REQ 的 submit 方法
```abap
METHOD submit.

  "DATA has_valid_request TYPE abap_bool VALUE abap_false.

  READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
    ENTITY ConsReq
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
    RESULT DATA(requests).

  "追加代码
  READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
    ENTITY ConsReq BY \_Items
      FIELDS ( ItemUUID RequestID ItemNo )
      WITH CORRESPONDING #( keys )
    RESULT DATA(items).
  "追加代码
  DATA requests_to_submit LIKE requests.

  "本次loop修改
  LOOP AT requests ASSIGNING FIELD-SYMBOL(<request>).
    "1. 状态检查：只有 NEW 可以 Submit
    IF <request>-Status <> 'NEW'.

      APPEND VALUE #( %tky = <request>-%tky )
        TO failed-consreq.

      APPEND VALUE #(
        %tky = <request>-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Only requests with status NEW can be submitted' )
        %element-Status = if_abap_behv=>mk-on
      ) TO reported-consreq.

    "ELSE.
      "has_valid_request = abap_true.

    ENDIF.

    "2. 明细检查：没有 Item 不允许 Submit
    IF NOT line_exists( items[ RequestID = <request>-RequestID ] ).

      APPEND VALUE #( %tky = <request>-%tky )
        TO failed-consreq.

      APPEND VALUE #(
        %tky = <request>-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'At least one item is required before submit' )
      ) TO reported-consreq.

      CONTINUE.

    ENDIF.


    "3. 只有通过检查的 Header 才放进提交对象
    APPEND <request> TO requests_to_submit.

  ENDLOOP.

 IF requests_to_submit IS NOT INITIAL.

    MODIFY ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      ENTITY ConsReq
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          FOR request IN requests_to_submit
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
          FOR request IN requests_to_submit
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
  "IF has_valid_request = abap_true.

   "MODIFY ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      "ENTITY ConsReq
        "UPDATE FIELDS ( Status )
        "WITH VALUE #(
          "FOR request IN requests
          "WHERE ( Status = 'NEW' )
          "(
            "%tky   = request-%tky
            "Status = 'SUBMITTED'
          ")
        ")
      "FAILED DATA(modify_failed)
      "REPORTED DATA(modify_reported).

    "APPEND LINES OF modify_failed-consreq TO failed-consreq.
    "APPEND LINES OF modify_reported-consreq TO reported-consreq.

    "READ ENTITIES OF zi_rap_cons_req IN LOCAL MODE
      "ENTITY ConsReq
        "ALL FIELDS
        "WITH VALUE #(
          "FOR request IN requests
          "WHERE ( Status = 'NEW' )
          "(
            "%tky = request-%tky
          ")
        ")
      "RESULT DATA(updated_requests).

    "result = VALUE #(
      "FOR updated_request IN updated_requests
      "(
        "%tky   = updated_request-%tky
        "%param = updated_request
      ")
    ").

  "ENDIF.

ENDMETHOD.
```

测试结果，没有明细无法submit。
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/5ef8e885-f4d9-48d6-8c68-65b7fe3f9159" />



</details>
