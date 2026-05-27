# Implementation Plan: DX Tooling Improvements

**Branch**: `002-dx` | **Date**: 2026-05-25 | **Spec**: `specs/002-dx-tooling-improvements/spec.md`
**Input**: Feature specification from `/specs/002-dx-tooling-improvements/spec.md`

## Summary

This feature improves developer experience by standardizing on Yarn 4.15.0, adding root-level workspace tooling for concurrent frontend/backend development, and providing clean/nuke commands across the monorepo. It also captures the new constitutional ban on barrel files in repository documentation and prepares the repository for consistent DX tooling without changing application runtime behavior.

## Technical Context

**Language/Version**: TypeScript 5.x, Node.js 24.x, React 18.x  
**Primary Dependencies**: Yarn Workspaces, Vite, Express, TypeScript, Jest  
**Storage**: N/A  
**Testing**: Jest for code tests; command smoke tests for root tooling  
**Target Platform**: Developer macOS/Linux environments  
**Project Type**: Monorepo full-stack web application with separated backend/frontend/shared packages  
**Performance Goals**: Developer tooling should start both services concurrently and keep the frontend available while the backend process runs  
**Constraints**: Preserve current workspace boundaries, avoid runtime application changes, and keep the new tooling layer small and explicit  
**Scale/Scope**: Local developer workflow improvements across existing repository packages, not a production scaling feature

## Constitution Check

- Gate 1: Comply with Principle VII by documenting local setup, tooling, and workflow changes in `README.md` and `CONTRIBUTING.md`.
- Gate 2: Avoid unnecessary abstraction by implementing root tooling as a small command layer instead of a new orchestration framework.
- Gate 3: Preserve package boundaries and avoid introducing barrel-file exports, consistent with TypeScript maintainability goals.

No constitution violations are introduced by this plan. The feature is a developer experience improvement and does not require additional architectural projects or extra complexity.

## Project Structure

### Documentation (this feature)

```text
specs/002-dx-tooling-improvements/
├── plan.md
├── research.md
├── data-model.md
└── quickstart.md
```

### Source Code (repository root)

```text
package.json
README.md
CONTRIBUTING.md
.yarnrc.yml
.yarn/
yarn.lock
backend/package.json
frontend/package.json
shared/package.json
.specify/memory/constitution.md
```

**Structure Decision**: Keep the existing monorepo layout intact. Add repository-level Yarn 4.15.0 configuration and root scripts for developer workflow while leaving `backend/`, `frontend/`, and `shared/` package layouts unchanged.

### Root Command Layer

- `yarn dev`: starts both backend and frontend dev servers concurrently with prefixed output.
- `yarn stop`: stops backend and frontend dev servers that were started from the root workspace.
- `yarn clean`: removes generated build artifacts from workspace packages such as `backend/dist`, `frontend/dist`, and `shared/dist`.
- `yarn nuke`: removes generated build outputs and package manager artifacts required for a deep reset, while preserving source files.
- `yarn install`: uses Yarn 4.15.0 workspace install semantics.

## Implementation Strategy

1. Add a project-local Yarn 4.15.0 release and root `.yarnrc.yml` configuration.
2. Update the root `package.json` with `dev`, `stop`, `clean`, and `nuke` scripts and keep package-specific scripts in `backend/package.json` and `frontend/package.json`.
3. Update `README.md` and `CONTRIBUTING.md` to document Yarn 4.15.0, root workspace commands, and the recommended developer workflow.
4. Add a constitutional rule banning barrel files to `.specify/memory/constitution.md` and reference the rule in contributor guidance.
5. Add verification or smoke tests for the new root commands to ensure the dev environment starts correctly, stops cleanly, and cleanup behaves as expected.

## Phase 0 Research

No open technical clarifications remain. Research is focused on the Yarn 4.15.0 migration path, simple root command orchestration, and documentation alignment.

## Phase 1 Design Outcomes

- Root-level DX tooling is defined as a small workspace script layer with commands for start, clean, and nuke.
- Yarn 4.15.0 is the selected package manager version for the repository.
- Barrel file bans are established in documentation and will be enforced by future lint/check tasks.
- No external API or contract changes are required for this tooling feature.

## Complexity Tracking

No constitution violations or complexity tradeoffs require formal justification at this stage.
