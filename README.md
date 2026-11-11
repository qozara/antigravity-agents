# Antigravity Global SDLC Rules, Skills, Subagents & Deterministic Guards (Qozara)

Centralized, token-optimized configuration for **Google Antigravity** (App, IDE, and CLI). Separates **always-on system invariants (Rules)** from **progressive-disclosure execution recipes (Skills/Workflows)**, delegates isolated code churn to **Flash-tier subagents**, and enforces **deterministic quality gates** via Antigravity Lifecycle Hooks (`hooks.json`) and Git `pre-push` hooks.

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
├── setup-symlinks.sh                    # Global symlink & git-hook installer
└── README.md
```

---

## 🚀 Global Installation Across All Workspaces

Run once from terminal to link rules, skills, subagents, `hooks.json`, and Git `pre-push` hooks across your workstation:

```bash
cd ~/VSCodeProjects/qozara/antigravity-agents
chmod +x setup-symlinks.sh
./setup-symlinks.sh
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
