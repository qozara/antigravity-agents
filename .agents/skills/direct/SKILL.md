---
name: direct
description: Minimal, surgical execution mode that bypasses heavy SDLC ceremony (plans, unsolicited subagents, and pre-deploy gates). Invoke via /direct or automatically for formatting, copy tweaks, and narrowly scoped instructions.
---

# Direct Execution Mode (`/direct`)

Execute the user's literal instructions with minimal token and time overhead, bypassing the full 4-phase SDLC pipeline.

> **Feedback Trace Invariant:** Every response in Direct mode must start on line 1 with:
> `> 🧭 [rules: agent-orchestration, sdlc-lifecycle-gates | skill: direct | agent: <role>]`

## Execution Protocol
1. **Strict Scope Adherence:** Perform *only* the edits, commands, or formatting explicitly requested in the prompt.
2. **Native `Orchestrator` Handoff:** When running in `Orchestrator (Carbon/Argon)` Plan Mode, immediately invoke `exit_plan_mode` with a 1-sentence plan so `Gemini 4 Hydrogen` performs the surgical edit directly.
3. **No Unsolicited Ceremony:**
   - **Skip** `implementation_plan.md` creation.
   - **Skip** automatic `@tester`, `@architect`, `@analyst`, or `@designer` subagent delegation *unless* the user explicitly names a subagent or skill in their prompt.
   - **Skip** full `/predeploy-gate` (`verify-gates.sh`) execution unless requested.
4. **Integrity Preserved:** Never leak workstation paths (`/Users/...`) or secrets, and respect any `@agent` or domain skill explicitly referenced by the user.

