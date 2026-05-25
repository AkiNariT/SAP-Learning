```text
SD模块 常见问题与解决方法 + T-code
│
├─ 1. 受注 Sales Order
│
│  ├─ 受注登録・変更・照会
│  │  ├─ VA01 创建受注
│  │  ├─ VA02 修改受注
│  │  └─ VA03 照会受注
│  │
│  ├─ 受注登録できない
│  │  ├─ 得意先マスタ確認
│  │  ├─ 品目マスタ確認
│  │  ├─ 販売エリア確認
│  │  ├─ 与信ブロック確認
│  │  └─ Incompletion Log確認
│  │
│  ├─ 価格が出ない
│  │  ├─ VK11 / VK12 / VK13
│  │  ├─ Pricing Procedure確認
│  │  ├─ Condition Type確認
│  │  ├─ Access Sequence確認
│  │  └─ 条件分析確認
│  │
│  ├─ 明細カテゴリ不一致
│  │  ├─ VOV4
│  │  ├─ 受注タイプ確認
│  │  ├─ Item Category Group確認
│  │  └─ Usage / Higher-level確認
│  │
│  └─ 納入日程行が出ない
│     ├─ VOV5
│     ├─ ATP確認
│     ├─ MRP確認
│     └─ 出荷関連設定確認
│
├─ 2. 出荷 Delivery
│
│  ├─ 出荷伝票
│  │  ├─ VL01N 创建出荷
│  │  ├─ VL02N 修改出荷
│  │  └─ VL03N 照会出荷
│  │
│  ├─ 出荷伝票作成不可
│  │  ├─ Shipping Point確認
│  │  ├─ Route確認
│  │  ├─ Delivery Block確認
│  │  ├─ VTLA確認
│  │  └─ 納入日程確認
│  │
│  ├─ Pickingできない
│  │  ├─ MMBE 在庫確認
│  │  ├─ Storage Location確認
│  │  ├─ Batch確認
│  │  ├─ WM/EWM確認
│  │  └─ Picking Status確認
│  │
│  ├─ PGI 出庫転記
│  │  ├─ VL02N
│  │  ├─ 601 Movement Type
│  │  ├─ 会計転記
│  │  ├─ 在庫減少
│  │  └─ Billing対象化
│  │
│  ├─ PGIできない
│  │  ├─ Picking未完了
│  │  ├─ 在庫不足
│  │  ├─ Batch不足
│  │  ├─ 会計エラー
│  │  └─ 出庫ブロック確認
│  │
│  └─ 出庫転記取消 Reverse PGI
│     ├─ VL09
│     ├─ 601 → 602
│     ├─ Billing取消必要確認
│     ├─ 会計期間確認
│     ├─ 在庫戻し確認
│     ├─ WM/EWM後続確認
│     └─ Delivery Status戻し
│
├─ 3. 請求 Billing
│
│  ├─ 請求伝票
│  │  ├─ VF01 创建請求
│  │  ├─ VF02 修改請求
│  │  └─ VF03 照会請求
│  │
│  ├─ 請求対象一覧
│  │  ├─ VF04
│  │  └─ VFX3 会計エラー確認
│  │
│  ├─ 請求伝票作成不可
│  │  ├─ Billing Block確認
│  │  ├─ PGI済確認
│  │  ├─ VTFL確認
│  │  ├─ Billing Type確認
│  │  └─ Copy Control確認
│  │
│  ├─ 請求金額不一致
│  │  ├─ Pricing Type確認
│  │  ├─ 税コード確認
│  │  ├─ 条件レコード確認
│  │  ├─ Manual Condition確認
│  │  └─ 端数処理確認
│  │
│  ├─ FI伝票未作成
│  │  ├─ VKOA確認
│  │  ├─ 勘定キー確認
│  │  ├─ 税勘定確認
│  │  └─ FIエラーログ確認
│  │
│  └─ 請求取消 Billing Cancellation
│     ├─ VF11
│     ├─ Cancel Billing Document
│     ├─ FI逆転記
│     ├─ 会計期間確認
│     ├─ 後続伝票確認
│     └─ 再請求対応
│
├─ 4. 返品 Returns
│
│  ├─ 返品受注
│  │  ├─ VA01 RE
│  │  ├─ VA02
│  │  └─ VA03
│  │
│  ├─ 返品受注作成不可
│  │  ├─ RE返品伝票確認
│  │  ├─ 参照元確認
│  │  ├─ 返品理由確認
│  │  ├─ 返品期間確認
│  │  └─ 数量超過確認
│  │
│  ├─ 返品入荷
│  │  ├─ VL01N LR
│  │  ├─ VL02N
│  │  ├─ 651 / 653
│  │  └─ 在庫戻し
│  │
│  ├─ 返品入荷できない
│  │  ├─ LR確認
│  │  ├─ Movement Type確認
│  │  ├─ 在庫Status確認
│  │  └─ QM確認
│  │
│  └─ 返金処理
│     ├─ VF01 Credit Memo
│     ├─ VF03
│     ├─ 価格コピー確認
│     ├─ Billing Block確認
│     └─ FI転記確認
│
├─ 5. マスタ / カスタマイズ
│
│  ├─ 得意先マスタ
│  │  ├─ XD03 / VD03
│  │  ├─ BP
│  │  ├─ Partner Function
│  │  ├─ 支払条件
│  │  └─ 税分類
│  │
│  ├─ 品目マスタ
│  │  ├─ MM03
│  │  ├─ Sales View
│  │  ├─ Plant View
│  │  ├─ Batch管理
│  │  └─ Item Category Group
│  │
│  └─ SD Customizing
│     ├─ SPRO
│     ├─ VOV8 受注タイプ
│     ├─ VOV7 明細カテゴリ
│     ├─ VOV6 納入日程行
│     ├─ VTAA
│     ├─ VTLA
│     ├─ VTFL
│     └─ VKOA
│
└─ 6. IF / 開発 Interface & Add-on

   ├─ IDoc
   │  ├─ WE02 / WE05
   │  ├─ WE19
   │  ├─ BD87
   │  └─ Status確認
   │
   ├─ OData / REST
   │  ├─ /IWFND/GW_CLIENT
   │  ├─ /IWFND/ERROR_LOG
   │  ├─ /IWBEP/ERROR_LOG
   │  ├─ Payload確認
   │  └─ Mapping確認
   │
   ├─ Debug / Dump
   │  ├─ ST22
   │  ├─ SM13
   │  ├─ SM37
   │  ├─ SLG1
   │  └─ SU53
   │
   └─ ABAP開発
      ├─ SE38
      ├─ SE37
      ├─ SE80
      ├─ SE11
      ├─ SE16N
      ├─ MV45AFZZ
      ├─ RV60AFZZ
      └─ USEREXIT / BAdI
```
