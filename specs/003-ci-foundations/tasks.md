# Tasks: CI foundations (spec 003)

**Input**: Design documents from `/specs/003-ci-foundations/`  
**Prerequisites**: `spec.md` (required)

**Tests**: CI validation tasks are included because this feature is about automated checks and quality gating.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no direct dependency)
- **[Story]**: User story label from `spec.md` (`US1`, `US2`, `US3`)
- Include exact file paths in each task description

---

## Phase 1: Setup (Shared Foundations)

**Purpose**: Establish scope and baseline workflow conventions.

- [ ] T001 Confirm backend-only scope and out-of-scope items in `/specs/003-ci-foundations/spec.md`
- [ ] T002 Review existing backend scripts in `employee-manager-be/package.json` (`typecheck`, `test`, `build`)
- [ ] T003 Define pinned Bun runtime version for CI workflow in `employee-manager-be/.github/workflows/ci.yml`

**Checkpoint**: CI scope and command source-of-truth are established.

---

## Phase 2: User Story 1 - Backend PR quality gate (Priority: P1) 🎯 MVP

**Goal**: Ensure every backend PR gets automated install/typecheck/test/build validation.

**Independent Test**: Open a PR and verify workflow runs and reports pass/fail based on command outcomes.

### Implementation for User Story 1

- [ ] T004 [US1] Create/update backend workflow in `employee-manager-be/.github/workflows/ci.yml`
- [ ] T005 [US1] Add `pull_request` trigger targeting backend PR flow in `employee-manager-be/.github/workflows/ci.yml`
- [ ] T006 [US1] Add required CI steps (`bun install --frozen-lockfile`, `bun run typecheck`, `bun test`, `bun run build`) in `employee-manager-be/.github/workflows/ci.yml`
- [ ] T007 [US1] Add concurrency cancellation to avoid stale PR runs in `employee-manager-be/.github/workflows/ci.yml`

### Validation for User Story 1

- [ ] T008 [US1] Run local parity command sequence in `employee-manager-be` and capture expected outcomes
- [ ] T009 [US1] Open PR from feature branch and verify workflow starts automatically
- [ ] T010 [US1] Seed temporary failure (typecheck or test) and confirm PR check fails with clear logs

**Checkpoint**: PR checks gate backend changes with deterministic pass/fail status.

---

## Phase 3: User Story 2 - Main branch confidence (Priority: P2)

**Goal**: Ensure pushes to `main` also run CI so default branch health is continuously verified.

**Independent Test**: Merge a passing PR and verify a push-to-main run starts and succeeds.

### Implementation for User Story 2

- [ ] T011 [US2] Add `push` trigger for `main` in `employee-manager-be/.github/workflows/ci.yml`
- [ ] T012 [US2] Ensure push-to-main uses same command sequence as PR runs in `employee-manager-be/.github/workflows/ci.yml`

### Validation for User Story 2

- [ ] T013 [US2] Merge a green PR and confirm a new CI run appears for `main`
- [ ] T014 [US2] Confirm command steps and outcomes match PR run behavior

**Checkpoint**: `main` branch has automated health verification on each push.

---

## Phase 4: User Story 3 - Contributor command parity docs (Priority: P3)

**Goal**: Document CI behavior and exact local parity commands for contributors.

**Independent Test**: A contributor can run README CI commands locally and reproduce CI results.

### Implementation for User Story 3

- [ ] T015 [US3] Add CI section to `employee-manager-be/README.md` with workflow scope and trigger summary
- [ ] T016 [US3] Document exact command parity sequence in `employee-manager-be/README.md`
- [ ] T017 [US3] Document deferred items (frontend CI, service containers) in `employee-manager-be/README.md`

### Validation for User Story 3

- [ ] T018 [US3] Verify README commands execute successfully on current backend branch
- [ ] T019 [US3] Peer-check docs clarity: contributor can explain what CI runs without reading workflow YAML

**Checkpoint**: README provides clear and accurate CI/local parity guidance.

---

## Phase 5: Polish & Governance Handoff

**Purpose**: Final verification and handoff for repository policy adoption.

- [ ] T020 [P] Verify workflow file formatting and readability in `employee-manager-be/.github/workflows/ci.yml`
- [ ] T021 [P] Confirm documentation consistency between `employee-manager-be/README.md` and `/specs/003-ci-foundations/spec.md`
- [ ] T022 Prepare branch protection recommendation: add backend CI workflow as required status check (repo settings)
- [ ] T023 Record follow-up scope for next specs: frontend CI and optional service container integration jobs

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: start immediately.
- **Phase 2 (US1, P1)**: depends on Phase 1.
- **Phase 3 (US2, P2)**: depends on US1 workflow being in place.
- **Phase 4 (US3, P3)**: can proceed after workflow commands are finalized.
- **Phase 5 (Polish)**: final pass after target user stories complete.

### User Story Dependencies

- **US1 (P1)**: foundational, no dependency on other stories.
- **US2 (P2)**: depends on US1 workflow shape.
- **US3 (P3)**: depends on final command sequence from US1/US2.

### Parallel Opportunities

- T001-T003 can be completed in parallel.
- T020 and T021 can run in parallel during polish.
- Validation tasks can be split between workflow behavior checks and docs review.

---

## MVP Recommendation

Deliver **US1 only** first (Phase 2) for immediate PR gating value. Add US2 and US3 in sequence for full branch health confidence and contributor clarity.
