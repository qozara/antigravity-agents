---
name: predeploy-gate
description: Runs deterministic pre-deploy quality gates (branch policy, path leakage, TypeScript typecheck, linter, unit/integration tests, npm security audit, and build). Use before completing any feature, refactoring, or bug fix, or invoke directly via /predeploy-gate.
---

# Deterministic Pre-Deploy Verification Gate (`/predeploy-gate`)

Executes the bundled black-box verification script to deterministically validate all repository invariants before completing a task or pushing a branch.

> **Feedback Trace Invariant:** Every response during gate execution must start on line 1 with:
> `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: predeploy-gate | agent: <role>]`

## Execution Protocol

1. **Run the Bundled Verification Script (Do NOT read script source into context):**
   Execute `verify-gates.sh` from the active workspace root:
   ```bash
   ~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"
   ```
   *(Fallback if running directly from workspace `.agents`: `.agents/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"`)*

2. **Self-Correction Loop on Failure:**
   - **Gate 1 (Protected Branch):** Create and switch to `feature/<name>`, `refactor/<name>`, or `fix/<name>`.
   - **Gate 2 (Path/Artifact Leak):** Remove absolute `/Users/...` paths or generated `.sqlite`/`.ndjson` files from git tracking.
   - **Gate 3/4 (Typecheck/Lint):** Fix all TypeScript or ESLint errors (delegate localized fixes to `@engineer` if spanning multiple files).
   - **Gate 5 (Security Audit):** Resolve vulnerable packages or update `overrides` in `package.json`.
   - **Gate 6 (Tests):** Fix regressions in implementation logic—never weaken or skip tests.
   - **Gate 7 (Build):** Resolve bundling, DTS, or schema compilation errors.

3. **Documentation & i18n Check:**
   - Confirm `README.md`, `docs/`, and `docs/adr/` reflect any architectural or contract changes.
   - If the project uses `@quomida/i18n-locales` or locale dictionaries, verify `en` and `es` keys match 100%.
