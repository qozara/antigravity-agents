---
name: e2e-testing-patterns
description: End-to-end (E2E) and integration testing patterns using Jest, Playwright, Cypress, and Supertest. Use when writing, maintaining, or debugging automated integration test suites and breaker tests.
---

# End-to-End (E2E) & Integration Testing Patterns

> **Feedback Trace Invariant:** When active, ensure line 1 trace badge reflects `skill: e2e-testing-patterns`.

## Guidelines
1. **Realistic User Flows:** Test end-to-end critical paths (login $\rightarrow$ action $\rightarrow$ confirmation) using stable page object patterns and data attributes (`data-testid`).
2. **Deterministic Isolation:** Ensure tests run against isolated state/databases with automatic teardown and seeding.
3. **Breaker Tests:** Author negative scenario tests validating graceful degradation on network timeouts, malformed payloads, and 500 errors.
