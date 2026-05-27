# Tasks: DX Tooling Improvements

**Input**: Design documents from `/specs/002-dx-tooling-improvements/`
**Prerequisites**: plan.md, spec.md, research.md

## Phase 1: Setup

**Purpose**: Prepare the feature artifact and confirm the workspace documents for execution.

 - [x] T001 Create `specs/002-dx-tooling-improvements/tasks.md` from the feature plan and spec
 - [x] T002 [P] Validate current workspace package definitions in `package.json`, `backend/package.json`, `frontend/package.json`, and `shared/package.json`
 - [x] T003 [P] Confirm existing documentation paths in `README.md`, `CONTRIBUTING.md`, and `.specify/memory/constitution.md`

---

## Phase 2: Foundational

**Purpose**: Add workspace-level tooling and package manager configuration required before the user stories can be fully implemented.

 - [x] T004 Add Yarn 4.15.0 project configuration in `.yarnrc.yml` and `.yarn/releases/`
 - [x] T005 Add root workspace orchestration scripts in `scripts/dev.js`, `scripts/clean.js`, and `scripts/nuke.js`
 - [x] T006 Update root `package.json` with `dev`, `clean`, `nuke`, and Yarn workspace install/usage scripts
 - [x] T007 Update `backend/package.json` and `frontend/package.json` to ensure each package exposes explicit `dev` and build scripts compatible with root orchestration
- [ ] T008 Add a root shell/package verification command in `package.json` such as `check:barrels` and ensure it is ready for documentation references
- [ ] T032 Add root and workspace `stop` scripts to stop backend and frontend dev services started from the repository root

---

## Phase 3: User Story 1 - Run development environment concurrently (Priority: P1)

**Goal**: Enable `yarn dev` at the repository root to launch both backend and frontend services concurrently and show prefixed logs.

**Independent Test**: Run `yarn dev` at the repo root and verify both services start, both logs appear in one terminal, and the frontend UI is accessible.

 - [x] T009 [US1] Implement `scripts/dev.js` to start `backend` and `frontend` dev servers concurrently with distinct log prefixes
 - [x] T010 [US1] Update root `package.json` script `dev` to execute `node scripts/dev.js`
 - [x] T011 [US1] Document root development startup in `README.md` with example `yarn dev` usage and expected output
 - [x] T012 [US1] Add root dev verification guidance to `specs/002-dx-tooling-improvements/quickstart.md`

---

## Phase 4: User Story 2 - Clean / nuke workspace build outputs quickly (Priority: P2)

**Goal**: Provide root-level cleanup commands for standard and deep workspace resets.

**Independent Test**: Run `yarn clean` and `yarn nuke` from the root and verify build artifacts and workspace-generated artifacts are removed.

 - [x] T013 [US2] Implement `scripts/clean.js` to remove generated build artifact directories such as `backend/dist`, `frontend/dist`, and `shared/dist`
 - [x] T014 [US2] Implement `scripts/nuke.js` to remove generated build outputs and package-manager-generated artifacts without deleting source files
 - [x] T015 [US2] Update root `package.json` scripts `clean` and `nuke` to invoke the new cleanup scripts
 - [x] T016 [P] [US2] Document the cleanup workflow in `README.md` and `CONTRIBUTING.md`
 - [x] T017 [P] [US2] Add the `clean` and `nuke` usage examples to `specs/002-dx-tooling-improvements/quickstart.md`

---

## Phase 5: User Story 3 - Use a single package manager for the repo (Priority: P2)

**Goal**: Migrate repository guidance to Yarn 4.15.0 and ensure workspace installs are documented consistently.

**Independent Test**: Install dependencies at the root using Yarn 4.15.0 and confirm workspace scripts are described accurately in documentation.

 - [x] T018 [US3] Add Yarn 4.15.0 release files to `.yarn/releases/` and root `.yarnrc.yml`
 - [x] T019 [US3] Confirm root workspace package manager references in `package.json` and remove npm-specific workspace command examples if present
 - [x] T020 [P] [US3] Update `README.md` to recommend Yarn 4.15.0 as the primary install/run workflow
 - [x] T021 [P] [US3] Update `CONTRIBUTING.md` to advise developers to use Yarn 4.15.0 for workspace command execution
 - [x] T022 [P] [US3] Add Yarn 4.15.0 install instructions to `specs/002-dx-tooling-improvements/quickstart.md`

---

## Phase 6: User Story 4 - Enforce a ban on barrel files in repository constitution (Priority: P3)

**Goal**: Record and communicate a repo-wide prohibition on barrel files, and provide a practical detection path.

**Independent Test**: Verify the constitution and contributing guidance explicitly ban barrel files and that a root check script exists for future enforcement.

- [ ] T023 [US4] Update `.specify/memory/constitution.md` to explicitly ban barrel files and explain the rationale
- [ ] T024 [US4] Add a barrel-file guidance section to `CONTRIBUTING.md` describing why barrel files are not permitted
- [ ] T025 [US4] Implement `scripts/check-barrels.js` to scan the repository for barrel-style `index.ts`/`index.ts` exports
- [ ] T026 [US4] Add root `package.json` script `check:barrels` to execute `node scripts/check-barrels.js`
- [ ] T027 [P] [US4] Document the barrel-file policy and detection guidance in `README.md`

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Ensure the DX improvements are complete, documented, and validated across the repository.

- [ ] T028 [P] Review `README.md`, `CONTRIBUTING.md`, and `specs/002-dx-tooling-improvements/quickstart.md` for consistency with Yarn 4.15.0 and root tooling commands
- [ ] T029 [P] Validate root `package.json` script outputs and ensure the command names and descriptions match documentation
- [ ] T030 [P] Confirm `backend/package.json`, `frontend/package.json`, and `shared/package.json` remain consistent with the root workspace configuration
- [ ] T031 [P] Run verification guidance in `specs/002-dx-tooling-improvements/quickstart.md` and update it if any commands or expected behavior change

---

## Dependencies & Execution Order

- **Phase 1: Setup** has no dependencies and can start immediately.
- **Phase 2: Foundational** depends on Setup completion and should be complete before user stories begin.
- **Phase 3+ User Stories** depend on Foundational completion but can be executed in parallel after that.
- **Phase 7: Polish** depends on all user story phases and cross-cutting updates.

### Parallel Opportunities

- `T002`, `T003`, `T007`, `T008`, `T016`, `T017`, `T020`, `T021`, `T022`, `T025`, `T027`, `T028`, `T029`, `T030`, and `T031` are marked `[P]` and can be worked in parallel when independent.
- User story implementation tasks may proceed concurrently after the foundational environment is established.
