# Installing Wide Research Skills for Codex

Enable wide-research skills in Codex via native skill discovery. Clone and symlink.

## Prerequisites

- Git

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/virgil0418/wide-research-skills.git ~/.codex/wide-research-skills
   ```

2. **Create the skills symlink:**
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/wide-research-skills/skills/wide-research-codex ~/.agents/skills/wide-research-codex
   ```

   **Windows (PowerShell):**
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
   cmd /c mklink /J "$env:USERPROFILE\.agents\skills\wide-research-codex" "$env:USERPROFILE\.codex\wide-research-skills\skills\wide-research-codex"
   ```

3. **Restart Codex** (quit and relaunch the CLI) to discover the skills.

## Verify

```bash
ls -la ~/.agents/skills/wide-research-codex
```

You should see a symlink (or junction on Windows) pointing to the skill directory.

## Usage

In a Codex session, reference the orchestration prompt:

```
# English
@wide-research-codex/orchestration-reference-en.md Research the L-mount camera market from 2023-2025

# Chinese
@wide-research-codex/orchestration-reference-cn.md 调研2023-2025年L卡口相机市场
```

Or simply mention "Wide Research" and Codex will discover the skill.

## Updating

```bash
cd ~/.codex/wide-research-skills && git pull
```

Skills update instantly through the symlink.

## Uninstalling

```bash
rm ~/.agents/skills/wide-research-codex
```

Optionally delete the clone: `rm -rf ~/.codex/wide-research-skills`.
