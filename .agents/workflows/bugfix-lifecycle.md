---
name: bugfix-lifecycle
description: Single-conversation bug-fix workflow enforcing root-cause diagnosis, failing reproduction test first, surgical fix, and deterministic gates.
---

Follow the `bugfix-lifecycle` skill (`.agents/skills/bugfix-lifecycle/SKILL.md`) and global `sdlc-lifecycle-gates` rule:
1. **Phase 1 (Triage):** Verify `fix/<name>` branch and isolate root cause via `grep_search` / `research`.
2. **Phase 2 (Red):** Write a failing reproduction test in `@tester` / `@engineer` and confirm it fails via terminal.
3. **Phase 3 (Green):** Implement the minimal surgical fix in `@engineer` and verify the reproduction test passes.
4. **Phase 4 (Deterministic Gates & Delivery):** Run `~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"`, produce Walkthrough proof, and push the fix branch.
