# Feature Specification: DX Tooling Improvements

**Feature Branch**: `002-dx-tooling-improvements`
**Created**: 2026-05-25
**Status**: Draft
**Input**: User description: "new feature. This feature will consist of DX and tooling changes: constitutional ban on barrel files. convenient way to clean/nuke builds. migrate to yarn. fix the root npm 'dev' command to ensure both FE and BE processes run (looks like the BE process blocks the UI from coming up), it would be great if both process logs can be tailed."

## User Scenarios & Testing (mandatory)

### User Story 1 - Run development environment concurrently (Priority: P1)

A developer wants to start the full local application stack from the repository root and see both backend and frontend output in one terminal.

**Why this priority**: Starting the app locally is the most frequent developer task and it currently blocks the UI from appearing because the backend process monopolizes the root dev command.

**Independent Test**: Run the root development command from the repository root and verify both services start, logs are visible, and the frontend becomes available.

**Acceptance Scenarios**:

1. **Given** the repo is checked out and dependencies are installed, **When** the developer runs the root development command, **Then** the backend process starts and remains running while the frontend process starts, and both logs appear in the same terminal with a clear prefix.
2. **Given** the frontend dev server is ready, **When** the developer opens the UI address, **Then** the UI loads successfully even though the backend process is also running in the same session.
3. **Given** the root development environment is running, **When** the developer runs the root stop command, **Then** both backend and frontend processes stop cleanly.
4. **Given** either process exits unexpectedly, **When** the root development command is running, **Then** the log output clearly indicates which process failed.

---

### User Story 2 - Clean / nuke workspace build outputs quickly (Priority: P2)

A developer wants to remove generated build artifacts from the repository without manually deleting directories across packages.

**Why this priority**: Stale build artifacts cause confusing local state and can make development and CI results unpredictable.

**Independent Test**: Run the root clean command and verify generated artifacts across frontend, backend, and shared workspaces are removed.

**Acceptance Scenarios**:

1. **Given** build artifacts exist from previous runs, **When** the developer executes the clean command, **Then** all generated build directories are removed and the workspace returns to a clean state.
2. **Given** the developer wants a deeper reset, **When** they execute the nuke command, **Then** the command removes all workspace build outputs and generated package manager artifacts without removing source files.

---

### User Story 3 - Use a single package manager for the repo (Priority: P2)

A developer wants the repository to use Yarn consistently instead of a mix of npm and workspace commands.

**Why this priority**: Consistent package management reduces onboarding friction and prevents mismatched lockfiles or command confusion.

**Independent Test**: Install dependencies from the repo root with Yarn and verify workspace scripts still run as expected.

**Acceptance Scenarios**:

1. **Given** a fresh clone, **When** the developer installs dependencies from the root with Yarn, **Then** workspace dependencies are installed successfully and the root commands work.
2. **Given** the repository is using Yarn, **When** developers consult the README or contribution guide, **Then** they see Yarn as the recommended package manager.

---

### User Story 4 - Enforce a ban on barrel files in repository constitution (Priority: P3)

A maintainer wants tooling and documentation to prevent new barrel file exports from being introduced in the repository.

**Why this priority**: Barrel files can obscure dependency boundaries and increase import cycle risk in TypeScript code.

**Independent Test**: View repository guidance and verify there is a clear rule forbidding barrel files, and confirm a lint or review rule is proposed.

**Acceptance Scenarios**:

1. **Given** a new module is added, **When** a developer reviews the repo constitution or style guide, **Then** they see that barrel files are not allowed.
2. **Given** a barrel file is present, **When** the repository is checked against the new guidance or tooling, **Then** it is flagged as a violation.

---

### Edge Cases

- What happens if the repository still contains existing barrel files when the new rule is introduced?
- How does the clean/nuke command behave when build directories do not exist?
- How are workspace package manager lockfiles handled if both npm and Yarn artifacts remain?

## Requirements (mandatory)

### Functional Requirements

- **FR-001**: The root development command MUST start both frontend and backend workspace development servers concurrently and keep both processes running.
- **FR-002**: The root development command MUST present log output from both services in a single terminal with a clear prefix or separation for each service.
- **FR-003**: The root development command MUST not prevent the frontend from becoming available while the backend process is active.
- **FR-004**: The repository MUST provide a root-level clean command that removes generated build artifacts across frontend, backend, shared, and workspace-level output folders.
- **FR-005**: The repository MUST provide a root-level stop command that stops any running frontend and backend dev processes started from the root development workflow.
- **FR-006**: The repository MUST provide a root-level nuke command that removes generated build artifacts and any workspace-generated package manager output needed to restore a clean developer state.
- **FR-007**: The repository MUST migrate to Yarn 4.15.0 as the primary package manager for the root workspace and document Yarn as the supported install/run method.
- **FR-008**: The repository MUST update developer guidance to reflect the move to Yarn 4.15.0 and the new root-level tooling commands.
- **FR-009**: The repository MUST establish a constitutional ban on barrel files and capture it in the repository constitution, contribution guide, or DX documentation.
- **FR-010**: The repository MUST include a practical way to detect or prevent new barrel-file exports from entering the codebase, such as documentation, lint guidance, or review automation.

### Key Entities

- **Root development command**: The single entrypoint command that starts the local developer environment for backend and frontend together.
- **Clean command**: The command used to remove build artifacts and reset generated workspace output.
- **Nuke command**: The command used to thoroughly remove generated build outputs and package manager artifacts when a deeper reset is required.
- **Repository constitution / DX guidance**: The documented rules and conventions that developers follow for package management and import structure.

## Success Criteria (mandatory)

### Measurable Outcomes

- **SC-001**: Developers can run the root development command and see both frontend and backend service logs in the same terminal, with both services starting successfully within 5 seconds.
- **SC-002**: The frontend UI becomes available while the backend development process is still running under the root development command.
- **SC-003**: The root clean command removes generated build artifacts in all workspace packages and leaves only source files behind.
- **SC-004**: The root nuke command removes generated build outputs and workspace-generated package manager artifacts without deleting source code.
- **SC-005**: A fresh dependency install using Yarn 4.15.0 from the repository root succeeds and the recommended package manager is documented in the repo guidance.
- **SC-006**: Repository documentation clearly states that barrel files are banned and provides a developer-facing explanation of why.
- **SC-007**: New barrel-file exports are prevented or flagged by repository guidance or tooling.

## Assumptions

- This feature is focused on developer experience and tooling, not on application feature behavior.
- Existing source files and runtime application behavior remain unchanged by the tooling updates.
- The repository is allowed to standardize on Yarn 4.15.0 even if some existing npm artifacts remain temporarily during transition.
- Build artifact cleanup is expected to cover generated output directories such as `dist/` and workspace-generated package manager artifacts, not source files.
- The barrel file ban is enforced through documentation and repository guidance rather than changing application functionality.
