### Joule 作为开发助手的应用。
Joule的时使用。
[https://github.com/SAP-samples/teched2024-AD181](https://github.com/SAP-samples/abap-platform-rap120)


# AI的本质，概率论。

1. 简单的回答BOT。
2. 调用LLM API做应用。<br>
  1> 掌握Python / JavaScript / TypeScript<br>
   2> REST API,JSON
3. 企业知识库开发
4. Tool Calling / Function Calling
5. Agent 开发
再往上的涉及不到。

根据目前已经落地的joule来看似乎是更强大的操作手册。


# Joule是SAP的AI助手
嵌入到SAP Cloud产品中的辅助产品。<br>
以往操作需要熟悉流程。<br>
有了辅助，会返回给相关流程，通过对话做筛选。即便不是成手顾问，也能解决问题。


## 目前落地的成果:<br>
Abeam.<br>
ABeam 为 SAP Joule for Consultants 做了 19 个 use case，用于 SAP 项目实施、方法论、Best Practice、Custom Code、开发建议等场景，并报告了 77% operational efficiency improvement。


## 现有的Joule项目，都在做什么。<br>
第一类。<br>
项目目标：让客户公司的 SAP 环境可以使用 Joule。<br>
不是AI发开，而是AI接入。

1. 首先确认客户有哪些SAP产品，BTP，S4HANA等等需要确认。
2. 然后确认Joule的适用范围。
3. 配合 Basis / BTP 担当做环境确认。
4. 配置用户、Role、权限。
5. 测试 Joule 是否能在目标应用里使用。
6. 整理测试结果和限制事项。
7. 写导入手顺书、测试。

---

第二类。<br>
项目目标：在 Teams / Microsoft 365 Copilot 里可以通过 @Joule 问 SAP 相关问题。

1. SAP Cloud Identity Services / IAS 设置确认
2. Microsoft Entra ID 和 SAP IAS 的信赖关系确认
3. 用户 mapping 确认
4. BTP Subaccount / Joule 相关配置确认
5. Teams / Copilot 里启用 Joule Agent
6. 测试 @Joule 查询 SAP 数据
7. 处理认证错误、权限错误、用户映射错误

---
   
第三类。<br>
项目目标：找出 Joule 在客户业务里能不能真的用。

1. Use Case 整理
2. 数据源确认
3. 业务规则整理
4. 测试问题准备
5. PoC 报告

---

第四类。<br>
Joule for Consultants 导入 / SAP项目交付效率化<br>
给 SAP 项目成员用。<br>
ABeam 的案例就是这种：用 Joule for Consultants 来支持 SAP 项目实施、开发建议、custom code 理解、方法论和 Best Practice 查询。SAP 官方案例还提到，该方案基于超过 200,000 页 SAP 产品文档和学习资源的结构化知识，以及超过 2TB 的 SAP curated knowledge content。
1. 整理项目成员常见问题
2. 整理 SAP 项目方法论查询场景
3. 整理 ABAP / Custom Code 解析场景
4. 验证 Joule 对 SAP 标准知识的回答
5. 给 junior 成员做使用手顺
6. 建立 QA / Review 流程
7. 统计使用效果

---

目前来看，第四类已经在Abeam成功落地。但感觉像早年的问答Bot。<br>
