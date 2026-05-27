# Feature Specification: Baseline UI POC

**Feature Branch**: `[001-baseline-app-poc]`
**Created**: 2026-05-26
**Status**: Draft
**Input**: User description: "Establish a baseline UI verifying frontend connectivity and functional developer tooling in the UI repository"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Verify baseline UI readiness (Priority: P1)

A developer wants to confirm that the frontend repository can start, render a baseline page, and verify a health contract from the configured API endpoint.

**Why this priority**: This story proves the UI repository can deliver a working baseline frontend and consume the agreed BFF/health contract before broader backend functionality is built.

**Independent Test**: Start the frontend app and verify the baseline UI loads a page that confirms connectivity status using the configured health contract.

**Acceptance Scenarios**:

1. **Given** the repository is cloned and dependencies are installed, **when** the developer starts the frontend app, **then** the baseline page loads and fetches health status from the configured API base URL.
2. **Given** the health endpoint is available, **when** the baseline page renders, **then** it displays a successful connection message and the returned health status payload.
3. **Given** the backend is unavailable, **when** the developer runs the frontend with MSW enabled, **then** the baseline page still renders and displays a successful connectivity message using the mocked `GET /health` response.

---

### User Story 2 - Verify developer tooling and workspace readiness (Priority: P2)

A developer wants to confirm that the frontend tooling works and that local setup, build, and verification commands are functional.

**Why this priority**: Reliable tooling is essential for onboarding, iterative work, and preventing environment-related blockers.

**Independent Test**: Run the documented frontend workspace commands and verify they complete successfully on a clean clone.

**Acceptance Scenarios**:

1. **Given** a fresh repository clone, **when** the developer follows the documented setup steps, **then** dependency installation completes without errors.
2. **Given** the frontend workspace is prepared, **when** the developer runs the documented start and verification commands, **then** the commands complete successfully and report readiness.
3. **Given** build artifacts exist after `bun run build:app`, **when** the developer runs `bun run clean`, **then** `dist/` and tool caches are removed while `node_modules/` and source remain.
4. **Given** a corrupted or stale dependency tree, **when** the developer runs `bun run nuke`, **then** `node_modules/` is removed, dependencies are reinstalled from `bun.lock`, and `bun test` still passes.

---

### Edge Cases

- What happens when required local dependencies are missing or the environment is not configured correctly?
- How does the UI behave when the health endpoint is unavailable or returns an error while MSW is disabled?
- How does the UI behave when MSW is enabled but a handler returns an error response for `GET /health`?
- How are failures surfaced when the frontend cannot reach the configured API base URL and MSW is not intercepting requests?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The UI repository MUST include a baseline frontend that starts and renders a baseline page.
- **FR-002**: The frontend MUST load a baseline page that verifies connectivity to a health contract endpoint via real HTTP requests.
- **FR-003**: The frontend MUST expose a health contract interface that supports successful and failed responses.
- **FR-004**: The project MUST provide documented frontend tooling commands for setup, startup, verification, and cleanup.
- **FR-008**: The frontend workspace MUST provide **`bun run clean`** (remove `dist/`, `dist-ssr/`, and Vite/TypeScript caches under `node_modules` without deleting packages) and **`bun run nuke`** (`clean`, then remove `node_modules/` and run `bun install`, keeping `bun.lock` and `.env`) via `scripts/clean.ts` and `scripts/nuke.ts` as documented in [`quickstart.md`](quickstart.md).
- **FR-005**: The baseline feature MUST include written verification guidance that a developer can follow to confirm frontend readiness.
- **FR-006**: The frontend MUST use [Mock Service Worker (MSW)](https://mswjs.io/) to intercept `GET /health` in development and tests when backend-independent UI work is required.
- **FR-007**: MSW handlers MUST return responses that match the agreed health contract shape so the UI uses the same `fetch` code path for real and mocked requests.

### Key Entities

- **Baseline UI**: The minimal frontend package representing the baseline UI experience.
- **Developer Tooling**: Workspace commands and documentation that verify environment setup, startup, and cleanup behavior (`clean`, `nuke`, build, test, lint).
- **Health API Contract**: The agreed REST/JSON contract used by the UI to verify connectivity (`GET /health`).
- **MSW mock layer**: Request handlers and browser/test worker setup that emulate the BFF health endpoint without a running backend.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer can start the frontend and reach the baseline page within 30 seconds.
- **SC-002**: The baseline page displays connectivity status successfully in at least 95% of manual verification attempts when the health contract is satisfied by the backend or by MSW handlers.
- **SC-003**: Frontend setup and verification commands run successfully on a cleaned local clone with documented results.
- **SC-004**: Documentation includes a complete verification path for both live-backend and MSW-mocked modes, and at least one reviewer can follow it without additional guidance.

## Assumptions

- This feature is scoped to the UI repository (`employee-manager-fe`) only.
- Backend integration happens through the agreed health contract; MSW is the standard approach for mocking that contract locally and in tests.
- MSW runs in the browser during development (via the MSW service worker) and in tests (via `setupServer` or equivalent).
- The baseline UI is a minimal proof of concept and is not intended to implement full business functionality.
- Local development environment expectations are standard for the project and documented clearly.
