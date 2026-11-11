---
name: feature-lifecycle
description: End-to-end single-conversation feature delivery workflow with proportional planning, subagent delegation, TDD (Red-Green-Refactor), and deterministic pre-deploy verification gates. Invoke via /feature-lifecycle or when implementing new features.
---

# Feature Delivery Lifecycle (`/feature-lifecycle`)

Run the complete feature software development lifecycle from a single conversation while delegating isolated work to subagents and enforcing deterministic quality gates.

> **Feedback Trace Invariant:** Every response during feature delivery must start on line 1 with:
> `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: feature-lifecycle | agent: <role>]`

## Decision Tree: Proportional Stage Selection
Before spawning subagents, classify the feature complexity to avoid unnecessary token overhead:
- **Tier A — UI / Multi-Component / Schema Feature:** Run all phases (UX/Scope check $\rightarrow$ Architecture & ADR $\rightarrow$ QA Spec & TDD $\rightarrow$ Deterministic Gates).
- **Tier B — Standard Domain / API Feature:** Skip `@designer` and `@analyst`; go directly from Phase 1 (`@architect` or inline `/plan`) to Phase 2 (`@tester` + `@engineer` TDD) and Phase 3 (`/predeploy-gate`).

## Phase 1: Branch Setup, Discovery & Architecture (`/plan`)
1. **Branch Check:** Ensure you are on `feature/<short-name>` (branching from updated `main`).
2. **ADR & Codebase Scan:** Use `research` subagent or `grep_search` to inspect affected packages and `docs/adr/` for architectural constraints.
3. **Optional UI / Scope Elicitation (Tier A only):**
   - If user flows or WCAG 2.2 states are ambiguous, delegate wireframe/flow specs to `@designer` or scope/NFR definition to `@analyst`.
4. **Architecture & Implementation Plan:**
   - Produce or update `implementation_plan.md` enumerating affected files, data/schema contracts, security controls (OWASP, input validation, auth scopes), and test targets.

## Phase 2: Shift-Left QA & TDD Implementation (Subagent Delegation)
1. **Test Specification & Breaker Analysis:**
   - Delegate to `@tester` (or formulate inline for small features) a concise **Unit Test Specification Table** (happy path, boundary conditions, null/error states, security checks) plus integration/E2E test stubs.
2. **Red $\rightarrow$ Green $\rightarrow$ Refactor (`@engineer`):**
   - Delegate implementation to `@engineer` (Flash tier) with explicit file boundaries:
     - **Red:** Write failing unit/integration tests matching the specification first.
     - **Green:** Implement minimal, clean domain and presentation code to pass tests.
     - **Refactor:** Apply `typescript-pro` and `vercel-react-best-practices` (if React) while keeping all tests green.

## Phase 3: Deterministic Pre-Deploy Verification (MANDATORY)
Execute the bundled verification gate runner:
```bash
~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"
```
- Verify zero TypeScript/lint errors, 100% passing unit/integration tests, zero high/critical `npm audit` vulnerabilities, clean monorepo build, and zero workstation path leaks.
- Update documentation (`README.md`, `docs/`, `docs/adr/`) and synchronize i18n locale dictionaries (`en`/`es`) if user-facing strings changed.

## Phase 4: Walkthrough & PR Preparation
- Produce a concise Walkthrough summarizing changed files, test coverage added, and deterministic gate output.
- Push the `feature/<short-name>` branch (triggers the local `pre-push` hook) and prepare the PR description.
