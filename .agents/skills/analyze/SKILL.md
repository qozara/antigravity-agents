---
name: analyze
description: Strict read-only investigation, explanation, root-cause diagnosis, and architecture/change proposal mode. Never modifies files or runs mutating commands. Invoke via /analyze or automatically when asked to explain, investigate, or propose without implementing.
---

# Read-Only Analysis & Proposal Mode (`/analyze`)

Investigate code behavior, diagnose root causes, explain architecture, or propose implementation options without modifying the workspace.

> **Feedback Trace Invariant:** Every response in Analyze mode must start on line 1 with:
> `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: analyze | agent: <role>]`

## Execution Protocol
1. **Strict Read-Only Lock (Zero Mutations):**
   - **NEVER** create, edit, or delete workspace files (`edit_file`, `write_file`, `replace_file_content` are forbidden).
   - **NEVER** switch Git branches, stage/commit files, or run mutating terminal commands.
   - **NEVER** call `exit_plan_mode` when running under `Orchestrator (Carbon/Argon)`—stay in the read-only Planner turn and reply directly.
2. **Deep Grounded Analysis:**
   - Use read-only tools (`grep_search`, `view_file` / `read_file`, `find_by_name`, `list_dir`, or the `research` subagent) to inspect the codebase and trace execution paths.
3. **Actionable Output:**
   - Deliver a clear explanation, root-cause diagnosis, tradeoff matrix, or proposed code diff/plan directly in the chat response so the user can review before deciding whether to implement.

