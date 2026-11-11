---
trigger: always_on
description: "Single-conversation orchestration protocol, November 2026 model tiering (Frontier vs Flash), and token-saving subagent delegation rules."
---

# Orchestration & Model Tiering Protocol (November 2026)

Operate as a high-leverage orchestrator in the primary conversation while minimizing context bloat, optimizing token consumption, and routing tasks to the appropriate model tier.

## 1. Model Tiering & Routing Matrix (November 2026)

| Role / Tier | Recommended Model & Thinking Level | Model Config | Execution Scope & Responsibilities |
| :--- | :--- | :--- | :--- |
| **Primary Orchestrator** | **Gemini 4 Carbon** (High thinking) or **Gemini 4 Argon** (Medium thinking) | Active session | Maintains conversation state, file boundaries, `/plan` formulation, quality gate verification, and PR delivery. |
| **System Architect** (`@architect`) | **Frontier Reasoning Tier** (Gemini 4 Carbon / Argon) | `model: pro` | Complex schema design (RxDB/zod/SQL), API contract modeling, Mermaid sequence/C4 diagrams, and ADR authoring. |
| **TDD Engineer** (`@engineer`) | **Gemini 3.8 Flash** (Fast / Medium) | `model: flash` | Single-pass TDD (Red-Green-Refactor), surgical file edits, component scaffolding, and lint/type error fixes. |
| **QA / SDET** (`@tester`) | **Gemini 3.8 Flash** (Fast / Medium) | `model: flash` | Unit test specification tables, gap analysis, failing reproduction tests, and automated integration/E2E test authoring. |
| **Business Analyst** (`@analyst`) | **Gemini 3.8 Flash** (Fast / Medium) | `model: flash` | Scope boundaries, Non-Functional Requirements (NFRs), and Gherkin acceptance criteria (`Given/When/Then`). |
| **UI/UX Designer** (`@designer`) | **Gemini 3.8 Flash** (Fast / Medium) | `model: flash` | User flows (Mermaid.js), wireframe specifications, and WCAG 2.2 accessibility verification. |

> **Note on Deprecations:** Claude 4.6 and GPT-OSS-120b are sunsetting on November 18, 2026. For Claude-based sessions, use Claude Opus 5.5 (Thinking) or Claude Sonnet 5.5 (Thinking).

## 2. Multi-Agent Escalation Paths

- **Standard SDLC Tasks:** Maintain overall task state in the primary frontier session and delegate file-scoped tasks to Flash workers (`@engineer`, `@tester`, `@analyst`, `@designer`).
- **🚀 Deep Reasoning Escalation (`/boost`):** Invoke `/boost` for high-difficulty software engineering challenges requiring iterative multi-round verification:
  - Concurrency bugs, race conditions, deadlocks, and thread synchronization issues.
  - Complex algorithmic optimization (SIMD, graph traversals, data structures).
  - Deep root-cause investigation across unfamiliar, multi-module execution paths.
  - Non-trivial multi-file refactoring with high regression risk.
- **👥 Multi-Worker Coordination (`/swarm`):** Run `/swarm` when parallel workers need to coordinate and review changes across a shared message board with `@mentions`.
- **🏗️ Long-Horizon Campaigns (`/teamwork`):** Use `/teamwork` for multi-day, multi-phase system migrations or repository-wide rebuilds.

## 3. Single-Conversation Workflow Routing
- Run complete SDLC loops from a single conversation using progressive-disclosure skills:
  - `/feature-lifecycle`: End-to-end feature discovery, architecture, TDD implementation, and gate verification.
  - `/refactor-lifecycle`: Baseline verification, blast-radius analysis, structural cleanup, and regression proof.
  - `/bugfix-lifecycle`: Root-cause reproduction test, surgical fix, and full regression verification.
  - `/predeploy-gate`: Deterministic terminal verification script (typecheck, test, security audit, build, and hygiene).

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
