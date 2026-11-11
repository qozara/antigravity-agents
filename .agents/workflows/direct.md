---
name: direct
description: Minimal, surgical execution mode that bypasses heavy SDLC ceremony (plans, unsolicited subagents, and pre-deploy gates).
---

Execute the `direct` skill (`.agents/skills/direct/SKILL.md`):
- **Response Badge:** Maintain line 1 trace badge: `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: direct | agent: <role>]`.
1. Perform only the literal edits, formatting, or tasks requested in the user's prompt.
2. Honor any `@agent` or domain skill explicitly referenced by the user, while skipping unsolicited subagents, `implementation_plan.md`, and `/predeploy-gate`.

