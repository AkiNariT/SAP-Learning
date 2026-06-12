# SAP-SD
<details>
 <summary><h2>简单的t-cd相关记录</h2></summary>
🟦受注相关<br>
va01<br>
<br>  
🟦出荷相关<br>
VL01N<br>
VL09 出庫転記取消<br>  
VL10A 出荷预定一览<br>  
<br>  
🟦请求相关<br>  
VF01<br>  
VF11 請求取消<br>  
<br>  

🟥价格条件<br>
VK11 価格条件登録<br>
VK13 価格条件照会<br>
<br>

🟥在庫<br>
MMBE 在庫照会<br>
MB52 在庫一覧表<br>
<br>
🟥ロット<br>
MSC1N ロット登録<br>
MB56 ロット使用先一覧<br>
<br>
🟩与MM关联<br>
ME51N 購買依頼登録<br>
ME21N 購買発注登録<br>
MIGO 入出庫処理<br>
</details>

<details>
<summary><h2>流程</h2></summary> 
 <details>
 <summary><h4>🟩标准受注</h4></summary>
<p>标准受注：受注 VA01 → 出荷 VL01N/VL02N → 出庫転記 PGI → 請求 VF01</p>
<img width="1062" height="748" alt="image" src="https://github.com/user-attachments/assets/f7d80917-2229-4abf-93c1-1511871bbe9c" />
<br>
 </details>

 <details>
 <summary><h4>🟩直送</h4></summary>
<p>`明細カテゴリー`控制</p>
<p>直送：受注 VA01 → 購買依頼 PR 自动生成 → 購買発注 ME21N → 仕入先直接出荷 → 仕入先請求 MIRO → 顧客請求 VF01</p>   
<img width="1065" height="751" alt="image" src="https://github.com/user-attachments/assets/15f3e70a-d964-4469-834f-52ae52c83380" />
<br>
 </details>

 <details>
 <summary><h4>🟩返品受注</h4></summary>
<p>返品受注：返品受注 VA01 → 返品入荷 VL01N/VL02N → 入庫転記 → クレジットメモ VF01  </p>
<img width="1063" height="748" alt="image" src="https://github.com/user-attachments/assets/2609323c-36a6-4c05-9c3c-53cd77d02f5f" />
<br>
 </details>

 <details> 
  <summary><h4>🟩無償出荷</h4></summary>
<p>無償出荷：無償受注 VA01 → 出荷 VL01N/VL02N → 出庫転記 PGI → 通常請求なし / 0円請求</p>
<br><img width="1060" height="742" alt="image" src="https://github.com/user-attachments/assets/a1f4a553-acd3-4edd-976e-02b0032ff3bf" />
 </details>

 <details> 
  <summary><h4>🟥外加工直送</h4></summary>
客户下单后，公司不自己加工/出库，而是让外注先加工并直接发给客户。<br>
货物流：外注先 → 客户<br>
单据流：客户受注 → 外注采购 → 外注收货/确认 → 客户請求 + 供应商发票<br>
<img width="1536" height="1024" alt="ChatGPT Image 2026年5月18日 11_13_27" src="https://github.com/user-attachments/assets/d6dd69c6-53ce-468b-a750-b4e42c2692ba" /><br>

**外加工有三种形态**<br>
<br>
形态 A：自社支給型外加工直送<br>
本公司材料 → 发给外注先 → 外注先加工 → 外注先直接发客户<br>
特点：<br>
材料是本公司的<br>
有支給品<br>
有外注先特殊库存,可能用 541 / 543<br>
<br>

形态 B：第三方供应商把材料送外注先<br>
客户下单→ 本公司下采购单给材料供应商 → 材料供应商直接送到外注先 → 外注先加工 → 外注先直接发客户<br>
<br>

形态 C：完全外注 / 完全外部采购 / 纯直送<br>
此时状态更像纯粹的直送<br>
客户下单→ 本公司向外注先/供应商下单 → 外注先自己准备材料、自己加工 → 外注先直接发给客户 → 本公司向客户請求 → 外注先向本公司請求<br>

<br>
三种形态对比<br>
<img width="1425" height="948" alt="image" src="https://github.com/user-attachments/assets/7eea0421-c4aa-47b5-b7e6-5279cdcafdc9" />
 </details>

 <details>
 <summary><h4>🟥STO在庫転送</h4></summary>
  日本项目通常是以下几种说法：<br>
> 在庫転送オーダー<br>
> 在庫移送発注<br>
> プラント間在庫転送<br>
> 会社間在庫転送<br>
<br>
STO 虽然是 MM 发起，但发货方需要执行类似销售出货的动作。详细STO参照MM模块（后续补充MM流程链接）。

场景：A 工厂库存不足，从 B 工厂调货。<br>
本质是：用“采购订单”的形式，把库存从一个工厂 / 公司转到另一个工厂 / 公司。<br>
<img width="1077" height="808" alt="image" src="https://github.com/user-attachments/assets/b674075f-bc0c-41f5-be21-2f019969a46e" />

<br>
 </details>
</details>


| 业务对象      | Header 表                   | Item 表 | 说明           |
| --------- | -------------------------- | ------ | ------------ |
| 销售订单 / 受注 | `VBAK`                     | `VBAP` | SD 最核心       |
| 交货 / 出荷   | `LIKP`                     | `LIPS` | 出荷、PGI       |
| 开票 / 請求   | `VBRK`                     | `VBRP` | Billing      |
| 凭证流       | `VBFA`                     | -      | 看前后凭证关系      |
| Partner   | `VBPA`                     | -      | 受注先、出荷先、請求先等 |
| 日程行       | -                          | `VBEP` | 納期、确认数量      |
| 条件金额      | `PRCD_ELEMENTS` / `KONV`   | -      | 价格条件         |
| 客户主数据     | `KNA1` / `KNB1` / `KNVV`   | -      | 得意先          |
| 品目主数据     | `MARA` / `MARC` / `MVKE`   | -      | 品目           |
| 会计凭证      | `BKPF` / `BSEG` / `ACDOCA` | -      | FI 联动        |



<details>
 <summary><h2>常见问题</h2></summary> 

出荷常见问题：

🟣出荷ポイント:<br> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;出荷点决定这张货从哪个出货点处理。<br>

🟣ロット问题:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;品目ロット未入力<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ロット库存不足<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ロット过期<br>
 
</details>


<h2>ABAP的相关方向</h2>  
<p>VA01/VA02扩张：保存時チェック</p>
<p>常见入口:</p>
<p>MV45AFZZ</p>
<p>⭐USEREXIT_SAVE_DOCUMENT_PREPARE</p>
<p>USEREXIT_SAVE_DOCUMENT</p>
<p>===========================</p>
<p>項目制御</p>
<p>VA01 创建时可以输入，VA02 修改时不能改,特定受注类型下字段必输。</p>
<p>常见入口:</p>
<p>MV45AFZZ</p>
<p>USEREXIT_FIELD_MODIFICATION</p>
