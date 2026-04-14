# Wide Research Skills

Multi-agent parallel research orchestration for **Claude Code** and **Codex CLI**.

Inspired by [grapeot/codex_wide_research](https://github.com/grapeot/codex_wide_research) and the "Wide Research" feature from [Manus](https://manus.im).

---

## What is Wide Research?

All LLMs suffer from **context window degradation** — once output fills 20-50% of the context window, quality drops (skipping items, summarizing instead of processing, missing entries). This makes large-scale research tasks unreliable.

Wide Research solves this with a **divide-and-conquer** strategy:

1. Break a large task into independent subtasks
2. Spawn a separate agent for each (each with its own isolated context window)
3. Run them in parallel
4. Aggregate results programmatically (not via LLM)
5. Polish section-by-section

## Skills Included

### `wide-research` (Claude Code)

Adapted for Claude Code's tool system — uses the Agent tool for parallel dispatch, WebSearch for queries, and webReader for URL fetching.

| File | Purpose |
|------|---------|
| `skills/wide-research/SKILL.md` | Orchestration overview + tool mapping |
| `skills/wide-research/orchestration-reference.md` | Full 9-step procedure |
| `skills/wide-research/child-agent-prompt-template.md` | Template for sub-agent prompts |

### `wide-research-codex` (Codex CLI)

The original Codex CLI version with full prompt files in English and Chinese.

| File | Purpose |
|------|---------|
| `skills/wide-research-codex/SKILL.md` | Orchestration overview |
| `skills/wide-research-codex/orchestration-reference-en.md` | Full English prompt |
| `skills/wide-research-codex/orchestration-reference-cn.md` | Full Chinese prompt |
| `skills/wide-research-codex/scripts/run_children.sh` | Parallel scheduler script |
| `skills/wide-research-codex/examples/` | 6 example research reports |

## Installation

### For Claude Code

Clone and symlink the skill:

```bash
git clone https://github.com/virgil0418/wide-research-skills.git ~/projects/wide-research-skills
mkdir -p ~/.claude/skills
ln -s ~/projects/wide-research-skills/skills/wide-research ~/.claude/skills/wide-research
```

Restart Claude Code to discover the skill.

### For Codex CLI

See [`.codex/INSTALL.md`](.codex/INSTALL.md) for detailed instructions.

## Example Outputs

The `skills/wide-research-codex/examples/` directory contains three complete research reports:

| Topic | EN | CN |
|-------|----|----|
| L-Mount Camera Market (2023-2025) | `L_mount_cameras_en.md` | `L_mount_cameras_cn.md` |
| Yage AI Perspectives | `yage_ai_en.md` | `yage_ai_cn.md` |
| Yang Zhenning Biography | `yang_zhenning_report_en.md` | `yang_zhenning_report_cn.md` |

## Key Principles

- **Programmatic aggregation** — never use LLM to merge child outputs
- **Cache first** — persist fetched content before processing
- **Read fully** — no truncation by fixed length
- **Section-by-section polish** — never wipe and rewrite entire document
- **Deliver as file** — provide path + synopsis, never paste in chat

## Credits

- Original concept and prompts: [grapeot/codex_wide_research](https://github.com/grapeot/codex_wide_research)
- Inspired by Manus Wide Research feature

## License

MIT

---

## 中文说明

### 什么是 Wide Research？

所有大语言模型都面临**上下文窗口退化**问题——当输出占据上下文窗口的 20-50% 时，模型质量会下降（跳过条目、过度概括、遗漏信息）。这导致大规模调研任务不可靠。

Wide Research 用**分治策略**解决这个问题：

1. 将大任务拆分为独立子任务
2. 为每个子任务启动独立 agent（隔离的上下文窗口）
3. 并行执行
4. 用脚本程序化聚合结果（而非 LLM 合并）
5. 逐章润色

### 安装

**Claude Code：**
```bash
git clone https://github.com/virgil0418/wide-research-skills.git ~/projects/wide-research-skills
mkdir -p ~/.claude/skills
ln -s ~/projects/wide-research-skills/skills/wide-research ~/.claude/skills/wide-research
```

**Codex CLI：** 详见 [`.codex/INSTALL.md`](.codex/INSTALL.md)

### 核心原则

- **程序化聚合** — 禁止用 LLM 合并子任务输出
- **缓存优先** — 获取的内容先落盘再处理
- **全文阅读** — 禁止按固定长度截断
- **逐章润色** — 禁止一次性删除重写整篇文档
- **文件交付** — 提供文件路径和摘要，禁止在聊天中粘贴全文
