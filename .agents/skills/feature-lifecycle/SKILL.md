---
name: feature-lifecycle
description: End-to-end single-conversation feature delivery workflow with proportional planning, subagent delegation, TDD (Red-Green-Refactor), and deterministic pre-deploy verification gates. Invoke via /feature-lifecycle or when implementing new features.
---

# Feature Delivery Lifecycle (`/feature-lifecycle`)

Run the complete feature software development lifecycle from a single conversation while delegating isolated work to subagents and enforcing deterministic quality gates.

> **Autonomous Execution Mandate:** The user only needs to provide the feature goal (e.g., `/feature-lifecycle <goal>` or *"Implement <goal>"*). Under native `Orchestrator (Carbon/Argon)`, the Planner formulates the TDD & gate plan via `exit_plan_mode(plan)` and `Gemini 4 Hydrogen` executes branch setup, Red-Green-Refactor, `/predeploy-gate` verification (`verify-gates.sh`), and docs/i18n updates directly—spawning `@tester`/`@engineer`/`@architect` subagents only for parallel streams or isolated complex specs.
>
> **Feedback Trace Invariant:** Every response during feature delivery must start on line 1 with:
> `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: feature-lifecycle | agent: <role>]`

## Decision Tree: Proportional Stage Selection
Before spawning subagents, classify the feature complexity to avoid unnecessary token overhead:
- **Tier A — UI / Multi-Component / Schema Feature:** Include UX/Scope/Architecture review (`@designer`/`@analyst`/`@architect` if ambiguous or multi-package) $\rightarrow$ `exit_plan_mode(plan)` $\rightarrow$ TDD (`Hydrogen` or parallel `@tester`/`@engineer`) $\rightarrow$ Deterministic Gates.
- **Tier B — Standard Domain / API Feature:** Formulate plan in Planner turn $\rightarrow$ `exit_plan_mode(plan)` $\rightarrow$ `Gemini 4 Hydrogen` executes Red-Green-Refactor + `/predeploy-gate` inline (use subagents only for parallel file sets).

## Phase 1: Discovery, Architecture & Plan Handoff (`/plan`)
1. **ADR & Codebase Scan:** Use `grep_search`, `read_file`, or `research` subagent to inspect affected packages and `docs/adr/` for architectural constraints.
2. **Optional UI / Scope Elicitation (Tier A only):**
   - If user flows or WCAG 2.2 states are ambiguous, delegate wireframe/flow specs to `@designer` or scope/NFR definition to `@analyst`.
3. **Architecture & Execution Plan (`exit_plan_mode`):**
   - Formulate the execution plan inside `exit_plan_mode(plan)` enumerating `feature/<short-name>` branch setup, affected files, data/schema contracts, security controls (OWASP, input validation, auth scopes), verification commands, test targets, and `"Re-plan if:"` triggers (avoid creating an ephemeral `implementation_plan.md` on disk unless explicitly requested).

## Phase 2: Shift-Left QA & TDD Implementation (`Hydrogen` or Parallel Subagents)
1. **Branch Check:** Ensure you are on `feature/<short-name>` (branching from updated `main`).
2. **Test Specification & Breaker Analysis:**
   - Formulate a concise **Unit Test Specification Table** (happy path, boundary conditions, null/error states, security checks) inline in the plan (or delegate to `@tester` for large multi-module breaker suites).
3. **Red $\rightarrow$ Green $\rightarrow$ Refactor:**
   - Execute inline on `Gemini 4 Hydrogen` (or dispatch parallel `@engineer` subagents for independent packages with explicit non-overlapping file boundaries):
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
