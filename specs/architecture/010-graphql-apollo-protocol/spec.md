# Specification: GraphQL + Apollo protocol pivot (spec 010)

**Status**: Active  
**Scope**: Replace REST/OpenAPI client access for health and employee CRUD with a single GraphQL endpoint on the BFF and Apollo Client on the frontend.

## Goals

1. Canonical API contract is GraphQL SDL in [`contracts/schema.graphql`](contracts/schema.graphql).
2. BFF exposes **`POST /graphql`** (and `GET /graphql` for GraphiQL in development) as the only UI boundary for health and employees.
3. Frontend uses **Apollo Client** with codegen types/hooks derived from the canonical schema.
4. MSW intercepts GraphQL operations in mock mode using the same operation documents as production.

## Behavior

### BFF

- Mount GraphQL Yoga at `/graphql` with schema from spec 010.
- **Remove** REST routes: `GET /health`, `/employees/*` (list, create, update, delete).
- **Retain** REST `/users` routes from spec 006 until a follow-up migrates user management.
- Auth: mock principal headers (`x-mock-user-id`, `x-mock-roles`) flow through GraphQL context; resolver-level checks mirror prior REST authorization.
- Errors: use GraphQL `errors[]` with `extensions.code` (`UNAUTHENTICATED`, `FORBIDDEN`, `VALIDATION_ERROR`, `NOT_FOUND`, `DUPLICATE_EMAIL`, `DATABASE_UNAVAILABLE`).

### Health query

- `query { health { status timestamp message db { status error } } }`
- When Postgres probe fails after startup → GraphQL error with `extensions.code: DATABASE_UNAVAILABLE` (production may still exit via `onDatabaseUnavailable`).

### Employee operations

- `employees` query with optional `name` and `department` filters.
- `createEmployee`, `updateEmployee`, `deleteEmployee` mutations with `EmployeeInput`.

### Frontend

- `@apollo/client` with `HttpLink` to `VITE_GRAPHQL_URL` (default `http://localhost:3000/graphql`).
- `bun run codegen:api` generates typed documents from schema + `src/graphql/**/*.graphql`.
- Remove `openapi-typescript` codegen and REST service modules (`healthApi.ts`, `employeesApi.ts`).
- `ApolloProvider` wraps the app; employee list uses Apollo `useQuery` / `useMutation`.
- MSW `graphql` handlers match operation names from codegen documents.

## Out of scope

- Migrating `/users` REST endpoints to GraphQL.
- Subscriptions, federation, or persisted queries.
- Removing historical OpenAPI artifacts from specs 002/008 (marked superseded by this spec for health/employees only).

## Acceptance criteria

- Backend tests cover GraphQL health and employee auth/CRUD paths.
- Frontend tests use MSW GraphQL handlers and Apollo document operations.
- `ARCHITECTURE.md` in `employee-manager-fe` documents GraphQL + Apollo (not REST + fetch).
- `quickstart.md` documents live-backend and `dev:mock` flows against `/graphql`.
