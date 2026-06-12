# MM基本逻辑
ME51N 采购申请 <br>
  ↓<br>
ME21N 采购订单<br>
  ↓<br>
MIGO 入库<br>
  ↓<br>
MIRO 发票校验<br>
  ↓<br>
FI 会计凭证 / 付款<br>
也就是常说的:P2P/PTP  (購買から支払まで) <br>

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

 - [类型三：带 SD Delivery 的 STO](../SD/Readme.md)（参照`流程`中的`STO在庫転送`）
  > 这种模式会用到 SD 的出荷功能。
  
 </details>

<details>
  <summary><h2>🟩消耗品采购</h2></summary>
<img width="1055" height="1491" alt="ChatGPT Image 2026年6月12日 18_03_57" src="https://github.com/user-attachments/assets/61fc6836-c1cf-406b-9a73-b22f06b9c8fe" />


 </details>




---

migo入库的移动type:<br>
561 初期入库<br>
101 采购退货<br>
122 采购退货(仕入先返品/退给供应商)<br>
301 工厂间转储<br>
311 库存地点间转储<br>
641 STO 出库<br>
101 STO 入库<br>

---

## T-CD

| 用途            | T-code          |
| ------------- | --------------- |
| 创建 Batch 主数据  | `MSC1N`         |
| 入库创建/指定 Batch | `MIGO`          |
| 查看库存          | `MMBE` / `MB52` |
| Batch Cockpit | `BMBC`          |

| 表                 | 说明                   |
| ----------------- | -------------------- |
| `MCH1`            | Batch 主数据，跨工厂/物料层级相关 |
| `MCHA`            | Batch 主数据，工厂层级相关     |
| `MCHB`            | Batch 库存             |
| `MATDOC` / `MSEG` | 物料凭证中的 Batch         |

| 表      | 内容            |
| ------ | ------------- |
| `EKKO` | PO Header     |
| `EKPO` | PO Item       |
| `EKET` | Schedule Line |
| `EKBE` | PO History    |

