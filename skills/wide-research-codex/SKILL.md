---
name: wide-research-codex
description: Use when the user mentions "Wide Research", or when a Codex research task should be decomposed into parallel codex exec workers before synthesis
---

# Wide Research for Codex

这是 Codex 专用 skill。

核心参考文档只有一份：

- `./orchestration-reference-cn.md`

## 使用方式

- 先完整阅读 `./orchestration-reference-cn.md`
- 按文档中的 Codex CLI 约束执行，不要替换成其他平台的工具语义
- 适用于需要并行拆分、程序化聚合、逐章润色的大型调研任务
- 不适用于小任务、强耦合任务或不值得并行的任务

## 关键要求

- 子任务通过 `codex exec` 并行运行
- 聚合必须是程序化处理，不允许直接让单个大模型合并总结
- 最终交付物必须是独立文件，而不是聊天里的整篇正文
