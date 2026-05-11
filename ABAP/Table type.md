## ABAP 代码演示

<details>
<summary>Hash table</summary>

### ABAP 示例

```abap

REPORT zsd_get_sales_order_demo.

DATA gt_vbak_hash TYPE HASHED TABLE OF ty_vbak
  WITH UNIQUE KEY vbeln.
```

</details>
