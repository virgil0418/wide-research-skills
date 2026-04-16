# Wide Research Skills

这个仓库同时提供两个相互独立的 skill：

- `wide-research-codex`：给 Codex 用
- `wide-research`：给 Claude Code 用

两者不共享提示词，不互相引用。

## Codex

Codex 版本保留自己的入口和安装说明：

- `skills/wide-research-codex/SKILL.md`
- `skills/wide-research-codex/orchestration-reference-cn.md`
- `.codex/INSTALL.md`

安装见 [`.codex/INSTALL.md`](.codex/INSTALL.md)。

## Claude Code

Claude 版本使用独立的 skill 提示词：

- `skills/wide-research/SKILL.md`

安装：

```bash
mkdir -p ~/.claude/skills
ln -s ~/projects/wide-research-skills/skills/wide-research ~/.claude/skills/wide-research
```

## 共同原则

- 先摸底，再决定是否并行
- 子任务尽量独立，避免上下文重新耦合
- 聚合必须程序化完成，不能直接让单个模型合并全部结果
- 成稿按章节迭代，不整篇一次性重写
- 最终交付为独立文件，不在聊天中粘贴全文
