# G/L勘定 / 勘定科目

这一步很关键。<br>
MIGO 初期在庫投入,VL02N 出庫転記,VF01 請求。<br>
上记的三个都会使用到G/L勘定。<br>

暂时跑SD，以下几个就够使用。<br>

| G/L 勘定   | 日语用途    | 中文说明      | 科目类型    |項目ステータス Grp 选择原则      |勘定グループ      |
| -------- | ------- | --------- | ------- | ------- | ------- |
| `140000` | 売掛金統制勘定 | 应收账款统驭科目  | X 貸借対照表勘定 | 統制勘定 / Reconciliation / 得意先 相关组 | ZBS 貸借対照表勘定 |
| `300000` | 在庫勘定    | 库存科目      | X 貸借対照表勘定 | 一般 B/S / 在庫 / 品目 相关组 | ZBS 貸借対照表勘定 |
| `400000` | 売上勘定    | 销售收入      | P 損益計算書勘定 | 収益 / 売上 / Revenue 相关组 | ZPL 損益計算書勘定 |
| `500000` | 売上原価勘定  | 销售成本      | P 損益計算書勘定 | 費用 / 原価 / Cost 相关组 | ZPL 損益計算書勘定 |
| `599000` | 在庫調整勘定  | 初期库存/库存调整 | P 損益計算書勘定 | 費用 / 調整 / 一般 P/L 相关组 | ZPL 損益計算書勘定 |
| `900000` | 繰越利益剰余金 | 损益结转科目    | X 貸借対照表勘定 | 一般 B/S 相关组 | ZSP 特殊・繰越勘定 |

<br>
这是成功登录后的结果。<br>
<img width="726" height="876" alt="image" src="https://github.com/user-attachments/assets/76c887ef-614f-45f4-a8d4-8f149bf2384a" />
<br>
<br>
T-cd: FS00<br>
选择新建<br>

## 140000

<img width="1918" height="1133" alt="image" src="https://github.com/user-attachments/assets/eaf74955-6a88-44e8-8666-7ae26eaef6d2" />


<img width="1918" height="830" alt="image" src="https://github.com/user-attachments/assets/ffbb411b-7a8b-4feb-819c-b85b0ba8087a" />
<img width="1918" height="1066" alt="image" src="https://github.com/user-attachments/assets/4f3fc372-98d6-4828-bd52-ab9b32499442" />
<br>
140000 是売掛金統制勘定 最好选统制勘定相关组<br>
<img width="1918" height="1132" alt="image" src="https://github.com/user-attachments/assets/6bc6d2f1-2b31-45dc-ae47-c94e3a82c45a" />

---

## 300000
<img width="1918" height="863" alt="image" src="https://github.com/user-attachments/assets/7bcb4cc2-412a-4ea4-abc7-3002240748eb" />
因为 140000 売掛金統制勘定 是给 得意先 用的。所以才维护，其他暂时不用维护。
<img width="1918" height="1075" alt="image" src="https://github.com/user-attachments/assets/1e986081-3531-4d26-9380-7cd102962fe1" />
<img width="1918" height="1136" alt="image" src="https://github.com/user-attachments/assets/f6949e52-8ac2-4efe-864f-06f468681b15" />

---

## 400000
<img width="1918" height="811" alt="image" src="https://github.com/user-attachments/assets/f70e5dcf-3feb-4341-834a-9abe5823943b" />
<img width="1918" height="1132" alt="image" src="https://github.com/user-attachments/assets/bfa368b0-316e-4c37-b69d-91b45016e0bc" />
<img width="1918" height="1131" alt="image" src="https://github.com/user-attachments/assets/a6c15935-b4d0-4fa4-942f-a68b35ad4f8c" />

---

## 500000
<img width="1918" height="841" alt="image" src="https://github.com/user-attachments/assets/30aa5655-1f34-4fda-a2a6-b057dd694b5c" />
<img width="1918" height="1070" alt="image" src="https://github.com/user-attachments/assets/7e586309-9665-44f8-bebf-9d7d85c80551" />
<img width="1918" height="1133" alt="image" src="https://github.com/user-attachments/assets/e3be0276-f407-4a21-b41a-e7f9b2f0caf2" />

---

## 599000
<img width="1918" height="843" alt="image" src="https://github.com/user-attachments/assets/45b6df30-0197-4775-9735-464402189255" />
<img width="1918" height="1072" alt="image" src="https://github.com/user-attachments/assets/d2459e4f-474d-4428-888e-ce7be4eaaf8a" />
<img width="1918" height="1072" alt="image" src="https://github.com/user-attachments/assets/ee48ba63-4270-42a0-ab49-a571c6270c75" />

---

## 900000
<img width="1918" height="1060" alt="image" src="https://github.com/user-attachments/assets/40fdfdc9-44bc-49d1-94eb-42dd9208fd6b" />
<img width="1918" height="1067" alt="image" src="https://github.com/user-attachments/assets/a177cccf-3673-42d5-9ebe-ff9babcd5862" />
<img width="1918" height="1066" alt="image" src="https://github.com/user-attachments/assets/3a3bd028-ca3d-41e4-9319-3587214073f8" />

