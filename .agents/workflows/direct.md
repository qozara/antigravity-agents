---
name: direct
description: Minimal, surgical execution mode that bypasses heavy SDLC ceremony (plans, unsolicited subagents, and pre-deploy gates).
---

Execute the `direct` skill (`.agents/skills/direct/SKILL.md`):
- **Response Badge:** Maintain line 1 trace badge: `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: direct | agent: <role>]`.
1. Perform only the literal edits, formatting, or tasks requested in the user's prompt.
2. Under `Orchestrator (Carbon/Argon)`, immediately call `exit_plan_mode` with a 1-sentence plan so `Gemini 4 Hydrogen` applies the surgical edit directly.
3. Honor any `@agent` or domain skill explicitly referenced by the user, while skipping unsolicited subagents, `implementation_plan.md`, and `/predeploy-gate`.

