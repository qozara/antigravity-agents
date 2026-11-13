---
name: bugfix-lifecycle
description: Single-conversation bug-fix workflow enforcing root-cause diagnosis, failing reproduction test first, surgical fix, and deterministic gates.
---

Autonomously execute the full `bugfix-lifecycle` skill (`.agents/skills/bugfix-lifecycle/SKILL.md`) and global `sdlc-lifecycle-gates` rule from the user's defect description (the user does not need to specify subagents, reproduction tests, or gates in the prompt):
- **Response Badge:** Maintain line 1 trace badge: `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: bugfix-lifecycle | agent: <role>]`.
1. **Phase 1 (Triage):** Isolate root cause via `grep_search` / `research` and hand off via `exit_plan_mode(plan)`.
2. **Phase 2 (Red):** Switch to `fix/<name>`, write a failing reproduction test (`Hydrogen` or `@tester`/`@engineer`), and confirm it fails via terminal.
3. **Phase 3 (Green):** Implement the minimal surgical fix (`Hydrogen` or `@engineer`) and verify the reproduction test passes.
4. **Phase 4 (Deterministic Gates & Delivery):** Run `~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"`, produce Walkthrough proof, and push the fix branch.
