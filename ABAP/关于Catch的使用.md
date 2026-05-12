<details>
<summary><h2>怎么判断该不该用 TRY...CATCH</h2></summary>
<img width="980" height="507" alt="image" src="https://github.com/user-attachments/assets/0bba260b-e4df-4c15-856a-f91b26c79281" />

</details>
  
<details>
<summary><h2>程序Dump了</h2></summary>

如果程序 dump 了，ST22 里经常能看到异常类，比如
  ```abap  
CX_SY_ITAB_LINE_NOT_FOUND
CX_SY_ZERODIVIDE
CX_SY_CONVERSION_NO_NUMBER
CX_SY_OPEN_SQL_DB

  ```
下次就可以针对性 catch。<pr/>

比如 table expression 找不到行：
  ```abap  
DATA(ls_vbak) = gt_vbak[ vbeln = lv_vbeln ].
  ```
如果找不到，会抛：
  ```abap  
CX_SY_ITAB_LINE_NOT_FOUND
  ```

可以这样写：
  ```abap  
TRY.

    DATA(ls_vbak) = gt_vbak[ vbeln = lv_vbeln ].

  CATCH cx_sy_itab_line_not_found.
    MESSAGE '対象データが見つかりません。' TYPE 'S' DISPLAY LIKE 'E'.

ENDTRY.
  ```
不过这种场景我更推荐不用 TRY...CATCH，而是先判断：
  ```abap
IF line_exists( gt_vbak[ vbeln = lv_vbeln ] ).
*line_exists( ) 是 ABAP 新语法里用来判断：内表里有没有符合条件的那一行。
  DATA(ls_vbak) = gt_vbak[ vbeln = lv_vbeln ].
ENDIF.
  ```
</details>
