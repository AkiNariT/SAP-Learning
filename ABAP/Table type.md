## ABAP 代码演示

<details>
<summary>Hash table</summary>

### ABAP 示例
定义时：
```abap

DATA gt_vbak_hash TYPE HASHED TABLE OF ty_vbak
                  WITH UNIQUE KEY vbeln.
```
读取时:

```abap

READ TABLE gt_vbak_hash INTO DATA(ls_vbak)
                        WITH TABLE KEY vbeln = lv_vbeln.

IF sy-subrc = 0.
  "找到了受注
ENDIF.
```

</details>
