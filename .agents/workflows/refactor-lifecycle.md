---
name: refactor-lifecycle
description: Single-conversation refactoring workflow enforcing baseline test snapshots, behavior preservation, and deterministic verification gates.
---

Autonomously execute the full `refactor-lifecycle` skill (`.agents/skills/refactor-lifecycle/SKILL.md`) and global `sdlc-lifecycle-gates` rule from the user's goal description (the user does not need to specify subagents, planning, or gates in the prompt):
- **Response Badge:** Maintain line 1 trace badge: `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: refactor-lifecycle | agent: <role>]`.
1. **Phase 1 (`/plan`):** Verify `refactor/<name>` branch, run baseline tests, map blast radius, and document plan in `implementation_plan.md`.
2. **Phase 2 (Transform):** Delegate atomic, behavior-preserving refactoring steps to `@engineer` (`codebase-cleanup-tech-debt`, `typescript-pro`).
3. **Phase 3 (Deterministic Gates):** Run `~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"` and update architecture docs/ADRs.
4. **Phase 4 (Delivery):** Produce Walkthrough proof and push the refactor branch.
