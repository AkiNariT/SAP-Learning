```text
SD模块 常见问题与解决方法 + T-code
│
├─ 受注 Sales Order
│  ├─ 受注登録・照会
│  │  ├─ VA01 创建受注
│  │  ├─ VA02 修改受注
│  │  └─ VA03 照会受注
│  ├─ 価格確認
│  │  ├─ VK11 创建条件レコード
│  │  ├─ VK12 修改条件レコード
│  │  ├─ VK13 照会条件レコード
│  │  └─ VA03 → 条件分析
│  └─ 得意先・品目確認
│     ├─ XD03 / VD03 得意先マスタ照会
│     ├─ BP Business Partner
│     └─ MM03 品目マスタ照会
│
├─ 出荷 Delivery
│  ├─ 出荷伝票
│  │  ├─ VL01N 创建出荷/返品納品
│  │  ├─ VL02N 修改出荷伝票
│  │  └─ VL03N 照会出荷伝票
│  ├─ 出荷対象確認
│  │  ├─ VL10A 受注別出荷対象一覧
│  │  └─ VL10C 品目別出荷対象一覧
│  └─ 在庫確認
│     ├─ MMBE 在庫一覧
│     ├─ MD04 在庫/所要量一覧
│     └─ MB51 品目伝票一覧
│
├─ 請求 Billing
│  ├─ 請求伝票
│  │  ├─ VF01 创建請求
│  │  ├─ VF02 修改請求
│  │  └─ VF03 照会請求
│  ├─ 請求対象
│  │  ├─ VF04 請求処理一覧
│  │  └─ VFX3 請求会計エラー確認
│  └─ 会計確認
│     ├─ FB03 会計伝票照会
│     └─ FBL5N 得意先明細照会
│
├─ 返品 Returns
│  ├─ 返品受注
│  │  ├─ VA01 创建返品受注 RE
│  │  ├─ VA02 修改返品受注
│  │  └─ VA03 照会返品受注
│  ├─ 返品入荷
│  │  ├─ VL01N 创建返品納品 LR
│  │  ├─ VL02N 返品入荷/転記
│  │  └─ VL03N 照会返品納品
│  └─ 返金
│     ├─ VF01 创建Credit Memo
│     ├─ VF03 照会Credit Memo
│     └─ FB03 照会会計伝票
│
├─ 共通排查 Common
│  ├─ 権限
│  │  ├─ SU53 権限エラー確認
│  │  └─ PFCG ロール確認
│  ├─ ログ
│  │  ├─ SLG1 Application Log
│  │  ├─ SM13 Update Error
│  │  ├─ ST22 Dump確認
│  │  └─ SM37 Job確認
│  └─ カスタマイズ確認
│     ├─ SPRO IMG設定
│     ├─ VOV8 受注伝票タイプ
│     ├─ VOV7 明細カテゴリ
│     ├─ VOV6 納入日程行カテゴリ
│     ├─ VTAA 受注→受注 Copy Control
│     ├─ VTLA 受注→出荷 Copy Control
│     └─ VTFL 出荷→請求 Copy Control
│
└─ IF・開発 Interface / Add-on
   ├─ IDoc
   │  ├─ WE02 / WE05 IDoc確認
   │  ├─ WE19 IDocテスト
   │  └─ BD87 IDoc再処理
   ├─ OData / REST
   │  ├─ /IWFND/GW_CLIENT Gateway Client
   │  ├─ /IWFND/ERROR_LOG Gateway Error Log
   │  └─ /IWBEP/ERROR_LOG Backend Error Log
   └─ Debug / 開発
      ├─ SE38 Program
      ├─ SE37 Function Module
      ├─ SE80 Object Navigator
      ├─ SE11 Table / Structure
      ├─ SE16N Table確認
      └─ SM30 Zテーブルメンテ
```
