# Research: DX Tooling Improvements

## Decision

- Use Yarn 4.15.0 as the repository's primary package manager.
- Implement root-level workspace tooling for `dev`, `clean`, and `nuke` commands.
- Document the new workflow in `README.md` and `CONTRIBUTING.md`.
- Capture the barrel file ban in repository constitution/documentation rather than changing runtime behavior.

## Rationale

- Yarn 4.15.0 is available via Corepack and is the requested version for the repo.
- Root-level tooling improves DX by allowing developers to start both frontend and backend services from a single command and see consolidated logs.
- Clean/nuke commands reduce the risk of stale artifacts and make workspace resets predictable.
- A documentation-driven barrel file ban is the least invasive first step, while future lint or review automation can enforce the policy.

## Alternatives Considered

- Keep npm as the workspace manager: rejected because the feature request explicitly targets Yarn migration and the repo currently uses mixed npm/workspace commands.
- Use pnpm instead of Yarn: rejected because the repo already has npm-based workspace structure and the requested version is Yarn 4.15.0.
- Implement a complex orchestration service: rejected in favor of a simple shell/script-based root command layer to minimize complexity.
