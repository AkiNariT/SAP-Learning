## ABAP 代码演示

<details>
<summary>Hash table</summary>

擅长：用唯一 key 快速找一行。
不擅长：按顺序、按范围、按一个 key 找多行。


### ABAP 示例

定义时：
```abap

DATA gt_vbak_hash TYPE HASHED TABLE OF ty_vbak
                  WITH UNIQUE KEY vbeln.
```
```abap

DATA gt_vbak_hash TYPE STANDARD TABLE OF ty_vbak
                  WITH EMPTY KEY
                  WITH UNIQUE HASHED KEY key_vbeln COMPONENTS vbeln
                                                              posnr.
```
第二个是给这个 STANDARD TABLE 追加一个 HASHED KEY。<br>
这个 key 的名字叫 key_vbeln。<br>
这个 key 用 vbeln posnr 字段组成。<br>
所以这个名为 key_vbeln 的 key 可以有多个项目组成。<br>



读取时:

```abap

READ TABLE gt_vbak_hash INTO DATA(ls_vbak)
                        WITH TABLE KEY vbeln = lv_vbeln.

IF sy-subrc = 0.
ENDIF.
```
```abap

READ TABLE gt_vbak_hash INTO DATA(ls_vbap)
                        WITH TABLE KEY key_vbeln COMPONENTS
                        vbeln = lv_vbeln
                        posnr = lv_posnr.

IF sy-subrc = 0.
ENDIF.
```


</details>
