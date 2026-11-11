---
trigger: always_on
description: "Non-negotiable verification gates, phase progression, and integrity invariants for feature, refactoring, and bug-fix delivery."
---

# Mandatory SDLC Delivery Lifecycle & Quality Gates

Every feature implementation, architectural refactoring, or bug fix MUST autonomously follow this 4-phase progression—even when the user only provides a short goal description (with or without a `/feature-lifecycle`, `/refactor-lifecycle`, or `/bugfix-lifecycle` prefix). Never wait for the user to explicitly mention planning, branch creation, `@tester`/`@engineer` delegation, or `/predeploy-gate` in their prompt. Do not advance to the next phase until the current phase's exit criteria are satisfied.

## Phase 1: Planning, Blast Radius & Architecture
- **Branch Hygiene:** Verify current Git branch first. Never commit or push directly to `main` or `master`; create or switch to a dedicated branch (`feature/<name>`, `refactor/<name>`, or `fix/<name>`).
- **ADR & Architecture Check:** If `docs/adr/` exists, review relevant Architectural Decision Records for conflicts before designing changes.
- **Implementation Plan:** For multi-file features or refactorings, produce or update the `implementation_plan.md` artifact enumerating affected files, interface contracts, blast radius, security implications (OWASP, input validation, auth scopes), and test targets.

## Phase 2: TDD Execution & Subagent Delegation
- **Test-First Discipline (Red -> Green -> Refactor):**
  - **Features:** Write failing unit/integration tests covering happy paths, edge cases, and error states before implementing business logic.
  - **Bug Fixes:** Write a failing reproduction test that isolates the root cause before applying the fix.
  - **Refactorings:** Verify existing baseline tests pass before modifying structure, and preserve external behavior throughout.
- **Subagent Delegation:** Delegate isolated boilerplate, test generation, and localized fixes to subagents rather than churning large diffs in the primary orchestrator context.

## Phase 3: Deterministic Pre-Deploy Gates (MANDATORY)
Before declaring any task complete, opening a PR, or pushing a branch, execute all applicable deterministic checks via terminal (or run `/predeploy-gate`):
1. **Type & Lint Verification:** Run workspace typechecking (`npm run check` or `npx tsc --noEmit`) and linting (`npm run lint` if configured). Zero errors allowed.
2. **Test Suite Execution:** Run unit, integration, and regression tests (`npm test` / `npx vitest run`). 100% of executed tests must pass.
3. **Security & Vulnerability Scan:** Run dependency and static security checks (`npm audit --audit-level=high`). Zero high or critical vulnerabilities allowed.
4. **Build Verification:** Run workspace build (`npm run build`) to confirm clean bundling and schema compilation.
5. **Documentation & i18n Sync:** Update affected docs (`README.md`, `docs/`, `docs/adr/`, OpenAPI specs) and keep localization dictionaries (`en`/`es` if present) in sync.

## Phase 4: Delivery & Integrity Guardrails
- **Walkthrough Proof:** Summarize diffs, test output, and gate verification results in the final walkthrough.
- **Response Feedback Trace Badge:** Every response must maintain the top-line trace badge (`> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: <active-skill|none> | agent: <role>]`) to continuously verify active rules, skills, and agent identity.
- **Strict Integrity Rules (Zero Tolerance):**
  - Never delete, skip (`.skip`), or weaken assertions in existing tests to force a green build.
  - Never commit generated databases (`.sqlite`, `.ndjson`), `.env` secrets, or ephemeral `implementation_plan.md` files unless tracked by the repo.
  - Never leak absolute workstation paths (`/Users/...` or `file:///`) or personal PII into code, tests, ADRs, or documentation.
