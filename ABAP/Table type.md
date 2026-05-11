## ABAP 代码演示

<details>
<summary>Hash table</summary>

### ABAP 示例
定义时：
```abap

DATA gt_vbak_hash TYPE HASHED TABLE OF ty_vbak
                  WITH UNIQUE KEY vbeln.
```
```abap

DATA gt_vbak_hash TYPE STANDARD TABLE OF ty_vbak
                  WITH EMPTY KEY vbeln
                  WITH UNIQUE HASHED KEY key_vbeln COMPONENTS vbeln.
```
给这个 STANDARD TABLE 追加一个 HASHED KEY
这个 key 的名字叫 key_vbeln
这个 key 用 vbeln 字段组成

读取时:

```abap

READ TABLE gt_vbak_hash INTO DATA(ls_vbak)
                        WITH TABLE KEY vbeln = lv_vbeln.

IF sy-subrc = 0.
  "找到了受注
ENDIF.
```

</details>
