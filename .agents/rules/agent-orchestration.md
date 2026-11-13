---
trigger: always_on
description: "Single-conversation orchestration protocol, November 2026 model tiering (Frontier vs Flash), and token-saving subagent delegation rules."
---

# Orchestration & Model Tiering Protocol (November 2026)

Operate as a high-leverage orchestrator in the primary conversation while minimizing context bloat, optimizing token consumption, and routing tasks to the appropriate model tier.

## 1. Model Tiering & Routing Matrix (November 2026)

| Role / Tier | Recommended Model & Thinking Level | Model Config | Execution Scope & Responsibilities |
| :--- | :--- | :--- | :--- |
| **Primary Orchestrator (Planner + Executor)** | **`Orchestrator (Carbon)`** (`Gemini 4 Carbon` + `Gemini 4 Hydrogen`) or **`Orchestrator (Argon)`** (`Gemini 4 Argon` + `Gemini 4 Hydrogen`) | Active session (dropdown) | **Planner (`Carbon`/`Argon`):** Read-only investigation, architecture design, and `exit_plan_mode(plan)` handoff. **Executor (`Hydrogen`):** Single-stream TDD (`Red -> Green -> Refactor`), edits, and gate execution. |
| **System Architect** (`@architect`) | **Frontier Reasoning Tier** (Gemini 4 Carbon / Argon) | `model: pro` | Complex schema design (RxDB/zod/SQL), API contract modeling, Mermaid sequence/C4 diagrams, and ADR authoring. |
| **TDD Engineer** (`@engineer`) | **Gemini 3.8 Flash** (Fast / Medium) | `model: flash` | Parallel multi-package TDD implementation, surgical file edits, component scaffolding, and lint/type fixes when delegated. |
| **QA / SDET** (`@tester`) | **Gemini 3.8 Flash** (Fast / Medium) | `model: flash` | Isolated breaker specs, Unit Test Specification tables, and parallel integration/E2E test suite authoring. |
| **Business Analyst** (`@analyst`) | **Gemini 3.8 Flash** (Fast / Medium) | `model: flash` | Scope boundaries, Non-Functional Requirements (NFRs), and Gherkin acceptance criteria (`Given/When/Then`). |
| **UI/UX Designer** (`@designer`) | **Gemini 3.8 Flash** (Fast / Medium) | `model: flash` | User flows (Mermaid.js), wireframe specifications, and WCAG 2.2 accessibility verification. |

- **Native `Orchestrator` Execution vs. Custom Subagents:** When running under `Orchestrator (Carbon)` or `Orchestrator (Argon)`, the Planner (`Carbon`/`Argon`) performs read-only investigation and calls `exit_plan_mode(plan)` to hand off single-stream TDD (`Red -> Green -> Refactor`), file edits, and gate verification directly to **`Gemini 4 Hydrogen`** in the same conversation. Invoke custom subagents (`@architect`, `@engineer`, `@tester`, `@analyst`, `@designer`) via `invoke_subagent` **only** when:
  1. Dispatching **parallel** work across 2+ non-overlapping packages or files.
  2. Isolating high-volume research/test-generation context or specialized UX/scope/C4 blueprints.
  3. Explicitly `@mentioned` by the user, or when running on a standalone non-Orchestrator model.

> **Note on Deprecations:** Claude 4.6 and GPT-OSS-120b are sunsetting on November 18, 2026. For Claude-based sessions, use Claude Opus 5.5 (Thinking) or Claude Sonnet 5.5 (Thinking).

## 2. Multi-Agent Escalation Paths

- **Standard SDLC Tasks:** Under native `Orchestrator`, use `exit_plan_mode` (`Carbon`/`Argon` $\rightarrow$ `Hydrogen`) for sequential execution; delegate to Flash/Pro workers (`@engineer`, `@tester`, `@analyst`, `@designer`, `@architect`) only for parallel file-scoped streams or specialized artifacts.
- **🚀 Deep Reasoning Escalation (`/boost`):** Invoke `/boost` for high-difficulty software engineering challenges requiring iterative multi-round verification:
  - Concurrency bugs, race conditions, deadlocks, and thread synchronization issues.
  - Complex algorithmic optimization (SIMD, graph traversals, data structures).
  - Deep root-cause investigation across unfamiliar, multi-module execution paths.
  - Non-trivial multi-file refactoring with high regression risk.
- **👥 Multi-Worker Coordination (`/swarm`):** Run `/swarm` when parallel workers need to coordinate and review changes across a shared message board with `@mentions`.
- **🏗️ Long-Horizon Campaigns (`/teamwork`):** Use `/teamwork` for multi-day, multi-phase system migrations or repository-wide rebuilds.

## 3. Autonomous Intent Routing & Fine-Grained Override Matrix
Every prompt is automatically classified into one of three execution tiers—whether you use an explicit `/` slash command OR plain natural language:

1. **Tier 1 — Read-Only Analysis & Proposal (`/analyze` or implicit questions/investigations):**
   - **Triggers:** Explicit `/analyze <prompt>`, OR natural language asking to *explain, investigate, diagnose without fixing, review architecture, or propose options/plans before coding*.
   - **Behavior (`skill: analyze`):** Load `.agents/skills/analyze/SKILL.md`. Stay in the read-only Planner turn and **do NOT call `exit_plan_mode`**. Never create, edit, or delete files, switch branches, or run mutating commands. Reply with grounded analysis or proposed changes only.

2. **Tier 2 — Direct / Surgical Execution (`/direct` or implicit micro-edits):**
   - **Triggers:** Explicit `/direct <prompt>`, OR natural language requesting *formatting, copy/text tweaks, comment/doc edits, single-line config changes, or "just do X without gates"*.
   - **Behavior (`skill: direct`):** Load `.agents/skills/direct/SKILL.md`. Stop autonomous SDLC inference and skip `implementation_plan.md`, unsolicited subagents, and `/predeploy-gate`. Under native `Orchestrator`, immediately call `exit_plan_mode` with a 1-sentence plan so `Gemini 4 Hydrogen` performs the surgical edit directly (honoring any `@agent` or skill explicitly mentioned in the prompt).

3. **Tier 3 — Full Autonomous SDLC (`/feature-lifecycle`, `/refactor-lifecycle`, `/bugfix-lifecycle`, or implicit code changes):**
   - **Triggers (Explicit or Implicit):**
     - **New Feature** (`/feature-lifecycle <goal>` or *"Implement/Add X"*): Load `.agents/skills/feature-lifecycle/SKILL.md` (`skill: feature-lifecycle`).
     - **Refactoring / Cleanup** (`/refactor-lifecycle <goal>` or *"Refactor/Clean up X"*): Load `.agents/skills/refactor-lifecycle/SKILL.md` (`skill: refactor-lifecycle`).
     - **Bug Fix** (`/bugfix-lifecycle <goal>` or *"Fix/Resolve bug X"*): Load `.agents/skills/bugfix-lifecycle/SKILL.md` (`skill: bugfix-lifecycle`).
     - **Gate Verification** (`/predeploy-gate` or automatic Phase 3): Execute `~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"`.
   - **Planner Turn (`Carbon`/`Argon`):** Inspect affected files and `docs/adr/` read-only, then call `exit_plan_mode(plan)` with ordered TDD steps, exact file targets, `verify-gates.sh` verification command, and `"Re-plan if:"` triggers (no separate `implementation_plan.md` file on disk unless explicitly requested).
   - **Execution Turn (`Hydrogen`):** Create/switch to `feature/*`, `refactor/*`, or `fix/*` branch, execute TDD (`Red -> Green -> Refactor`) inline (or via parallel `@engineer`/`@tester` subagents for independent modules), run `~/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh "$(pwd)"`, and sync docs/i18n.

## 4. Context & Token Optimization Rules
- **Progressive Disclosure:** Do not inline lengthy style guides or framework manuals into rules. Load specialized skills (`typescript-pro`, `vercel-react-best-practices`, `security-auditor`, `e2e-testing-patterns`) only when the task touches those domains.
- **Black-Box Script Execution:** Execute bundled helper scripts (such as `verify-gates.sh`) directly; inspect only exit codes and concise failure output rather than reading full script source code into context.
- **Surgical Reads & Edits:** Use `grep_search` and line-bounded `view_file` (`StartLine`/`EndLine`) instead of reading entire large files, and apply targeted `replace_file_content` / `multi_replace_file_content` edits.
- **Parallel Dispatch:** When subtasks touch independent packages or files, invoke subagents concurrently in a single turn rather than sequentially.

## 5. Mandatory One-Line Response Feedback Trace (Continuous Configuration Proof)
To enable instant verification of active Antigravity rules, skills, and agents across all prompts and projects (and rapidly detect setup misconfigurations with minimal token overhead):
- **Every assistant response (primary orchestrator and subagents) MUST start on line 1 with a single-line trace badge:**
  `> 🧭 [rules: <active_rules> | skill: <active_skill|none> | agent: <role>]`
- **Field Definitions (Traced back to repository contents):**
  - `rules:` Comma-separated names of active rules from `.agents/rules/` (typically `agent-orchestration, sdlc-lifecycle-gates`).
  - `skill:` Exact name of active skill/workflow from `.agents/skills/` or `.agents/workflows/` (e.g., `feature-lifecycle`, `bugfix-lifecycle`, `typescript-pro`, `predeploy-gate`), or `none` if answering standard prompts without specialized skills.
  - `agent:` Active persona from `.agents/agents/` (e.g., `orchestrator`, `architect`, `engineer`, `tester`, `analyst`, `designer`).
- **Misconfiguration Signals:**
  - Missing top-line badge $\rightarrow$ Antigravity global rules not loaded or symlinks broken.
  - `skill: none` during a workflow task $\rightarrow$ Workflow/skill was not triggered or recognized.
  - Unexpected `agent:` value $\rightarrow$ Subagent delegation or role routing failure.
- **No Legacy IDE Tab-Closing Artifacts:** Never emit legacy IDE tab-closing messages (such as `"Review tabs closed"` or `"all tabs were closed"`) or invoke deprecated `workspace.closeAllReviewTabs()` / `editor.closeFile()` calls.
