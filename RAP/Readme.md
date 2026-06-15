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
<img width="640" height="617" alt="image" src="https://github.com/user-attachments/assets/1b7c4048-58b5-487f-8da0-11fbb2cf77c7" />

[第 3 步：创建 Behavior Definition](./ZI_RAP_CONS_REQ.js)
右键已经建立的 `ZI_RAP_CONS_REQ` 选择 Behavior Definition
<img width="220" height="27" alt="image" src="https://github.com/user-attachments/assets/437f499d-5c20-4e5a-8f7a-89b759df22f1" />
<img width="837" height="762" alt="image" src="https://github.com/user-attachments/assets/d381198d-895f-48d3-9eca-d77ffdad7631" />

[第 4 步：创建 ZC_RAP_CONS_REQ]
ZI_RAP_CONS_REQ = 内部业务对象视图 <br>
ZC_RAP_CONS_REQ = 对外发布用的视图 <br>
