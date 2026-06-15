# RAP小程序

我们做一个最小 RAP 程序：　`消耗品采购申请`

<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/7174f177-6bfb-41c1-b853-4e5a603bd76a" />
<img width="777" height="817" alt="image" src="https://github.com/user-attachments/assets/5384ffff-e88f-44a1-9369-2c2bfb25eb6a" />
<img width="777" height="832" alt="image" src="https://github.com/user-attachments/assets/4adfdc1d-36c3-4f8e-845b-e6be77339541" />
<br>
<br>
登录账号密码后，成功登录。 <br>
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/7dd453c1-6f3d-44c8-91e2-d69a5b8c29e6" />
<br>
<br>

[第 1 步：创建数据库表 ZTRAP_CONS_REQ](./ZTRAP_CONS_REQ.js)
<br>
<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/6d6c3b37-5f11-4296-9e8d-dcad6018fae9" />

[第 2 步：创建 Interface Root View Entity](./Interface_Root_View_Entity.js)
<br>
建立 `ZI_RAP_CONS_REQ` <br>
<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/1b7c4048-58b5-487f-8da0-11fbb2cf77c7" />

[第 3 步：创建 Behavior Definition](./ZI_RAP_CONS_REQ.js)
右键已经建立的 `ZI_RAP_CONS_REQ` 选择 Behavior Definition
<img width="220" height="27" alt="image" src="https://github.com/user-attachments/assets/437f499d-5c20-4e5a-8f7a-89b759df22f1" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/d381198d-895f-48d3-9eca-d77ffdad7631" />

[第 4 步：创建 ZC_RAP_CONS_REQ](./ZC_RAP_CONS_REQ.js)
<br>
ZI_RAP_CONS_REQ = 内部业务对象视图 <br>
ZC_RAP_CONS_REQ = 对外发布用的视图 <br>
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/8e281b16-1d60-427f-adb7-2e62170af703" />

第 5 步：创建 Projection Behavior <br>
目前已经有:

```text
ZI_RAP_CONS_REQ    Interface View
ZI_RAP_CONS_REQ    Behavior Definition
ZC_RAP_CONS_REQ    Projection View
```

现在要给 ZC_RAP_CONS_REQ 创建一个 Projection Behavior。<br>
作用是：决定对外发布时，允许使用哪些行为。<br>
比如底层 ZI_ 里有：

```text
create;
update;
delete;
```

但如果 ZC_ 的 Projection Behavior 里不写：

```text
use create;
use update;
use delete;
```

后面 OData / Fiori 侧就不能用这些操作。
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/c1c8c85f-a1cd-4f43-bc03-d32904c979ed" />
<img width="592" height="186" alt="image" src="https://github.com/user-attachments/assets/b4d4cb17-f9c9-4499-aed8-26e202792500" />



---


到这里，已经完成了 RAP 的核心骨架：

```text
ZTRAP_CONS_REQ
↓
ZI_RAP_CONS_REQ
↓
Behavior Definition
↓
ZC_RAP_CONS_REQ
↓
Projection Behavior
```

也就是把 ZC_RAP_CONS_REQ 暴露成服务。

第 6 步：创建 Service Definition<br>

这一步的作用是把 `Projection View` 暴露成一个服务模型。<br>
也就是把 `ZC_RAP_CONS_REQ` 公开成一个 OData Entity。 <br>
选择Service Definition <br>
<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/df08a3b0-e10b-4149-a9e9-3d1b55c28eb4" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/7ad84007-faef-4057-acd6-0456983e0fd5" />
<img width="651" height="90" alt="image" src="https://github.com/user-attachments/assets/4cdb0a9e-c515-4d09-8a21-60337569e303" />
代码含义:<br>
把 ZC_RAP_CONS_REQ 暴露出去。<br>
外部看到的 Entity 名叫 ConsumableRequest。<br>
后面 OData 服务里会出现类似:ConsumableRequest <br>


---



到目前为止的对象关系:


```text
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
ZSD_RAP_CONS_REQ
```

现在还没有真正发布 URL。<br>
Service Definition 只是定义 `我要暴露哪些 CDS View`。<br>
真正生成 OData 服务的是下一步：`Service Binding`。<br>




第 7 步：创建 Service Binding

这一步会选择：OData V4 - UI <br>
真正把刚才的 Service Definition 发布成 OData 服务。 <br>
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/8336e9b3-8172-4108-8164-df1825edb025" />
<img width="502" height="657" alt="image" src="https://github.com/user-attachments/assets/4bd0af6b-c476-4211-8140-914e2fd8d5c9" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/de3646ee-c2ec-40fe-a46e-8d4a73c6b79b" />
<img width="1920" height="1140" alt="image" src="https://github.com/user-attachments/assets/792c6e12-2556-4366-adad-86d3a2af8b51" />


