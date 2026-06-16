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

 [代码](./Database_Table-ZTRAP_CONS_REQ.cds) <br>
代码解释说明：
```CDS
@EndUserText.label : （表头说明）
@AbapCatalog.enhancement.category : （表示这个表是否允许增强）
@AbapCatalog.tableCategory : （表示这是透明表）
@AbapCatalog.deliveryClass : （这个是交付类。看下述deliveryClass值）
@AbapCatalog.dataMaintenance : （表示这个表能不能通过维护工具直接维护数据，看下述dataMaintenance值）

created_by : abp_creation_user; (RAP 可以自动写入当前用户。)
created_at : abp_creation_tstmpl; (创建时间戳。)

```
| deliveryClass值    | 大致含义                   |
| ---- | ---------------------- |
| `#A` | Application table，业务数据 |
| `#C` | Customizing table，配置数据 |
| `#L` | 临时数据                   |
| `#G` | 客户表，客户维护数据             |

| dataMaintenance值              | 含义      |
| -------------- | ------- |
| `#ALLOWED`     | 允许维护    |
| `#RESTRICTED`  | 受限制维护   |
| `#NOT_ALLOWED` | 不允许直接维护 |


## 第 2 步：Interface Root View Entity：ZI_RAP_CONS_REQ
<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/1226cc61-ee86-48a4-a4eb-2c0e8f2bd639" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/174f6c35-d718-4d7f-8afe-238596c8efac" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/265e8113-418a-4c6e-b55e-bf61979e3436" />

[代码](./ZI_RAP_CONS_REQ.cds)<br>
在 RAP 里，Data Definition 通常负责：
```text
1. 定义业务对象字段
2. 给字段起业务名
3. 定义字段语义
4. 定义关联关系
5. 给 Behavior Definition 提供基础
6. 给 OData / Fiori 暴露数据结构
```

```CDS
@EndUserText.label: （类说明）
@AccessControl.authorizationCheck: （权限，看下表）
@Metadata.ignorePropagatedAnnotations: （忽略从底层对象继承来的部分注解）

@Semantics.user.createdBy: true (CreatedBy 是创建用户字段)
@Semantics.systemDateTime.createdAt: true (CreatedAt 是创建时间戳)
@Semantics.user.lastChangedBy: true (最后修改者)
@Semantics.systemDateTime.lastChangedAt: true (最后修改时间)
@Semantics.systemDateTime.localInstanceLastChangedAt: true (本地最后修改时间)

```

| 场景                          | 推荐                 |
| --------------------------- | ------------------ |
| 学习 / Demo / 临时验证            | `#NOT_REQUIRED`    |
| 暴露真实业务数据，需要权限过滤             | `#CHECK`           |
| 明确禁止 DCL 控制                 | `#NOT_ALLOWED`     |
| 特殊底层 / privileged access 场景 | `#PRIVILEGED_ONLY` |




## 第 3 步：创建 Behavior Definition
选择ZI_RAP_CONS_REQ，右键选择New Behavior Definition <br>
<img width="366" height="27" alt="image" src="https://github.com/user-attachments/assets/50ccf76f-5dfd-429a-adcc-797acff747c7" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/09036c0b-f5fa-4508-a9ba-b34733d70ad4" />

[代码](./Behavior_Definition.cds)


创建类 ZBP_I_RAP_CONS_REQ
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/657bc1c1-432f-4c56-878d-6fd7cbed7f7f" />

[代码](./ZBP_I_RAP_CONS_REQ.js)

## 第 4 步：创建 Projection View
ZI_RAP_CONS_REQ = 内部业务对象视图<br>
ZC_RAP_CONS_REQ = 对外发布用视图<br>
后面 OData Service 不直接暴露 ZI_，而是暴露 ZC_。<br>

<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/584daf22-2de5-46eb-b237-0b57e98a0482" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/5be526cc-7220-44b2-8e5d-44d8d5ef2ea3" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/22ed30c5-06e7-4a61-80a6-a5e81a99db36" />

[代码](./创建ProjectionView.cds)

## 第 5 步：创建 Projection Behavior
找到 `ZC_RAP_CONS_REQ`，然后右键`New Behavior Definition`。

<img width="636" height="326" alt="image" src="https://github.com/user-attachments/assets/68e1f59e-bc00-4042-94f0-0ad356060895" />

<br>
含义:<br>
底层有这些行为<br>
我对外也开放这些行为<br>

代码理解:<br>
Projection Behavior 只是在外层说：
```text
底层有 create，我对外也开放 create
底层有 update，我对外也开放 update
底层有 draft，我对外也开放 draft

```

```CDS
strict ( 2 );  (让 RAP 编译器更严格地检查)
use draft;    (很关键，Projection View 对外开放 Draft 能力。Draft暴露Create等按钮)

Interface Behavior 里写：with draft;
Projection Behavior 里写：use draft;
上述两个必须配套。
ZI Behavior: with draft
↓
ZC Behavior: use draft
↓
OData V4 UI Service
↓
Fiori Elements 显示 Create / Edit

define behavior for ZC_RAP_CONS_REQ alias ConsReq
给 ZC_RAP_CONS_REQ 这个 Projection View 定义行为。alias ConsReq 是给这个 Entity 起一个别名。
以后在 Behavior 里可以用：ConsReq

use create;  (对外开放新增功能。)


use action Edit;  (把正式数据切换成 Draft 编辑状态)
use action Activate;  (把 Draft 数据激活成正式数据)
use action Discard;  (放弃 Draft 修改)
use action Resume;  (继续编辑已有 Draft)
use action Prepare;  (Draft 保存/激活前的准备动作)
上述不是自定义的业务按钮，而是 RAP Draft 标准动作。

```
Interface 和 Projection里的对应<br>
ZI 层：定义能力<br>
ZC 层：开放能力<br>
Projection Behavior 一般不写真正业务逻辑。<br>
| Interface Behavior                | Projection Behavior    |
| --------------------------------- | ---------------------- |
| `with draft;`                     | `use draft;`           |
| `create;`                         | `use create;`          |
| `update;`                         | `use update;`          |
| `delete;`                         | `use delete;`          |
| `draft action Edit;`              | `use action Edit;`     |
| `draft action Activate;`          | `use action Activate;` |
| `draft action Discard;`           | `use action Discard;`  |
| `draft action Resume;`            | `use action Resume;`   |
| `draft determine action Prepare;` | `use action Prepare;`  |



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


[代码](./ZUI_RAP_CONS_REQ.cds)

代码理解：<br>
ZC_RAP_CONS_REQ = 对外数据模型<br>
ZUI_RAP_CONS_REQ = 给这个模型追加 UI 注解<br>
Fiori Elements = 根据这些 UI 注解自动生成画面<br>

```cds
@UI: {
  headerInfo: {
    typeName: 'Consumable Request',
    typeNamePlural: 'Consumable Requests',
    title: {
      type: #STANDARD,
      value: 'ItemText'
    },
    description: {
      value: 'Status'
    }
  }
}
这个控制 Object Page 顶部标题区域。

typeName: 'Consumable Request'
比如打开一条记录时，系统知道这个对象叫：Consumable Request

typeNamePlural: 'Consumable Requests'
复数名称。List Report 标题里可能显示：Consumable Requests


@UI.facet
这个控制 Object Page 明细页的区块分组。
例如：
@UI.facet: [
  {
    id: 'General',
    purpose: #STANDARD,
    type: #IDENTIFICATION_REFERENCE,
    label: 'General Information',
    position: 10
  }
]
Object Page 里的一个 Section / 区块

@UI.lineItem
这个控制 List Report 一览画面显示字段。
也就是最开始的表格列表里显示哪些列。

@UI.identification
这个控制 Object Page 明细页显示字段。
它一般和 @UI.facet 配合使用。

一个字段可以有多个 UI 注解
举例：
@UI.lineItem:       [{ position: 30, label: 'Requester' }]
@UI.identification: [{ position: 30, label: 'Requester' }]
@UI.selectionField: [{ position: 20 }]
Requester;
Requester 既显示在一览表
也显示在明细页
也作为查询条件



```

| 注解                   | 控制哪里    |
| -------------------- | ------- |
| `@UI.lineItem`       | 一览表列    |
| `@UI.identification` | 明细页字段   |
| `@UI.selectionField` | 查询条件    |
| `@UI.facet`          | 明细页区块   |
| `@UI.headerInfo`     | 明细页标题区域 |



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
