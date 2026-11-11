---
name: feature-lifecycle
description: End-to-end single-conversation feature delivery workflow with proportional planning, subagent delegation, TDD, and deterministic pre-deploy gates.
---

Autonomously execute the full `feature-lifecycle` skill (`.agents/skills/feature-lifecycle/SKILL.md`) and global `sdlc-lifecycle-gates` rule from the user's goal description (the user does not need to specify subagents, planning, or gates in the prompt):
- **Response Badge:** Maintain line 1 trace badge: `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: feature-lifecycle | agent: <role>]`.
1. **Phase 1 (`/plan`):** Verify `feature/<name>` branch, check `docs/adr/`, and write `implementation_plan.md` covering affected files, contracts, security, and test targets.
2. **Phase 2 (TDD & Subagents):** Delegate test specs to `@tester` and Red-Green-Refactor implementation to `@engineer`.
3. **Phase 3 (Deterministic Gates):** Run `~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"` and update docs/i18n.
4. **Phase 4 (Delivery):** Produce Walkthrough proof and push the feature branch.
