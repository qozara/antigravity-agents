---
name: analyze
description: Strict read-only investigation, explanation, root-cause diagnosis, and change proposal mode without modifying any files.
---

Execute the `analyze` skill (`.agents/skills/analyze/SKILL.md`):
- **Response Badge:** Maintain line 1 trace badge: `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: analyze | agent: <role>]`.
1. **Strict Read-Only Lock:** Do NOT create, edit, or delete any files, and do NOT switch branches or run mutating commands.
2. Investigate the codebase using read-only tools and reply with the explanation, root-cause analysis, or proposed plan/diff requested by the user.

