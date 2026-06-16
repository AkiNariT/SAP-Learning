<details>
   <summary><h1>RAP官方学习</h1></summary>

连接官方BTP练习环境。<br>
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/e2e07609-5afa-4a15-a7ce-b8d299ddc9e8" />

<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/39767bcd-e67b-4c7c-9a16-bd1dd2e3a3f1" />


<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/dd0343ff-0f27-4fa8-83c0-0cfd9557b9ee" />

输入下载的default_key<br>
<img width="870" height="617" alt="image" src="https://github.com/user-attachments/assets/33a86cfb-0050-493e-adf6-bfe8a1e08f42" />
<img width="870" height="697" alt="image" src="https://github.com/user-attachments/assets/5618713e-09c2-46ba-afe6-af9bc8a9336b" />

Eclipse 会打开浏览器登录页面。<br>
用你现在登录 BTP 的 SAP 账号登录。<br>
登录成功后，回到 Eclipse。点：Finish<br>
<img width="870" height="697" alt="image" src="https://github.com/user-attachments/assets/118ec6ee-aa47-41fb-9da4-82f50b69eed5" />
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/cd176496-7c1c-49d1-a6a9-25c37dd7163a" />

## 到此为止。Eclipse 已经成功连接到 SAP BTP ABAP Environment。

</details>

## 先创建开发包 Package
<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/29e87df1-6b58-4410-9d16-5161c8ba8c8c" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/00e1007d-b5ce-4adf-ae18-a6c0c3cb3620" />
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/2c282062-f04f-4911-a955-175229cc370d" />

## 第 1 步：创建数据库表
<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/5d004be8-a88a-4a48-b2f5-491a61b8a062" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/add2f9bd-56bb-47a5-bc30-731e2696936d" />
<br>

 [代码](./Database_Table-ZTRAP_CONS_REQ.cds)


## 第 2 步：Interface Root View Entity：ZI_RAP_CONS_REQ
<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/1226cc61-ee86-48a4-a4eb-2c0e8f2bd639" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/174f6c35-d718-4d7f-8afe-238596c8efac" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/265e8113-418a-4c6e-b55e-bf61979e3436" />

[代码](./ZI_RAP_CONS_REQ.js)


## 第 3 步：创建 Behavior Definition
选择ZI_RAP_CONS_REQ，右键选择New Behavior Definition <br>
<img width="366" height="27" alt="image" src="https://github.com/user-attachments/assets/50ccf76f-5dfd-429a-adcc-797acff747c7" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/09036c0b-f5fa-4508-a9ba-b34733d70ad4" />

[代码](./Behavior_Definition.js)

创建类 ZBP_I_RAP_CONS_REQ
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/657bc1c1-432f-4c56-878d-6fd7cbed7f7f" />



## 第 4 步：创建 Projection View
ZI_RAP_CONS_REQ = 内部业务对象视图<br>
ZC_RAP_CONS_REQ = 对外发布用视图<br>
后面 OData Service 不直接暴露 ZI_，而是暴露 ZC_。<br>

<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/584daf22-2de5-46eb-b237-0b57e98a0482" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/5be526cc-7220-44b2-8e5d-44d8d5ef2ea3" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/22ed30c5-06e7-4a61-80a6-a5e81a99db36" />

[代码](./创建ProjectionView.js)

## 第 5 步：创建 Projection Behavior
找到 `ZC_RAP_CONS_REQ`，然后右键`New Behavior Definition`。

<img width="632" height="210" alt="image" src="https://github.com/user-attachments/assets/18da2f72-c028-46d0-8649-5182ad693fe7" />
含义:<br>
底层有这些行为<br>
我对外也开放这些行为<br>


## 第 6 步：创建 ZUI_RAP_CONS_REQ
这一步不是业务逻辑，而是控制 Fiori Preview 画面显示：

```text
一览画面显示哪些字段
查询条件有哪些
明细页怎么分组
标题显示什么
```

<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/d1ba157d-773b-400a-a447-656b1e23bddc" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/c82b0931-a249-4e08-921e-0417102dbadc" />


[代码](./ZUI_RAP_CONS_REQ.js)


## 第 7 步：创建 Service Definition

把 ZC_RAP_CONS_REQ 暴露成服务。
<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/528034c2-707b-495f-8cfd-9c6920763355" />

<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/0895defc-3acf-4d64-a698-6f165cf699a9" />
<img width="732" height="137" alt="image" src="https://github.com/user-attachments/assets/6db9bf53-b4cc-4d08-abf0-3749f015c323" />

核心是：

```abap
expose ZC_RAP_CONS_REQ as ConsumableRequest;
```

含义:<br>
把 Projection View ZC_RAP_CONS_REQ 暴露出去<br>
外部服务里的 Entity 名叫 ConsumableRequest<br>
<br>
后面 OData V4 里你会看到： `ConsumableRequest`<br>

---

目前已经有的：
```TEXT
ZTRAP_CONS_REQ
↓
ZI_RAP_CONS_REQ
↓
ZI_RAP_CONS_REQ Behavior Definition
↓
ZC_RAP_CONS_REQ
↓
ZC_RAP_CONS_REQ Projection Behavior
↓
ZUI_RAP_CONS_REQ
↓
ZSD_RAP_CONS_REQ
```

## 追加Draft
对于 Fiori Elements OData V4 UI 来说，新增/编辑通常走 Draft 模式：<br>
```TEXT
Create
↓
先生成 Draft 数据
↓
用户编辑
↓
Activate
↓
写入正式表
```
如果你想在 Fiori Elements Preview 里看到：Create等按钮，就要给RAP BO加Draft<br>
修改ZI_RAP_CONS_REQ的Behavior。<br>

```TEXT
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

  field ( readonly, numbering : managed ) RequestID;

  field ( readonly )
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt;

  field ( mandatory )
    RequestDate,
    Requester,
    ItemText,
    Quantity,
    UnitCode,
    CostCenter,
    Status;

  mapping for ztrap_cons_req
  {
    RequestID            = request_id;
    RequestDate          = request_date;
    Requester            = requester;
    ItemText             = item_text;
    Quantity             = quantity;
    UnitCode             = unit;
    CostCenter           = cost_center;
    Status               = status;
    CreatedBy            = created_by;
    CreatedAt            = created_at;
    LastChangedBy        = last_changed_by;
    LastChangedAt        = last_changed_at;
    LocalLastChangedAt   = local_last_changed_at;
  }
}
```
此时还有error `draft table ztrap_cons_req_d`<br>
因为缺少draft table。<br>
鼠标放在`draft table ztrap_cons_req_d` 按Ctrl+1创建。<br>
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/e4c36799-de05-4208-aae2-e0dc3e0ffaeb" />

[Draft table代码](./ZTRAP_CONS_REQ_D.js)


## 第 8 步：创建 Service Binding

这一步是真正把服务发布成 OData V4 UI 服务，然后打开 Fiori Preview。
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/63e58c27-2fb8-4425-842f-29be16a1b8f5" />
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/792c0887-996f-46dd-abcb-907646710fe6" />
1.有效化 <br>
2.Publish <br>

<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/5120c05c-b321-44ab-af71-08b624c1c200" />
发布成功。<br>
点击Preview。<br>
可以看到：`Consumable Requests`<br>
然后可以测试：Create,Edit,Delete<br>
