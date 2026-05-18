# MM基本逻辑

<details>
  <summary><h2>🟩ERS流程</h2></summary>
ERS供应商自动结账<br>
发注登录 > 承认 > 发注变更 > 承认 > 入库 > ERS <br>
MM是标准的承认功能。

采购部门必须要有承认。<br>
购买发注扩张项目入力check

入库済み 可以数量可以修改
部分入库 可以数量
<br>
<img width="1072" height="747" alt="image" src="https://github.com/user-attachments/assets/925b2f51-84b3-447c-838f-e871b85c3a85" />
 </details>
 
<details>
  <summary><h2>🟩STO流程</h2></summary>
普通采购是：外部供应商 → 本公司工厂<br>
STO 是：本公司 A 工厂 / A 公司 → 本公司 B 工厂 / B 公司<br>
<br>
表面上它像采购,实际是从公司内部另一个工厂调货。<br>
<img width="1448" height="1086" alt="ChatGPT Image 2026年5月18日 13_43_54" src="https://github.com/user-attachments/assets/3aa2ea4c-1351-4330-b0be-c641a38487a1" />
<br>
<br>
<br>
<br>
讲解：<br>
两个工厂<br>
东京工厂：有库存<br>
大阪工厂：缺库存<br>
<br>
- 大阪工厂需要货，于是创建 STO。<br>
<br>
大阪工厂 = Receiving Plant / 受入プラント<br>
东京工厂 = Supplying Plant / 供給プラント<br>
<br>
于是出现流程：<br>
大阪工厂创建 STO<br>
↓<br>
东京工厂根据 STO 出货<br>
↓<br>
货物在运输中<br>
↓<br>
大阪工厂收货<br>
<br>
<br>
  
- ### STO 有三种常见类型
 - 类型一：同公司内 STO  
  > 因为还是同一个公司代码内部，通常不会产生对外销售收入或供应商应付。<br>

 - 类型二：跨公司 STO
  > 这时候就不只是库存移动了，还会出现：B 公司向 A 公司开内部請求。A 公司对 B 公司做内部采购。

 - [类型三：带 SD Delivery 的 STO](.../SD/README.md)（参照`流程`中的`STO在庫転送`）
  > 这种模式会用到 SD 的出荷功能。
  
 </details>
