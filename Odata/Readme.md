# 🔶OData <br>

### 简单理解：
ABAP / CDS View<br>
↓<br>
OData Service<br>
↓<br>
URL<br>
↓<br>
UI5 / Fiori / 外部系统调用<br>
<br>

### 最先要学会：CDS 直接发布 OData
   ```abap 
@OData.publish: true
define view ZCDS_SO_HEAD
  as select from vbak
{
  key vbeln,auart,vkorg
}
   ```
`@OData.publish: true` 的作用就是让 CDS 生成 `OData Service`<br>
但生成后还需要去 `/IWFND/MAINT_SERVICE` 手动激活服务。<br>

- 注册 OData Service
  - T-code：`/IWFND/MAINT_SERVICE`
- GUI 里测试 OData
  - T-code：`/IWFND/GW_CLIENT`
- Maintenance view
- Help view
