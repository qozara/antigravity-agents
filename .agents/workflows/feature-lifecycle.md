# Feature Lifecycle Workflow: End-to-End Agentic SDLC

This workflow defines the chained execution lifecycle for developing features in Antigravity using specialized subagents: **UX Designer**, **Business Analyst**, **Software Architect**, **QA/Test Engineer**, and **Software Engineer**.

---

## Workflow Overview

```mermaid
flowchart TD
    A[Feature Idea / Raw Intent] --> B[1. UX Designer: Aura]
    B -->|Wireframes, UX Specs, Flows| C[2. Business Analyst]
    C -->|Epic & Gherkin User Stories| D[3. Software Architect]
    D -->|TDD, Schema, API Contracts, Tasks| E[4. QA / SDET Engineer]
    E -->|Gap Analysis & Unit Test Specs| F[5. Software Engineer]
    E -->|Automated E2E / Integration Specs| G[Test Suite Repository]
    F -->|Unified Git Patch & Unit Tests| H[Patch Application & Build]
    H --> I[6. QA & Regression Verification]
    I -->|Pass| J[Feature Completed & Merged]
    I -->|Fail| F
```

---

## Step-by-Step Chained Protocol

### Stage 1: UX/UI Discovery & Information Architecture
* **Agent:** `designer` (`.agents/subagents/designer.md`)
* **Input:** High-level feature concept or raw user requirement.
* **Process:** 
  * Inquires regarding user personas and primary problem statements.
  * Formulates Information Architecture, user flows (Mermaid), and UI layout wireframes.
  * Adds WCAG 2.2 accessibility checks and UX interaction constraints.
* **Output Artifacts:** 
  * Low-fidelity text wireframe specification.
  * UI state and interaction logic.

---

### Stage 2: Formal Requirements & Business Analysis
* **Agent:** `analyst` (`.agents/subagents/analyst.md`)
* **Input:** Designer's wireframes + User's business objectives.
* **Process:**
  * Validates scope boundaries (In-Scope vs. Out-of-Scope).
  * Defines Non-Functional Requirements (NFRs: scale, latency, security, compatibility).
  * Formulates Epic and granular User Stories with Gherkin syntax (`Given/When/Then`).
* **Output Artifacts:**
  * Formatted Epic document with KPIs.
  * Granular User Stories (`US-xxx`) with acceptance criteria and dev notes.

---

### Stage 3: Technical Blueprint & System Architecture
* **Agent:** `architect` (`.agents/subagents/architect.md`)
* **Input:** Epic and User Stories from the Business Analyst.
* **Process:**
  * Evaluates architectural feasibility, security trade-offs (OWASP), and data consistency.
  * Produces Mermaid.js sequence and component diagrams.
  * Defines data persistence schema changes (SQL/NoSQL/Migrations) and caching strategies.
  * Specifies API contracts (Endpoints, request/response JSON schemas, auth scopes).
  * Deconstructs the architecture into developer-assignable task tickets.
* **Output Artifacts:**
  * Technical Design Document (`TDD`).
  * Initialized / updated `IMPLEMENTATION_PLAN.md`.
  * Architectural Decision Records (`docs/adr/`).

---

### Stage 4: "Shift-Left" QA & Test Specification
* **Agent:** `tester` (`.agents/subagents/tester.md`)
* **Input:** Architecture Blueprint, `IMPLEMENTATION_PLAN.md`, and User Stories.
* **Process:**
  * **Destructive Gap Analysis:** Identifies logic flaws, missing error handlers, edge cases, and security vulnerabilities.
  * **Unit Test Specifications:** Produces a strict input/output mapping table for dev implementation.
  * **E2E & Integration Tests:** Authors runnable test suites (e.g., Jest, Supertest, Cypress, Playwright).
* **Output Artifacts:**
  * Unit Test Specifications table (handed off to Engineer).
  * Test files in `tests/integration/` or `tests/e2e/`.

---

### Stage 5: TDD Implementation & Patch Generation
* **Agent:** `engineer` (`.agents/subagents/engineer.md`)
* **Input:** Architect's Task Breakdown + QA's Unit Test Specifications table.
* **Process:**
  * **System 2 Mental Sandbox:** Analyzes blast radius, edge cases, and regression risks.
  * **Red-Green-Refactor:** Writes the unit tests matching QA specifications *before* writing business logic.
  * Implements minimal, clean, self-descriptive code satisfying all test cases.
  * Adheres to the *React & Engineering Best Practices* (`.agents/skills/vercel-react-best-practices.md`).
  * Emits code strictly via the **PatchPilot Unified Diff Protocol**.
* **Output Artifacts:**
  * Single atomic Git Unified Diff patch.
  * Updates to `IMPLEMENTATION_PLAN.md` checklist.

---

### Stage 6: Automated Verification & Review
* **Agent:** `tester` + Local Test Runner
* **Process:**
  * Applies diff patch and executes unit, integration, and regression suites.
  * Validates that all blast-radius components remain functional.
  * If tests fail or regressions occur, the loop returns to Stage 5 with specific failure traces.
