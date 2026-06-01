# Tasks: Auth phase 1 (simple)

**Input**: Design docs from `/specs/architecture/006-auth-phase1-simple/`  
**Prerequisites**: `spec.md` (required)

## Phase 1: Authorization surface

- [ ] T001 Define principal type in `employee-manager-be/src/auth/types.ts`
- [ ] T002 Define action/resource matrix in `employee-manager-be/src/auth/policy.ts`
- [ ] T003 Add explicit deny-by-default behavior for missing principal and missing rule

## Phase 2: Backend enforcement and mock auth

- [ ] T004 Add route guard helper in `employee-manager-be/src/auth/guard.ts`
- [ ] T005 Add mock principal resolver in `employee-manager-be/src/auth/mockPrincipal.ts`
- [ ] T006 Enforce auth on critical user-management routes in `employee-manager-be/src/app.ts`
- [ ] T007 Keep health endpoint behavior unchanged in `employee-manager-be/src/app.ts`

## Phase 3: Tests

- [ ] T008 Add policy unit tests in `employee-manager-be/tests/auth.policy.test.ts`
- [ ] T009 Add route integration tests for `401/403/200/201` in `employee-manager-be/tests/auth.routes.test.ts`
- [ ] T010 Add frontend service tests for `401/403` handling in `employee-manager-fe/tests/healthApi.test.ts`

## Phase 4: Frontend UX handling

- [ ] T011 Add structured API error handling in `employee-manager-fe/src/services/healthApi.ts`
- [ ] T012 Add UI states for authentication required and forbidden in `employee-manager-fe/src/App.tsx`
- [ ] T013 Validate frontend behavior remains correct for existing success/error states
