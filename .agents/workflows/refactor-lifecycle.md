---
name: refactor-lifecycle
description: Single-conversation refactoring workflow enforcing baseline test snapshots, behavior preservation, and deterministic verification gates.
---

Autonomously execute the full `refactor-lifecycle` skill (`.agents/skills/refactor-lifecycle/SKILL.md`) and global `sdlc-lifecycle-gates` rule from the user's goal description (the user does not need to specify subagents, planning, or gates in the prompt):
- **Response Badge:** Maintain line 1 trace badge: `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: refactor-lifecycle | agent: <role>]`.
1. **Phase 1 (`/plan`):** Map blast radius and hand off via `exit_plan_mode(plan)` covering `refactor/<name>` branch, baseline gates, and target files.
2. **Phase 2 (Transform):** Create `refactor/<name>`, verify baseline tests, and apply atomic, behavior-preserving refactoring steps on `Gemini 4 Hydrogen` (or parallel `@engineer` subagents).
3. **Phase 3 (Deterministic Gates):** Run `~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"` and update architecture docs/ADRs.
4. **Phase 4 (Delivery):** Produce Walkthrough proof and push the refactor branch.
