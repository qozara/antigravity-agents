---
name: refactor-lifecycle
description: End-to-end single-conversation refactoring and tech-debt workflow enforcing baseline test snapshots, behavior preservation, subagent delegation, and deterministic quality gates. Invoke via /refactor-lifecycle or when refactoring code.
---

# Refactoring & Tech-Debt Lifecycle (`/refactor-lifecycle`)

Execute safe, behavior-preserving structural refactorings from a single conversation with zero functional regressions.

## Phase 1: Baseline Snapshot & Blast-Radius Analysis (`/plan`)
1. **Branch Check:** Create or switch to `refactor/<short-name>` from `main`.
2. **Baseline Gate Run:** Run tests and typecheck *before* touching code to confirm a clean starting baseline:
   ```bash
   ~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)" --skip-build
   ```
3. **Blast Radius & Plan:**
   - Map all callers, exports, and downstream consumers using `grep_search` or the `research` subagent.
   - If public interfaces or architectural boundaries change, review `docs/adr/` and document the target structure in `implementation_plan.md`.
   - If existing test coverage on the target module is missing, delegate characterization test creation to `@tester` *before* refactoring.

## Phase 2: Incremental Structural Transformation
1. **Delegate Isolated Transformations (`@engineer`):**
   - Apply `codebase-cleanup-tech-debt`, `typescript-pro`, or `react-modernization` skills.
   - Perform small, atomic structural steps (extract pure functions, eliminate dead exports, replace `any` with discriminated unions, decouple state from UI).
   - **Invariant:** Never mix behavioral feature changes with structural refactoring in the same step, and never modify test assertions unless testing internal signatures explicitly targeted for replacement.
2. **Parallel Subagent Dispatch:** When refactoring independent packages or components, dispatch parallel `@engineer` subagents with non-overlapping file lists.

## Phase 3: Deterministic Pre-Deploy Verification (MANDATORY)
Execute the full deterministic verification suite:
```bash
~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"
```
- Confirm zero TypeScript errors, 100% passing characterization and regression tests, zero `npm audit` high/critical vulnerabilities, and a clean build.
- Update `docs/ARCHITECTURE.md` or `docs/adr/` if module boundaries changed.

## Phase 4: Delivery
- Summarize structural improvements, complexity reduction, and verification proof in the Walkthrough, then push `refactor/<short-name>`.
