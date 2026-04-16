# Installing Wide Research for Codex

Install the Codex skill through native skill discovery.

## Prerequisites

- Git

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/virgil0418/wide-research-skills.git ~/.codex/wide-research-skills
   ```

2. Link the Codex skill directory:
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/wide-research-skills/skills/wide-research-codex ~/.agents/skills/wide-research-codex
   ```

3. Restart Codex so the skill is discovered.

## Verify

```bash
ls -la ~/.agents/skills/wide-research-codex
```

## Usage

In a Codex session, reference the Chinese orchestration prompt directly:

```text
@wide-research-codex/orchestration-reference-cn.md 调研 2023-2025 年 L 卡口相机市场
```

Or mention `Wide Research` and let Codex discover the skill.

## Update

```bash
cd ~/.codex/wide-research-skills && git pull
```

## Uninstall

```bash
rm ~/.agents/skills/wide-research-codex
```
