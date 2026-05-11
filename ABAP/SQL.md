## ABAP 代码演示

<details>
<summary>SD 受注数据取得 Demo：VBAK + VBAP</summary>

### 业务说明

这个 Demo 用来取得 SD 受注ヘッダ和受注明細数据。

相关表：

| 表 | 说明 |
|---|---|
| VBAK | 受注ヘッダ |
| VBAP | 受注明細 |

### ABAP 示例

```abap
REPORT zsd_get_sales_order_demo.

SELECT
  a~vbeln,
  a~auart,
  a~kunnr,
  a~erdat,
  b~posnr,
  b~matnr,
  b~kwmeng,
  b~netwr
  FROM vbak AS a
  INNER JOIN vbap AS b
    ON a~vbeln = b~vbeln
  INTO TABLE @DATA(gt_sales_order)
  UP TO 100 ROWS.

cl_demo_output=>display( gt_sales_order ).
```

</details>
