# Feature Specification: Auth phase 1 (simple)

**Status**: Draft  
**Scope**: Implement authorization-first controls with mocked authentication to secure critical user-management paths without introducing a real auth provider.

## Goals

1. Enforce route-level authorization with deny-by-default behavior.
2. Define a minimal principal interface that can be reused when real auth is added.
3. Ship explicit `401` vs `403` behavior across backend and frontend.

## Behavior

### Principal contract

- Backend defines a minimal principal:
  - `userId`
  - `roles[]`
  - optional `tenantId`
- Initial roles:
  - `admin`
  - `manager`
  - `viewer`

### Authorization policy

- Central policy API evaluates `authorize(principal, action, resource)`.
- Policy is deny-by-default:
  - missing principal -> `401`
  - missing rule or disallowed role -> `403`
- Initial resource/action scope:
  - `users.read` allowed: `admin`, `manager`
  - `users.create` allowed: `admin`

### Mock authentication

- Mock resolver reads principal data from request headers in dev/test.
- No real login, token validation, refresh, or IdP integration in this phase.

### API behavior

- Protected user-management routes enforce policy before handler logic.
- `GET /health` behavior remains unchanged for baseline connectivity checks.

### Frontend behavior

- Frontend distinguishes authorization failures:
  - `401` -> authentication required state
  - `403` -> forbidden state
- Other failures remain generic error state.

## Acceptance Criteria

- Policy unit tests cover allow/deny matrix and default-deny fallback.
- Route tests confirm:
  - missing principal -> `401`
  - disallowed role -> `403`
  - allowed role -> success
- Frontend service/UI can surface distinct `401` and `403` messaging.

## Out of scope (separate features)

- Real authentication provider integration.
- Session/token lifecycle management.
- Advanced ABAC/ReBAC policy composition.
- Organization-wide role administration UX.
