# Tasks: Frontend CI foundations (spec 004)

**Input**: Design docs from `/specs/architecture/004-frontend-ci-foundations/`  
**Prerequisites**: `spec.md` (required)

## Phase 1: Setup

- [ ] T001 Confirm FE CI scope and no-service-container constraint from `spec.md`
- [ ] T002 Confirm FE command sources in `employee-manager-fe/package.json` (`lint`, `test`, `build`)
- [ ] T003 Confirm OpenAPI source dependency path to sibling `system-specs`

## Phase 2: Workflow (US1)

- [ ] T004 Create/update `employee-manager-fe/.github/workflows/ci.yml`
- [ ] T005 Add `pull_request` and `push` (`main`) triggers
- [ ] T006 Add Bun setup and pinned version
- [ ] T007 Add checkout step for `employee-manager-fe`
- [ ] T008 Add checkout step for `system-specs` and make `../system-specs` path resolvable
- [ ] T009 Add command sequence: install, lint, test, build
- [ ] T010 Add concurrency cancellation for stale runs

## Phase 3: Documentation (US2)

- [ ] T011 Add CI section to `employee-manager-fe/README.md`
- [ ] T012 Document local parity commands
- [ ] T013 Document `system-specs` checkout/pathing behavior in CI
- [ ] T014 Document temporary fallback when pathing fails and required follow-up

## Phase 4: Validation and Handoff

- [ ] T015 Run local parity sequence in FE repo and record outcomes
- [ ] T016 Open PR and verify CI triggers automatically
- [ ] T017 Validate failure mode by seeding one temporary lint/test/build failure
- [ ] T018 Confirm merge-readiness and recommend required check enablement
