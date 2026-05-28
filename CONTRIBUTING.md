# Contributing to Spec Kit Demo

Thank you for contributing to this project. This repository follows a spec-driven workflow, and contributions should be clear, testable, and aligned with the existing architecture.

## Getting Started

1. Install dependencies:

```bash
yarn install
```

2. Create a local environment file:

```bash
cp .env.example .env
```

3. Run the backend and frontend in separate terminals:

```bash
yarn workspace @employee-system/backend dev
yarn workspace @employee-system/frontend dev
```

## CI checks (system-specs repo)

This repository has a CI workflow at `.github/workflows/ci.yml` focused on contract validation for spec artifacts.

- Trigger: `pull_request` and pushes to `main`
- Check: Redocly lint for spec 002 OpenAPI contract

Run the same check locally:

```bash
bunx @redocly/cli lint specs/002-backend-connectivity/contracts/openapi.yaml --skip-rule security-defined
```

## Branches

- Create feature branches from `main`.
- Use descriptive branch names, such as `001-employee-management` or `feature/<short-description>`.
- Keep branches focused on a single feature, bug fix, or documentation update.

## Workflow

This repository uses the Spec Kit workflow:

1. Update or create spec artifacts in `specs/<feature>/spec.md`.
2. Generate or update the implementation plan with `/speckit.plan` if applicable.
3. Create or update task tracking in `specs/<feature>/tasks.md`.
4. Implement code changes in the appropriate workspace (`backend/`, `frontend/`, `shared/`).
5. Add or update tests before finalizing implementation.
6. Open a pull request with a clear description and linked issue or feature spec.

## Testing

### Run all tests

```bash
yarn test
```

### Frontend tests

```bash
yarn workspace @employee-system/frontend test -- --runInBand
```

### Backend tests

```bash
yarn workspace @employee-system/backend test -- --runInBand
```

## Pull Request Checklist

- [ ] Code implements the intended feature or fix.
- [ ] Tests were added or updated and pass locally.
- [ ] Documentation or specs were updated if needed.
- [ ] The change is described clearly in the PR title and description.
- [ ] No TODOs or placeholder text remain in production code.

## Reporting Issues

If you find a bug or unclear behavior, open a GitHub issue with:

- A concise summary of the problem
- Steps to reproduce
- Expected and actual behavior
- Any relevant logs or screenshots

## Questions

If you are unsure about the best way to contribute, please ask before making major architecture changes. When in doubt, keep changes small and focused.
