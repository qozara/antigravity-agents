---
name: bugfix-lifecycle
description: End-to-end single-conversation bug-fix workflow enforcing root-cause diagnosis, failing reproduction test first, minimal surgical fix, and deterministic regression gates. Invoke via /bugfix-lifecycle or when fixing bugs, errors, or regressions.
---

# Bug-Fix & Root-Cause Lifecycle (`/bugfix-lifecycle`)

Diagnose, reproduce, and resolve defects from a single conversation using strict test-first reproduction and deterministic verification gates.

## Phase 1: Triage, Root-Cause Diagnosis & Branch Setup
1. **Branch Check:** Create or switch to `fix/<issue-or-bug-name>` from `main`.
2. **Root-Cause Isolation:**
   - Inspect stack traces, error logs, or issue steps using `grep_search` and bounded `view_file` reads (or delegate broad log/codebase tracing to `research`).
   - Identify the exact faulty invariant, boundary condition, race condition, or schema mismatch—never apply speculative symptom patches without confirming root cause.

## Phase 2: Failing Reproduction Test (MANDATORY RED PHASE)
1. **Write the Reproduction Test First (`@tester` or `@engineer`):**
   - Add a unit, integration, or E2E test that reproduces the exact bug input/state.
   - Execute the target test file via terminal (`npx vitest run <path>` or `npm test -- <path>`) and **verify that it fails** for the expected reason.

## Phase 3: Surgical Fix & Green Verification
1. **Minimal Surgical Implementation (`@engineer`):**
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
