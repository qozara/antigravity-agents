# Antigravity Agents, Workflows & Skills (Qozara)

This repository contains modular subagent personas, engineering skills, and deterministic SDLC workflows for **Google Antigravity IDE**. It pairs high-level cognitive orchestration personas with granular execution skills.

---

## 📂 Repository Structure

```
antigravity-agents/
├── .agents/
│   ├── agents/                          # Custom Agent Personas (@persona)
│   │   ├── designer.md                  # Product UX/UI Designer (Aura)
│   │   ├── analyst.md                   # Software Business Analyst (Epics & Gherkin User Stories)
│   │   ├── architect.md                 # Software Architect Agent (TDD, Diagrams, API & Task Breakdown)
│   │   ├── engineer.md                  # Software Engineer Agent (Native Antigravity TDD & Direct File Edits)
│   │   ├── engineer-webchatbot.md       # Software Engineer Agent (Hybrid Web Chatbot & PatchPilot Unified Diffs)
│   │   └── tester.md                    # Software QA/Test Engineer (Gap Analysis, Unit Specs, Breaker Tests)
│   ├── skills/                          # Progressive On-Demand Engineering Skills
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
│   └── workflows/                       # Slash-Command Workflows (/workflow)
│       └── feature-lifecycle.md         # End-to-End Chained Feature Development Lifecycle
├── setup-symlinks.sh                    # Symlink orchestrator linking to global ~/.gemini and ~/.antigravity
└── README.md
```

---

## 🚀 Global Installation (All Workspaces)

To make all skills, agent personas, and workflows globally available in Antigravity across **every project**:

```bash
cd ~/VSCodeProjects/qozara/antigravity-agents
chmod +x setup-symlinks.sh
./setup-symlinks.sh
```

This symlinks all assets into the global locations checked by Antigravity:
- **Global Skills:** `~/.gemini/antigravity/skills/` and `~/.gemini/config/skills/`
- **Global Agent Personas:** `~/.gemini/config/agents/`, `~/.gemini/antigravity/agents/`, and `~/.gemini/antigravity/subagents/`
- **Global Workflows:** `~/.gemini/config/global_workflows/` and `~/.gemini/antigravity/workflows/`
- **Root Symlink:** `~/.antigravity/agents`

---

## 🛠️ Usage in Antigravity IDE

- **Agent Personas (`@`)**: `@designer`, `@analyst`, `@architect`, `@tester`, `@engineer`
- **Workflows (`/`)**: `/feature-lifecycle`
- **Skills**: Auto-discovered progressively based on task relevance (`vercel-react-best-practices`, `typescript-pro`, `tdd-workflows-tdd-cycle`, etc.)
