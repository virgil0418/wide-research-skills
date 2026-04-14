# Wide Research — Full Orchestration Reference (Claude Code)

> This is the complete 9-step procedure adapted for Claude Code from [grapeot/codex_wide_research](https://github.com/grapeot/codex_wide_research). Read the SKILL.md first for the overview and tool mapping.

## Phase 0 — Pre-run Planning & Reconnaissance (Mandatory)

**You must perform this phase yourself. Do not delegate it.**

1. Clarify user intent, assess risks/resources, and identify the core dimensions that will anchor the research fan-out (topic clusters, stakeholder lists, geography slices, timeline buckets, etc.).

2. When public indices exist (tag pages, API lists), cache them via minimal fetches and count entries. Otherwise, run light-touch desk research (WebSearch, existing datasets) to surface representative items. Capture concrete evidence: source URLs, timestamps, key takeaways.

3. Before drafting any outline, demonstrate at least one actual sample gathered through reconnaissance. Pure speculation does not satisfy the scoping requirement.

4. Use WebSearch to collect at least one directly relevant sample and record its citation.

5. Produce a provisional manifest capturing:
   - Discovered dimensions
   - Items collected per dimension
   - Supporting samples
   - Estimated scale
   - Data gaps or uncertainties

6. If no real samples secured yet, continue reconnaissance. Do not advance to later steps.

7. Draft the executable plan (subtasks, tools, outputs, timeouts), then report both the dimension inventory and plan to the user. **Wait for explicit user approval ("go/execute") before proceeding.**

## Phase 1 — Initialization

1. Clarify goals, expected output formats, and evaluation criteria.
2. Create a semantic, unique run directory:
   ```
   runs/<date>-<task-summary>-<random-suffix>/
   ```
   This stores all artifacts: prompts, logs, child outputs, aggregates, final report.
3. Create subdirectories: `prompts/`, `child_outputs/`, `logs/`, `raw/`.

## Phase 2 — Identify Sub-goals

1. Extract or construct the subtask list, assigning each a unique identifier (e.g., `task-01`, `task-02`).
2. If the source provides fewer items than expected, record the gap. For very small tasks (2 or fewer items), handle directly without dispatching agents.
3. Write the subtask manifest to the run directory for traceability.

## Phase 3 — Design Child Agent Prompts

For each subtask, prepare a prompt using `./child-agent-prompt-template.md` as the base template. Each prompt must include:

1. **Task description** — What to research, specific boundaries
2. **Input data** — URLs, search terms, data fragments relevant to this subtask
3. **Tool constraints:**
   - Use WebSearch for web queries
   - Use `mcp__web_reader__webReader` for fetching specific URLs
   - Do NOT use curl/wget unless absolutely necessary
   - Do NOT wait for human approval — execute end-to-end independently
4. **Search iteration limit** — Max 10 search rounds per task. Plan efficiently, stop when information is sufficient.
5. **Output format** — Natural-language Markdown: task conclusions, key evidence list, inline citations (`[source](url)`), and error sections if applicable.
6. **Failure handling** — Attempt acquisition twice. If both fail, write a Markdown subsection explaining the error and recommended follow-up. Never leave blank sections.

### Generating Prompt Files

Write prompt files to `prompts/<task-id>.md` using the Write tool. After generating, re-read each file to verify:
- Variable substitutions are correct
- Task boundaries are clear
- Tool constraints are present
- Output format is specified

## Phase 4 — Parallel Dispatch via Agent Tool

Dispatch all subtask agents in parallel using the Agent tool:

```
# Dispatch multiple agents in a single message for parallel execution
Agent({ description: "Research: <task-01 topic>", prompt: "<contents of prompts/task-01.md>", subagent_type: "general-purpose" })
Agent({ description: "Research: <task-02 topic>", prompt: "<contents of prompts/task-02.md>", subagent_type: "general-purpose" })
...
```

**Concurrency:** Default 8 parallel agents. Adjust based on task complexity.

**Monitoring:** Track which agents have completed and which failed. For failures:
- Record the failure
- Decide: retry with modified prompt, or document gap in final report

**For very large batches (>8 tasks):** Dispatch in waves of 8 to avoid overwhelming the system.

### Important Notes on Agent Dispatch

- Each agent gets an isolated context — they cannot see each other's work
- Agents return their results directly — no need to read output files
- If an agent fails, you can retry with a simpler prompt or narrower scope
- Do NOT dispatch agents sequentially when they can run in parallel

## Phase 5 — Programmatic Aggregation (Baseline Draft)

**CRITICAL: This step must NOT use an LLM.**

1. For each completed agent result, write the output to `child_outputs/<task-id>.md`.
2. Concatenate all child outputs into a single file using Bash:
   ```bash
   cat child_outputs/*.md > runs/<run-id>/final_report_raw.md
   ```
3. This raw aggregate serves as the material for polishing — it is NOT the final deliverable.
4. Preserve all child citations and wording. This is raw material.

## Phase 6 — Digest the Aggregate & Design the Outline

1. Read through `final_report_raw.md` and key child outputs.
2. Inventory: coverage, duplication, gaps, and "to-verify" notes. Capture in `notes.md`.
3. Draft a polished-report outline (`polish_outline.md`) defining:
   - Target audience
   - Chapter order
   - Which sources feed each section
   - Core argument per chapter

## Phase 7 — Section-by-Section Polishing

1. Create `polished_report.md` and write it one section at a time.
2. After each section, validate:
   - Facts are accurate
   - Citations are inline (`[source](url)`) not dumped at end
   - Language matches user's requested language
3. Never wipe and rewrite the entire document. Iterative chapters reduce context drift.
4. Normalize duplicated content, citation style, and "to-confirm" items while keeping critical facts and metrics intact.
5. Note key decisions, issues, and fixes as you go.

## Phase 8 — Two-Step QA

Before releasing the report:

1. **Verify it was assembled via staged, chapter-by-chapter edits.** If it turns out to be a single-pass generation, roll back and rebuild iteratively.
2. **Gauge depth.** If the narrative is thin, determine whether child outputs are under-detailed (rerun/augment child tasks) or synthesis compressed them (expand the final edit).

## Phase 9 — Deliverables

1. Ensure the polished draft meets customer-ready standards: coherent structure, unified tone, accurate citations.
2. Deliver by sharing the file path plus a concise synopsis. **Never paste the full document into chat.**
3. In the final response, recap main findings and actionable recommendations.
4. Do not attach intermediate drafts or internal notes to the customer-facing handoff.

## Notes & Best Practices

### Cache First
When WebSearch or webReader returns raw materials, persist them to the run directory (`raw/`) before processing. Reuse cached files to minimize duplicate fetches.

### Read Fully Before Summarizing
Do not truncate content by fixed length (e.g., first 500 chars). Read the full content and extract key insights.

### Keep Temporary Assets Isolated
Store intermediates (logs, parsed text, caches, scratch data) under `tmp/`, `raw/`, `cache/` within the run directory.

### Validate Before Scaling
Before dispatching all agents, test with 1-2 agents to verify tool setup, search connectivity, and output paths. Then scale up.

### Failure Isolation
When a parallel child fails, record its ID and log, then rerun just that unit. Maintain a `failed_ids` list and surface it at the end.

### Avoid Duplicate Fetches
When retrying a failed task, skip any child whose output file already exists and passes validation.

### Coverage Checks
After batch generation, run a quick check to flag missing entries, empty fields, or label count issues before polishing.

### Presentation Style
Cite sources inline right after each bullet using Markdown links, not dumping URLs at the end. Make fact-checking immediate.

## Reflection Guide

Aim for depth and original insight. Before tackling any task, consider why the user might be asking it — what broader context or hidden assumptions could be driving the request? If you spot a better framing or a more fundamental question, surface it.

Define what success looks like before answering. Let those criteria shape the structure of your output.

Treat this as collaboration. Your mission is co-discovery — question shaky assumptions, suggest better angles, and help arrive at sharper conclusions step by step.

Use bullet points sparingly. Favor natural paragraphs. Avoid quotation marks unless quoting verbatim.
