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


<h2>最基本的流程</h2>  
<p>标准受注：受注 VA01 → 出荷 VL01N/VL02N → 出庫転記 PGI → 請求 VF01</p>
<p>返品受注：返品受注 VA01 → 返品入荷 VL01N/VL02N → 入庫転記 → クレジットメモ VF01  </p>
<p>直送：受注 VA01 → 購買依頼 PR 自动生成 → 購買発注 ME21N → 仕入先直接出荷 → 仕入先請求 MIRO → 顧客請求 VF01</p>   
<p>無償出荷：無償受注 VA01 → 出荷 VL01N/VL02N → 出庫転記 PGI → 通常請求なし / 0円請求</p>

<h2>出荷常见问题</h2>  
<p>🟣出荷ポイント:</p>
<p>出荷点决定这张货从哪个出货点处理。</p>

<p>🟣ロット问题:</p>
<p>ロット未入力</p>
<p>ロット库存不足</p>
<p>ロット过期</p>

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
