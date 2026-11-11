---
trigger: always_on
description: "Single-conversation orchestration protocol and token-saving subagent delegation rules."
---

# Orchestration & Token-Efficiency Protocol

Operate as a high-leverage orchestrator in the primary conversation while minimizing context bloat and token consumption.

## 1. Single-Conversation Workflow Routing
- Run complete SDLC loops from a single conversation using progressive-disclosure skills:
  - `/feature-lifecycle`: End-to-end feature discovery, architecture, TDD implementation, and gate verification.
  - `/refactor-lifecycle`: Baseline verification, blast-radius analysis, structural cleanup, and regression proof.
  - `/bugfix-lifecycle`: Root-cause reproduction test, surgical fix, and full regression verification.
  - `/predeploy-gate`: Deterministic terminal verification script (typecheck, test, security audit, build, and hygiene).

## 2. Subagent Delegation & Model Tiering
- **Keep the Main Context Clean:** Maintain overall task state, architectural boundaries, and final quality gate verification in the primary session (`pro` / frontier tier).
- **Delegate Code Churn to Flash Workers:** Spawn specialized subagents (`invoke_subagent`) or multi-agent modes (`/teamwork`, `/swarm`, `/boost`) for context-heavy subtasks:
  - `research` (built-in): Codebase exploration, dependency tracing, and file discovery across large modules.
  - `@architect` (`pro`): Complex schema design, API contract modeling, and ADR authoring (skip for trivial edits).
  - `@tester` (`flash`): Destructive gap analysis, unit test specification tables, and integration/E2E test authoring.
  - `@engineer` (`flash`): Red-Green-Refactor TDD implementation, component scaffolding, and lint/type error fixes.
  - `@designer` / `@analyst` (`flash`): Invoke only when a feature introduces new UI screens, user flows, or ambiguous business scope.
- **Parallel Dispatch:** When subtasks touch independent packages or files, invoke subagents concurrently in a single turn rather than sequentially.

## 3. Context & Token Optimization Rules
- **Progressive Disclosure:** Do not inline lengthy style guides or framework manuals into rules. Load specialized skills (`typescript-pro`, `vercel-react-best-practices`, `security-auditor`, `e2e-testing-patterns`) only when the task touches those domains.
- **Black-Box Script Execution:** When running verification or helper scripts bundled in skills, execute the script directly and inspect only exit codes and concise failure output rather than reading full script source files into context.
- **Surgical Reads & Edits:** Use `grep_search` and line-bounded `view_file` (`StartLine`/`EndLine`) instead of reading entire large files, and apply targeted `replace_file_content` / `multi_replace_file_content` edits.
