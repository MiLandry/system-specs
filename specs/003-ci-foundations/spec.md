# Feature Specification: CI foundations (spec 003)

**Feature Branch**: `003-ci-foundations`  
**Created**: 2026-05-28  
**Status**: Draft  
**Input**: User description: "Introduce a minimal CI baseline for one repo first, no service containers"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Backend PR quality gate (Priority: P1)

As a backend contributor, I need automated checks on pull requests so regressions in types, tests, or build output are caught before merge.

**Why this priority**: This is the smallest high-value CI slice and prevents most accidental breakages with existing commands.

**Independent Test**: Open a PR in `employee-manager-be` and verify CI runs install, typecheck, tests, and build; intentionally break one step and confirm the workflow fails.

**Acceptance Scenarios**:

1. **Given** a pull request targeting `main` in `employee-manager-be`, **When** CI starts, **Then** it runs dependency install, typecheck, tests, and build in a single workflow.
2. **Given** a pull request where `bun run typecheck` fails, **When** CI executes, **Then** the workflow is marked failed and the PR shows a failed status check.
3. **Given** a pull request where all checks pass, **When** CI completes, **Then** the PR shows a successful status check suitable for merge policy use.

---

### User Story 2 - Main branch confidence (Priority: P2)

As a maintainer, I need CI to run on pushes to `main` so the default branch always reflects a healthy build and test baseline.

**Why this priority**: PR checks are primary, but push validation is needed to confirm branch health after merges and direct maintenance changes.

**Independent Test**: Push a non-breaking commit to `main` and verify CI completes successfully with the same commands used for PRs.

**Acceptance Scenarios**:

1. **Given** a commit pushed to `main`, **When** the workflow triggers, **Then** it runs the same install/typecheck/test/build sequence as PR runs.
2. **Given** a commit that breaks tests, **When** CI runs on `main`, **Then** the run fails and surfaces test output in logs.

---

### User Story 3 - Contributor command parity (Priority: P3)

As a contributor, I need clear documentation of what CI runs so I can reproduce failures locally before pushing.

**Why this priority**: Reduces CI churn and review friction by making expected checks explicit in repository docs.

**Independent Test**: Follow the README CI section commands locally and confirm they match workflow behavior.

**Acceptance Scenarios**:

1. **Given** a contributor reading `employee-manager-be/README.md`, **When** they open the CI section, **Then** they see the exact command sequence used by CI.
2. **Given** a local failure in one of those commands, **When** the contributor fixes it and reruns, **Then** they can reasonably expect CI to pass for the same changes.

---

### Edge Cases

- What happens when dependency installation fails due to lockfile drift or missing lockfile updates? CI must fail at install with clear logs.
- What happens when multiple commits are pushed quickly to the same PR? Prior run should be canceled by concurrency to avoid stale statuses.
- How does CI behave if workflow files are changed in a PR? The changed workflow should be evaluated and still enforce the required command sequence.
- What happens if `main` is renamed later? Trigger configuration must be updated as follow-up and documented in repo governance.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide a GitHub Actions workflow in `employee-manager-be` that runs on `pull_request` events.
- **FR-002**: The system MUST run the same workflow on pushes to `main`.
- **FR-003**: The workflow MUST run this command sequence: `bun install --frozen-lockfile`, `bun run typecheck`, `bun test`, `bun run build`.
- **FR-004**: The workflow MUST fail when any step in the required sequence exits non-zero.
- **FR-005**: The workflow MUST pin a Bun version to reduce environment drift between runs.
- **FR-006**: The workflow MUST enable concurrency cancellation for superseded runs on the same ref.
- **FR-007**: Repository documentation MUST describe CI scope and local command parity.
- **FR-008**: The feature MUST NOT require service containers or external runtime services for CI execution in this spec.
- **FR-009**: The feature MUST be scoped to `employee-manager-be` only; frontend CI remains out of scope.

### Key Entities *(include if feature involves data)*

- **CI Workflow Definition**: Versioned YAML configuration that defines triggers, runtime, and required quality commands.
- **CI Run Result**: Pass/fail status with logs for each required command step.
- **Required Check Policy (Deferred Consumer)**: Branch protection configuration that can consume CI status after workflow stabilization.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of new PRs to `employee-manager-be` trigger the CI workflow automatically.
- **SC-002**: The `main` branch receives a CI run for every push event.
- **SC-003**: A seeded failure in typecheck, tests, or build reliably causes CI failure in the corresponding step.
- **SC-004**: Contributors can execute the documented local parity commands and reproduce CI outcomes without additional infrastructure.

## Assumptions

- GitHub Actions is the CI platform for this repository.
- Backend tests remain infrastructure-independent for this phase (no required Postgres service in CI).
- Existing Bun scripts in `employee-manager-be/package.json` remain the source of truth for typecheck/test/build behaviors.
- Branch protection and required-check enforcement are configured outside this spec or in a follow-on governance task.

## Out of Scope

- `employee-manager-fe` CI implementation.
- OpenAPI contract lint/codegen automation across sibling repos.
- Service containers (Postgres) and DB-backed integration test jobs.
- Release, deployment, environment promotion, and rollback automation.
