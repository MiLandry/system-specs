# Quickstart: Spec 003 — CI foundations

This spec introduces a backend-only CI baseline for `employee-manager-be` using GitHub Actions. Service containers and frontend CI are out of scope.

## Step 1 — Confirm workflow exists

From `employee-manager-be`:

```bash
cd path/to/employee-manager-be
ls .github/workflows/ci.yml
```

Expected: file exists and defines `pull_request` + `push` (`main`) triggers with Bun setup and install/typecheck/test/build steps.

## Step 2 — Validate local command parity

Run the same checks CI runs:

```bash
cd path/to/employee-manager-be
bun install --frozen-lockfile
bun run typecheck
bun test
bun run build
```

Expected: all commands exit successfully on a healthy branch.

## Step 3 — Validate PR trigger behavior

1. Create a branch in `employee-manager-be`.
2. Make a small non-breaking change (for example docs-only change).
3. Open a pull request to `main`.

Expected in GitHub:

- CI workflow starts automatically for the PR.
- Workflow status is visible in checks.
- Successful run reports passing status for merge review.

## Step 4 — Validate failure gating (optional but recommended)

To verify quality gates are effective, introduce a temporary failure locally (do not merge this change):

- Typecheck failure: add an obvious TypeScript error and push.
- Test failure: force an assertion to fail and push.

Expected in GitHub:

- CI fails on the corresponding step.
- Logs clearly indicate the failing command.

Revert the temporary failure and confirm CI returns to green.

## Step 5 — Validate push trigger on `main`

After merging a green PR, confirm the same workflow runs on the resulting push to `main`.

Expected: run appears for `main` push and completes with the same command sequence.

## Notes

- No Postgres service container is required for this phase.
- This spec does not add frontend CI.
- If branch protection is enabled, configure this workflow as a required check after several stable runs.
