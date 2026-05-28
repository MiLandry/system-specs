# Quickstart: Spec 006 — Auth phase 1 (simple)

This spec validates authorization-first behavior with mocked authentication.

## Step 1 — Run backend auth tests

```bash
cd path/to/employee-manager-be
bun test
```

Expected: policy and route tests pass, including explicit `401` and `403` cases.

## Step 2 — Verify protected routes manually

### Missing principal -> 401

```bash
curl -i http://localhost:3000/users
```

### Viewer role -> 403

```bash
curl -i \
  -H "x-mock-user-id: u-viewer" \
  -H "x-mock-roles: viewer" \
  http://localhost:3000/users
```

### Manager role read -> 200

```bash
curl -i \
  -H "x-mock-user-id: u-manager" \
  -H "x-mock-roles: manager" \
  http://localhost:3000/users
```

### Admin role create -> 201

```bash
curl -i -X POST \
  -H "content-type: application/json" \
  -H "x-mock-user-id: u-admin" \
  -H "x-mock-roles: admin" \
  -d '{"userId":"u-new","roles":["viewer"]}' \
  http://localhost:3000/users
```

## Step 3 — Verify frontend 401/403 handling

Run frontend tests:

```bash
cd path/to/employee-manager-fe
bun test
```

Expected: health API service tests assert structured errors for `401` and `403`.
