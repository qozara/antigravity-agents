---
name: refactor-lifecycle
description: End-to-end single-conversation refactoring and tech-debt workflow enforcing baseline test snapshots, behavior preservation, subagent delegation, and deterministic quality gates. Invoke via /refactor-lifecycle or when refactoring code.
---

# Refactoring & Tech-Debt Lifecycle (`/refactor-lifecycle`)

Execute safe, behavior-preserving structural refactorings from a single conversation with zero functional regressions.

> **Autonomous Execution Mandate:** The user only needs to provide the refactoring goal (e.g., `/refactor-lifecycle <goal>` or *"Refactor <goal>"*). Under native `Orchestrator (Carbon/Argon)`, the Planner maps blast radius and hands off via `exit_plan_mode(plan)` so `Gemini 4 Hydrogen` executes branch setup, baseline checks, atomic refactoring, and `/predeploy-gate` (`verify-gates.sh`) directly—spawning `@engineer`/`@tester` subagents only for parallel packages or missing characterization test suites.
>
> **Feedback Trace Invariant:** Every response during refactoring must start on line 1 with:
> `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: refactor-lifecycle | agent: <role>]`

## Phase 1: Blast-Radius Analysis & Plan Handoff (`/plan`)
1. **Blast Radius & Plan (`exit_plan_mode`):**
   - Map all callers, exports, and downstream consumers read-only using `grep_search` or `research`.
   - If public interfaces or architectural boundaries change, review `docs/adr/`.
   - Formulate the target refactoring plan inside `exit_plan_mode(plan)` (including `refactor/<short-name>` branch creation, baseline gate run, target files, and `"Re-plan if:"` triggers).

## Phase 2: Baseline Snapshot & Incremental Structural Transformation
1. **Branch Check & Baseline Gate Run:** Create or switch to `refactor/<short-name>` from `main`, then run tests and typecheck *before* touching code to confirm a clean starting baseline:
   ```bash
   ~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)" --skip-build
   ```
   - If existing test coverage on the target module is missing, write characterization tests (inline on `Hydrogen` or delegated to `@tester`) *before* refactoring.
2. **Atomic Transformations (`Hydrogen` or Parallel `@engineer`):**
   - Apply `codebase-cleanup-tech-debt`, `typescript-pro`, or `react-modernization` skills directly on `Gemini 4 Hydrogen` (or dispatch parallel `@engineer` subagents when refactoring independent packages with non-overlapping file lists).
   - Perform small, atomic structural steps (extract pure functions, eliminate dead exports, replace `any` with discriminated unions, decouple state from UI).
   - **Invariant:** Never mix behavioral feature changes with structural refactoring in the same step, and never modify test assertions unless testing internal signatures explicitly targeted for replacement.

## Phase 3: Deterministic Pre-Deploy Verification (MANDATORY)
Execute the full deterministic verification suite:
```bash
~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"
```
- Confirm zero TypeScript errors, 100% passing characterization and regression tests, zero `npm audit` high/critical vulnerabilities, and a clean build.
- Update `docs/ARCHITECTURE.md` or `docs/adr/` if module boundaries changed.

## Phase 4: Delivery
- Summarize structural improvements, complexity reduction, and verification proof in the Walkthrough, then push `refactor/<short-name>`.
