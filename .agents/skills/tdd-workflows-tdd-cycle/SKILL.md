---
name: tdd-workflows-tdd-cycle
description: Test-Driven Development (TDD) execution cycle (Red, Green, Refactor). Use when implementing features or bug fixes following strict test-first workflows, writing failing unit tests before code, and verifying regression test suites.
---

# Test-Driven Development (TDD) Cycle

## The Three Phases
1. **Red (Write Failing Tests First):**
   - Ingest requirements or QA Unit Test Specifications table.
   - Write isolated unit tests asserting the desired behavior.
   - Execute the test suite to verify tests fail for the right reason.
2. **Green (Minimal Implementation):**
   - Write the simplest code that makes the tests pass.
   - Avoid premature optimization or speculative generalities.
   - Re-run test suite until all assertions are green.
3. **Refactor (Clean & Optimize):**
   - Clean up code duplication, improve variable naming, and enforce architectural standards.
   - Ensure 100% of unit and regression tests remain green throughout refactoring.
