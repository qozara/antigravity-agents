---
name: bugfix-lifecycle
description: End-to-end single-conversation bug-fix workflow enforcing root-cause diagnosis, failing reproduction test first, minimal surgical fix, and deterministic regression gates. Invoke via /bugfix-lifecycle or when fixing bugs, errors, or regressions.
---

# Bug-Fix & Root-Cause Lifecycle (`/bugfix-lifecycle`)

Diagnose, reproduce, and resolve defects from a single conversation using strict test-first reproduction and deterministic verification gates.

> **Autonomous Execution Mandate:** The user only needs to provide the defect description or stack trace (e.g., `/bugfix-lifecycle <defect>` or *"Fix <defect>"*). Under native `Orchestrator (Carbon/Argon)`, the Planner isolates root cause and calls `exit_plan_mode(plan)` so `Gemini 4 Hydrogen` executes branch setup, failing reproduction test creation, surgical fix, and `/predeploy-gate` (`verify-gates.sh`) directly—spawning `@tester`/`@engineer` subagents only when parallelizing or isolating large suites.
>
> **Feedback Trace Invariant:** Every response during bug-fix execution must start on line 1 with:
> `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: bugfix-lifecycle | agent: <role>]`

## Phase 1: Triage, Root-Cause Diagnosis & Plan Handoff
1. **Root-Cause Isolation (Read-Only):**
   - Inspect stack traces, error logs, or issue steps using `grep_search` and bounded `view_file` / `read_file` calls (or delegate broad log/codebase tracing to `research`).
   - Identify the exact faulty invariant, boundary condition, race condition, or schema mismatch—never apply speculative symptom patches without confirming root cause.
   - Hand off via `exit_plan_mode(plan)` specifying `fix/<issue-or-bug-name>` branch creation, reproduction test target, surgical fix scope, and `verify-gates.sh` verification.

## Phase 2: Failing Reproduction Test (MANDATORY RED PHASE)
1. **Branch Check & Reproduction Test First (`Hydrogen`, `@tester`, or `@engineer`):**
   - Create or switch to `fix/<issue-or-bug-name>` from `main`.
   - Add a unit, integration, or E2E test that reproduces the exact bug input/state.
   - Execute the target test file via terminal (`npx vitest run <path>` or `npm test -- <path>`) and **verify that it fails** for the expected reason.

## Phase 3: Surgical Fix & Green Verification
1. **Minimal Surgical Implementation (`Hydrogen` or `@engineer`):**
   - Modify only the lines necessary to fix the root cause without unrelated formatting or scope creep.
   - Re-run the reproduction test and confirm it transitions from **Red** to **Green**.
   - Check adjacent callers in the blast radius for identical edge-case patterns.

## Phase 4: Deterministic Pre-Deploy Verification & Delivery (MANDATORY)
1. **Run Full Gate Suite:**
   ```bash
   ~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"
   ```
2. **Walkthrough & PR:**
   - Document the root cause, the reproduction test added, the surgical fix, and the passing gate output in the Walkthrough, then push `fix/<issue-or-bug-name>`.
