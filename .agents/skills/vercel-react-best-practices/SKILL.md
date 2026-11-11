---
name: vercel-react-best-practices
description: Comprehensive engineering guidelines, performance optimization, component architecture, and React/Next.js/React Native best practices from Vercel Engineering. Use when writing, refactoring, or reviewing React components, optimizing re-renders, bundle size, waterfalls, or server/client data fetching.
---

# React Engineering Knowledge Base & Agent Skills

> **Feedback Trace Invariant:** When active, ensure line 1 trace badge reflects `skill: vercel-react-best-practices`.

This document contains comprehensive engineering guidelines and agent skills for React, React Native, and Component Architecture.

## Part 1: React Best Practices
**Source:** Vercel Engineering

### 1. Eliminating Waterfalls (CRITICAL)
Waterfalls are the #1 performance killer. Each sequential await adds full network latency.
* **1.1 Defer Await Until Needed:** Move await operations into the branches where they're actually used to avoid blocking code paths that don't need them.
* **1.2 Dependency-Based Parallelization:** For operations with partial dependencies, use Promise.all patterns to maximize parallelism.
* **1.3 Prevent Waterfall Chains in API Routes:** In API routes, start independent operations immediately, even if you don't await them yet.
* **1.4 Promise.all() for Independent Operations:** Execute independent async operations concurrently: `const [user, posts] = await Promise.all([fetchUser(), fetchPosts()])`.
* **1.5 Strategic Suspense Boundaries:** Use Suspense boundaries to show wrapper UI faster while data loads, rather than blocking the whole page.

### 2. Bundle Size Optimization (CRITICAL)
* **2.1 Avoid Barrel File Imports:** Import directly from source files (e.g., `import Button from '@mui/material/Button'`) instead of barrel files (`import { Button } from '@mui/material'`).
* **2.2 Conditional Module Loading:** Load large data or modules only when a feature is activated using `import()`.
* **2.3 Defer Non-Critical Third-Party Libraries:** Load analytics and logging via `next/dynamic` after hydration.
* **2.4 Dynamic Imports for Heavy Components:** Use `next/dynamic` for heavy components (e.g., Code Editors, Maps) not needed on initial render.
* **2.5 Preload Based on User Intent:** Preload heavy bundles on hover or focus events.

### 3. Server-Side Performance (HIGH)
* **3.1 Authenticate Server Actions Like API Routes:** Always verify auth inside Server Actions (`'use server'`).
* **3.2 Avoid Duplicate Serialization in RSC Props:** Do transformations in the client to avoid sending large data twice.
* **3.3 Cross-Request LRU Caching:** Use `lru-cache` for data shared across sequential requests.
* **3.4 Minimize Serialization at RSC Boundaries:** Only pass fields the client actually uses.
* **3.5 Parallel Data Fetching with Component Composition:** Render components that fetch data as siblings rather than parent/child.
* **3.6 Per-Request Deduplication with React.cache():** Wrap authentication and DB queries with `cache()`.
* **3.7 Use after() for Non-Blocking Operations:** Schedule logging/analytics after response delivery.

### 4. Client-Side Data Fetching (MEDIUM-HIGH)
* **4.1 Deduplicate Global Event Listeners:** Use `useSWRSubscription` or a module-level Map.
* **4.2 Use Passive Event Listeners:** Add `{ passive: true }` to touch/wheel listeners.
* **4.3 Use SWR for Automatic Deduplication:** Use `useSWR` to dedup requests.
* **4.4 Version and Minimize localStorage Data:** Prefix keys with versions (`userConfig:v2`).

### 5. Re-render Optimization (MEDIUM)
* **5.1 Calculate Derived State During Rendering:** Don't sync state in `useEffect`.
* **5.2 Defer State Reads to Usage Point:** Read state imperatively if only needed in a callback.
* **5.3 Do not wrap simple expressions in useMemo:** Avoid `useMemo` for cheap primitives.
* **5.4 Extract Default Non-primitive Params:** Define default objects/arrays outside components.
* **5.5 Extract to Memoized Components:** Isolate expensive UI parts into memoized components.
* **5.6 Narrow Effect Dependencies:** Depend on primitive values instead of complex objects in `useEffect`.
* **5.7 Put Interaction Logic in Event Handlers:** Trigger side effects in event handlers, not `useEffect`.

---

## Part 2: React Composition Patterns
* **1.1 Avoid Boolean Prop Proliferation:** Avoid mode flags (`isThread`, `isEditing`). Create explicit variants (`ThreadComposer`, `EditComposer`).
* **1.2 Use Compound Components:** Structure complex components with shared context (`<Composer.Root><Composer.Input /><Composer.Submit /></Composer.Root>`).
* **2.1 Decouple State from UI:** Providers manage state; UI components consume a context interface.
* **3.1 Prefer Composing Children Over Render Props:** Use children for layout and structural composition.
* **4.1 React 19 APIs:** Use `ref` as a prop (no `forwardRef`), use `use(Context)` instead of `useContext(Context)`.

---

## Part 3: Web & UI Design Guidelines
* **Accessibility (WCAG 2.2):** Ensure proper aria-labels, semantic HTML, and 4.5:1 color contrast.
* **Focus States:** Ensure visible focus and `:focus-visible` patterns.
* **Touch Targets:** Minimum 44x44px touch targets.
