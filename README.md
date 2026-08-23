# Antigravity Agents & Workflows (Qozara)

This repository contains the modular subagent definitions, engineering skills, and chained SDLC workflows tailored for Google Antigravity IDE and multi-agent development.

---

## 📂 Repository Structure

```
antigravity-agents/
├── .agents/
│   ├── subagents/
│   │   ├── designer.md       # Product UX/UI Designer (Aura)
│   │   ├── analyst.md        # Software Business Analyst (Epics & Gherkin User Stories)
│   │   ├── architect.md      # Software Architect Agent (TDD, Diagrams, API & Task Breakdown)
│   │   ├── engineer.md       # Software Engineer Agent (TDD & PatchPilot Unified Diff)
│   │   └── tester.md         # Software QA/Test Engineer (Gap Analysis, Unit Specs, Breaker Tests)
│   ├── skills/
│   │   └── vercel-react-best-practices.md # React, React Native, & Composition Guidelines
│   └── workflows/
│       └── feature-lifecycle.md  # End-to-End Chained Feature Development Lifecycle
├── setup-symlinks.sh         # Global installation script for ~/.antigravity/agents
└── README.md
```

---

## 🤖 Subagent Overview

| Subagent | Role & Objective | Primary Artifacts |
| :--- | :--- | :--- |
| **`designer`** | User-Centric Design Strategist & UI Architect | Wireframes, User Flows (Mermaid), WCAG 2.2 Checks |
| **`analyst`** | Senior Technical Business Analyst | Epics, KPIs, Gherkin User Stories (`US-xxx`) |
| **`architect`** | Principal Software Architect & Tech Lead | TDD, Mermaid Sequence Diagrams, API Specs, Task Breakdown |
| **`tester`** | Hostile Senior QA / SDET Engineer | Gap Analysis, Unit Test Specs Table, Integration/E2E Tests |
| **`engineer`** | Autonomous Software Engineer | Atomic Unified Diffs (`PatchPilot`), Unit Test Implementations |

---

## 🔄 Chained Workflow: Feature Lifecycle

The `.agents/workflows/feature-lifecycle.md` chains these agents into a deterministic development loop:
1. **UX/UI Discovery** (`designer`): Wireframe specs and interaction logic.
2. **Requirements Definition** (`analyst`): Formal Epics and User Stories.
3. **Architecture Blueprint** (`architect`): System design, API contracts, schema migrations, and tasks.
4. **Shift-Left QA** (`tester`): Security audit, gap analysis, and Unit Test specification tables.
5. **TDD Implementation** (`engineer`): Red-Green-Refactor with PatchPilot Unified Diffs.
6. **Verification** (`tester`): Automated regression and integration suite execution.

---

## 🚀 Global Installation for Antigravity

To expose these agents and workflows globally across all workspaces in Antigravity:

```bash
chmod +x setup-symlinks.sh
./setup-symlinks.sh
```

This creates or updates the symlink at `~/.antigravity/agents`.
