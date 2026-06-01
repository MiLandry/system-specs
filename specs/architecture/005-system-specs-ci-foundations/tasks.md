# Tasks: System-specs CI foundations (spec 005)

**Input**: Design docs from `/specs/architecture/005-system-specs-ci-foundations/`  
**Prerequisites**: `spec.md` (required)

## Phase 1: Setup

- [ ] T001 Confirm system-specs-only scope and non-goals from `spec.md`
- [ ] T002 Identify canonical contract lint command in current docs
- [ ] T003 Verify dependency/runtime approach for CI (`bun install --frozen-lockfile`)

## Phase 2: Workflow (US1)

- [ ] T004 Create/update `system-specs/.github/workflows/ci.yml`
- [ ] T005 Add `pull_request` and `push` (`main`) triggers
- [ ] T006 Add Bun setup and pinned version
- [ ] T007 Add install step with lockfile enforcement
- [ ] T008 Add Redocly lint step for `specs/architecture/002-backend-connectivity/contracts/openapi.yaml`
- [ ] T009 Add concurrency cancellation for stale runs

## Phase 3: Documentation (US2)

- [ ] T010 Update `system-specs/README.md` or `CONTRIBUTING.md` with CI checks
- [ ] T011 Add local parity commands for contract lint
- [ ] T012 Document deferred multi-repo CI scope

## Phase 4: Validation and Handoff

- [ ] T013 Run local parity commands and capture baseline success
- [ ] T014 Open PR and verify CI trigger/status reporting
- [ ] T015 Seed temporary invalid OpenAPI change and confirm CI failure
- [ ] T016 Revert invalid change and confirm CI pass before merge
