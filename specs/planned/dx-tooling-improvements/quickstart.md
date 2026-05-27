# Quickstart: DX Tooling Improvements

## Install Dependencies

```bash
corepack enable
corepack prepare yarn@4.15.0 --activate
yarn install
```

## Start the Development Environment

```bash
yarn dev
```

Expected behavior:
- Backend and frontend development servers start concurrently.
- Both services output logs in the same terminal with clear prefixes.
- The frontend UI becomes available while the backend process remains running.

## Stop Running Development Services

```bash
yarn stop
```

Expected behavior:
- Running backend and frontend development servers started from `yarn dev` are stopped.
- Any terminal output for those services stops when the command completes.

## Clean Generated Build Artifacts

```bash
yarn clean
```

Expected behavior:
- Generated build directories such as `backend/dist` and `frontend/dist` are removed.
- Source files are preserved.

## Nuke Workspace Artifacts

```bash
yarn nuke
```

Expected behavior:
- Build artifacts and package manager-generated files are removed.
- Source files are preserved.

## Notes

- The repository should standardize on Yarn 4.15.0 for future installs and runs.
- Documentation should clearly state Yarn 4.15.0 as the recommended package manager.
