# Feature Specification: Architectural hardening roadmap (spec 007)

**Status**: Draft  
**Scope**: Define a short hardening roadmap to reduce rework risk before broad feature parallelization.

## Objective

Address the four highest-priority architecture gaps identified after CI and auth phase-1 so feature work can proceed with stable boundaries.

## Hardening tracks

### 1) Auth trust-model transition

- Replace long-lived dependency on mock header identity with a clearly defined migration seam to real authentication.
- Keep authorization interface stable while swapping principal resolution implementation.
- Define deprecation plan for mock headers and compatibility test cases during transition.

### 2) Persistence and domain boundary for user management

- Replace placeholder `/users` behavior with a minimal durable persistence path.
- Introduce explicit repository/domain boundaries and initial schema/migration path.
- Prevent feature churn by making storage contracts stable before expanding endpoints.

### 3) Frontend application foundation

- Establish reusable auth/session boundary (shared state and transition model).
- Introduce a stable route/app-shell foundation for multi-screen feature delivery.
- Prevent endpoint-local auth logic from duplicating across new screens.

### 4) Spec and governance alignment

- Promote and align active specs with implemented behavior.
- Ensure canonical API contracts exist for protected user-management paths.
- Keep CI/docs/spec parity consistent so FE/BE and spec work stay synchronized.

## Acceptance criteria

- A documented mock-to-real auth migration seam exists and is implementation-ready.
- User-management persistence path is no longer stub-only.
- Frontend has reusable auth/session primitives suitable for guarded routes.
- Spec artifacts and CI/documentation are aligned for active feature areas.

## Out of scope

- Full real-auth provider rollout in this roadmap item.
- Advanced ABAC/ReBAC policy model expansion.
- End-to-end product feature scope beyond hardening prerequisites.
