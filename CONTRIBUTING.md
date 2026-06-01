# Contributing to system-specs

This repository holds specification artifacts for the employee manager project. Application code lives in `employee-manager-be` and `employee-manager-fe`.

## Local CI parity

CI validates OpenAPI contracts with Redocly. Run the same check locally:

```bash
bunx @redocly/cli lint specs/002-backend-connectivity/contracts/openapi.yaml --skip-rule security-defined
```

## Branches

- Create feature branches from `main` (see constitution: feature number or `CHORE-` prefix).
- Keep branches focused on a single spec, plan, or documentation update.

## Workflow

1. Update or create spec artifacts under `specs/`.
2. Use Spec Kit commands (`/speckit.plan`, `/speckit.tasks`, etc.) when applicable.
3. Implement code in the backend or frontend repos, linked to the spec.
4. Open a pull request with a clear description.

## Environment configuration

Do not add `.env` files to this repo. Postgres and runtime settings belong in `employee-manager-be` (see `employee-manager-be/.env.example`).

Optional local DB provisioning:

```bash
.specify/scripts/setup-postgres.sh
```

The script reads `POSTGRES_*` from `employee-manager-be/.env` (or `.env.example`).

## Pull request checklist

- [ ] Spec or contract changes match the intended feature scope.
- [ ] OpenAPI contracts lint locally when changed.
- [ ] No application secrets or `.env` files committed to this repo.
