---
name: typescript-pro
description: Advanced TypeScript engineering patterns, strict typing, generics, utility types, type narrowing, and runtime validation. Use when writing, refactoring, or reviewing TypeScript code, resolving complex type errors, or designing typed API contracts.
---

# Advanced TypeScript Engineering (TypeScript Pro)

> **Feedback Trace Invariant:** When active, ensure line 1 trace badge reflects `skill: typescript-pro`.

## Core Directives
1. **Strict Type Safety:** Avoid `any` and `unknown` casts unless accompanied by runtime type guards or zod/valibot schemas.
2. **Generics & Constraints:** Constrain generics (`<T extends Record<string, unknown>>`) rather than using loose open types.
3. **Discriminated Unions:** Always model state transitions and domain entities with tagged discriminated unions for exhaustive switch/case checking.
4. **Type Narrowing & Predicates:** Use custom type predicates (`val is TargetType`) for runtime validation.
5. **Immutability:** Use `readonly` arrays, `as const`, and `Readonly<T>` for configurations and immutable state.
