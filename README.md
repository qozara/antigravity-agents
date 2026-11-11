# Antigravity Global SDLC Rules, Skills, Subagents & Deterministic Guards

Centralized, token-optimized configuration for **Google Antigravity** (App, IDE, and CLI), fully aligned with **November 2026** frontier foundation models and agent harness best practices.

It separates **always-on system invariants (Rules)** from **progressive-disclosure execution recipes (Skills/Workflows)**, delegates context-heavy code churn to **Flash-tier subagents (Gemini 3.8 Flash)** while pinning the primary orchestrator to **Frontier Reasoning models (Gemini 4 Carbon / Gemini 4 Argon)**, and enforces **deterministic quality gates** via Antigravity Lifecycle Hooks (`hooks.json`) and Git `pre-push` hooks.

---

## 🧠 November 2026 Model Architecture & Tiering

| Tier / Role | Model Selection | Frontmatter Config | Execution Purpose |
| :--- | :--- | :--- | :--- |
| **Primary Orchestrator** | **Gemini 4 Carbon** (High thinking) or **Gemini 4 Argon** (Medium thinking) | Active session / `/plan` | Formulates architecture, plans, blast-radius boundaries, quality gate verifications, and PR reviews. |
| **System Architect** (`@architect`) | **Frontier Tier** (Gemini 4 Carbon / Argon) | `model: pro` | Complex schema design (zod/RxDB/SQL), API contracts, Mermaid sequence/C4 diagrams, and ADR authoring. |
| **TDD Engineer** (`@engineer`) | **Gemini 3.8 Flash** | `model: flash` | Single-pass TDD (Red-Green-Refactor), surgical file edits, component scaffolding, and lint/type error fixes. |
| **QA / SDET** (`@tester`) | **Gemini 3.8 Flash** | `model: flash` | Unit test specification tables, gap analysis, failing reproduction tests, and automated integration/E2E test suites. |
| **Business Analyst** (`@analyst`) | **Gemini 3.8 Flash** | `model: flash` | Scope boundaries, Non-Functional Requirements (NFRs), and Gherkin acceptance criteria (`Given/When/Then`). |
| **UI/UX Designer** (`@designer`) | **Gemini 3.8 Flash** | `model: flash` | User flows (Mermaid.js), component wireframe specifications, and WCAG 2.2 accessibility verification. |

### 🚀 Escalation Modes (On-Demand Multi-Agent Reasoning)
- **`/boost` (Deep Reasoning Pipeline):** For tough engineering problems requiring iterative multi-round verification:
  - Concurrency bugs, race conditions, deadlocks, and thread synchronization issues.
  - Complex algorithmic optimization (SIMD, graph traversals, data structures).
  - Deep root-cause investigation across unfamiliar, multi-module execution paths.
  - Non-trivial multi-file refactoring with high regression risk.
- **`/swarm` (Shared-Board Coordination):** Coordinates parallel worker agents communicating via a shared message board with `@mentions`.
- **`/teamwork` (Long-Horizon Campaigns):** Multi-role collaborative agent teams for long-horizon multi-day campaigns.

> **Model Lifecycle Note:** Claude 4.6 and GPT-OSS-120b are sunsetting in mid-November 2026. For Claude-based sessions, use Claude Opus 5.5 (Thinking) or Claude Sonnet 5.5 (Thinking).

---

## 📂 Repository Architecture

```
antigravity-agents/
├── .agents/
│   ├── rules/                           # Always-On Global Invariants (~/.gemini/config/rules/)
│   │   ├── sdlc-lifecycle-gates.md      # Mandatory 4-phase SDLC gates & strict anti-slop invariants
│   │   └── agent-orchestration.md       # Single-conversation orchestration & Flash subagent routing
│   ├── agents/                          # Custom Subagents (~/.gemini/config/agents/)
│   │   ├── architect.md                 # System Architect [model: pro] — Schemas, Contracts, ADRs
│   │   ├── engineer.md                  # TDD Engineer [model: flash] — Red-Green-Refactor & Edits
│   │   ├── tester.md                    # QA / SDET [model: flash] — Breaker Specs & Test Suites
│   │   ├── analyst.md                   # Business Analyst [model: flash] — Scope, NFRs, Gherkin
│   │   └── designer.md                  # UX/UI Designer [model: flash] — Flows, Wireframes, WCAG 2.2
│   ├── skills/                          # Progressive-Disclosure Skills & Slash Commands (/skill)
│   │   ├── feature-lifecycle/SKILL.md   # /feature-lifecycle — Single-conversation Feature SDLC
│   │   ├── refactor-lifecycle/SKILL.md  # /refactor-lifecycle — Single-conversation Refactoring SDLC
│   │   ├── bugfix-lifecycle/SKILL.md    # /bugfix-lifecycle — Single-conversation Bug-Fix SDLC
│   │   ├── predeploy-gate/              # /predeploy-gate — Deterministic Gate Runner + Script
│   │   │   ├── SKILL.md
│   │   │   └── scripts/verify-gates.sh  # Auto-detects typecheck, lint, test, npm audit, build
│   │   ├── c4-architecture-c4-architecture/SKILL.md
│   │   ├── codebase-cleanup-tech-debt/SKILL.md
│   │   ├── e2e-testing-patterns/SKILL.md
│   │   ├── frontend-mobile-development-component-scaffold/SKILL.md
│   │   ├── react-modernization/SKILL.md
│   │   ├── security-auditor/SKILL.md
│   │   ├── security-scanning-security-hardening/SKILL.md
│   │   ├── tdd-workflows-tdd-cycle/SKILL.md
│   │   ├── typescript-pro/SKILL.md
│   │   └── vercel-react-best-practices/SKILL.md
│   ├── workflows/                       # Backward-Compatible Workflow Wrappers
│   │   ├── feature-lifecycle.md
│   │   ├── refactor-lifecycle.md
│   │   └── bugfix-lifecycle.md
│   ├── scripts/                         # Deterministic Hook Scripts
│   │   ├── pre-tool-guard.sh            # Antigravity PreToolUse hook blocking main pushes & running gates
│   │   └── git-pre-push.sh              # Git .git/hooks/pre-push deterministic gate wrapper
│   └── hooks.json                       # Antigravity Lifecycle Hooks configuration
├── setup-symlinks.sh                    # Portable global symlink & git-hook installer
├── .gitignore                           # Git ignore rules for OS, temporary, and sensitive files
└── README.md
```

---

## 🚀 Replicable Setup on Any Computer

This setup is fully portable and uses dynamic `$HOME` resolution without hardcoded paths or personal credentials.

### 1. Clone & Bootstrap
```bash
git clone https://github.com/qozara/antigravity-agents.git
cd antigravity-agents
chmod +x setup-symlinks.sh
./setup-symlinks.sh
```

### 2. Options & Custom Projects Directory
By default, the script links Git pre-push hooks into all repositories located in the sibling folder. To specify a custom projects directory:
```bash
./setup-symlinks.sh --projects-dir ~/my-projects
```

To remove global symlinks:
```bash
./setup-symlinks.sh --clean-global
```

---

## 💬 Single-Conversation Trigger Prompts

Because global rules (`sdlc-lifecycle-gates.md` and `agent-orchestration.md`) are `always_on` and lifecycle skills are exposed as `/` slash commands, you can trigger any full SDLC loop from a single prompt:

- **New Feature:**
  > `/feature-lifecycle Implement [feature description]. Orchestrate planning (/plan), delegate TDD specs and implementation to @tester and @engineer, run /predeploy-gate, update docs/i18n, and prepare the feature branch.`

- **Refactoring / Tech Debt:**
  > `/refactor-lifecycle Refactor [module/component]. Verify baseline tests first, map blast radius in /plan, delegate atomic transformations to @engineer, and verify zero regressions with /predeploy-gate.`

- **Bug Fix:**
  > `/bugfix-lifecycle Fix [issue/bug description]. Isolate root cause, write a failing reproduction test first via @tester/@engineer, apply the minimal surgical fix, and verify all checks with /predeploy-gate.`

---

## 🧭 Continuous Configuration Proof: Response Feedback Trace

To instantly detect Antigravity setup misconfigurations (such as unlinked rules, unregistered skills, or misrouted subagents) across all workspaces without consuming excessive tokens, **every agent response starts on line 1 with a single-line trace badge**:

```markdown
> 🧭 [rules: <active_rules> | skill: <active_skill|none> | agent: <role>]
```

### Examples & Traceability Matrix

| Prompt Scenario | Line 1 Feedback Trace Badge | Repo Reference |
| :--- | :--- | :--- |
| **Standard Prompt / Q&A** | `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates \| skill: none \| agent: orchestrator]` | `.agents/rules/` |
| **Feature Delivery (`/feature-lifecycle`)** | `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates \| skill: feature-lifecycle \| agent: orchestrator]` | `.agents/skills/feature-lifecycle/` |
| **Refactoring (`/refactor-lifecycle`)** | `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates \| skill: refactor-lifecycle \| agent: orchestrator]` | `.agents/skills/refactor-lifecycle/` |
| **Bug Fix (`/bugfix-lifecycle`)** | `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates \| skill: bugfix-lifecycle \| agent: orchestrator]` | `.agents/skills/bugfix-lifecycle/` |
| **TDD Subagent (`@engineer`)** | `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates \| skill: tdd-workflows-tdd-cycle \| agent: engineer]` | `.agents/agents/engineer.md` |
| **Architecture Subagent (`@architect`)** | `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates \| skill: c4-architecture-c4-architecture \| agent: architect]` | `.agents/agents/architect.md` |
| **QA / Breaker Subagent (`@tester`)** | `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates \| skill: e2e-testing-patterns \| agent: tester]` | `.agents/agents/tester.md` |
| **Pre-Deploy Gate (`/predeploy-gate`)** | `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates \| skill: predeploy-gate \| agent: orchestrator]` | `.agents/skills/predeploy-gate/` |

### 🔍 Misconfiguration Diagnosis Guide

- **Badge Missing entirely:** Antigravity global rules are not active. Check that `./setup-symlinks.sh` was executed and that `~/.gemini/config/rules/` contains the linked rules.
- **`skill: none` when invoking a workflow:** The skill was not recognized by Antigravity. Check that `~/.gemini/config/skills/<skill-name>` symlink is intact.
- **Unexpected `agent:` name:** Persona routing or delegation did not occur as expected (e.g. running inline on orchestrator instead of subagent).

---

## 🔒 Privacy & Public Distribution Invariants

This repository is built for public distribution on GitHub with strict data hygiene:
- **Zero Workstation Path Leakage:** Enforced by Gate 2 in `verify-gates.sh`. No hardcoded `/Users/...` or user-specific paths are tracked.
- **Zero Credentials / Tokens:** No API keys, credentials, or `.env` files are included or tracked.
- **Clean Git Tracking:** Root `.gitignore` prevents OS metadata (`.DS_Store`), backup files (`*.bak`), and test databases from being committed.
