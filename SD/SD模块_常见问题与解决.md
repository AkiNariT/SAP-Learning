```text
├─ 受注 Sales Order
│  ├─ 受注登録できない
│  │  ├─ 得意先マスタ確認
│  │  ├─ 品目マスタ確認
│  │  ├─ 販売エリア確認
│  │  └─ 与信ブロック確認
│  │
│  ├─ 価格が出ない
│  │  ├─ 条件レコード確認
│  │  ├─ Pricing Procedure確認
│  │  ├─ Condition Type確認
│  │  └─ Access Sequence確認
│  │
│  └─ 明細カテゴリ不一致
│     ├─ 受注タイプ確認
│     ├─ Item Category Group確認
│     └─ 明細カテゴリ決定確認
│
├─ 出荷 Delivery
│  ├─ 出荷伝票作成不可
│  │  ├─ Shipping Point確認
│  │  ├─ Delivery Block確認
│  │  └─ Copy Control確認
│  │
│  ├─ Pickingできない
│  │  ├─ 在庫確認 MMBE
│  │  ├─ Storage Location確認
│  │  └─ Batch確認
│  │
│  └─ PGIできない
│     ├─ Picking完了確認
│     ├─ 601移動タイプ確認
│     └─ 会計転記確認
│
├─ 請求 Billing
│  ├─ 請求伝票作成不可
│  │  ├─ Billing Block確認
│  │  ├─ PGI済確認
│  │  └─ VTFL確認
│  │
│  ├─ 請求金額不一致
│  │  ├─ Pricing Type確認
│  │  ├─ 税コード確認
│  │  └─ 条件レコード確認
│  │
│  └─ FI伝票未作成
│     ├─ VKOA確認
│     ├─ 勘定キー確認
│     └─ FIエラーログ確認
│
├─ 返品 Returns
│  ├─ 返品受注作成不可
│  │  ├─ RE返品伝票確認
│  │  ├─ 参照元伝票確認
│  │  └─ 返品理由確認
│  │
│  ├─ 返品入荷不可
│  │  ├─ LR返品納品確認
│  │  ├─ VL01N確認
│  │  └─ 651/653確認
│  │
│  └─ 返金できない
│     ├─ Credit Memo確認
│     ├─ 請求ブロック確認
│     └─ FI転記確認
│
└─ IF・開発 Interface / Add-on
   ├─ IDocエラー
   │  ├─ WE02/WE05確認
   │  └─ BD87再処理
   │
   ├─ OData/RESTエラー
   │  ├─ /IWFND/GW_CLIENT確認
   │  └─ Payload確認
   │
   └─ Add-on不具合
      ├─ Debug
      ├─ User Exit確認
      ├─ BAdI確認
      └─ Zテーブル確認
```
