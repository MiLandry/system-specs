# Implementation Plan: GraphQL + Apollo protocol pivot

**Branch**: `010-graphql-apollo-protocol` | **Date**: 2026-06-02 | **Spec**: `specs/architecture/010-graphql-apollo-protocol/spec.md`

## Summary

Replace REST/OpenAPI fetch clients for health and employee CRUD with GraphQL Yoga on the BFF and Apollo Client on the frontend. Canonical contract lives in `contracts/schema.graphql`; MSW mocks GraphQL operations in development and tests.

## Technical Context

**Language/Version**: TypeScript, Node.js 24.x / Bun, React 19.x  
**Primary Dependencies**: `graphql`, `graphql-yoga` (BFF); `@apollo/client`, `@graphql-codegen/*` (FE)  
**Testing**: Bun test; MSW `graphql` handlers for FE; Hono `app.request` POST `/graphql` for BE  

## Implementation Strategy

1. Add canonical SDL under `contracts/schema.graphql`.
2. **Backend**: `src/graphql/` schema, resolvers, context; mount Yoga at `/graphql`; delete REST health/employee routes.
3. **Frontend**: Apollo provider, codegen config, operation documents, replace REST services and OpenAPI codegen.
4. **MSW**: GraphQL handlers for `Health`, `Employees`, and employee mutations.
5. Update tests, README, `ARCHITECTURE.md`, `.env.example`.
6. Mark specs 002/008 REST contracts as superseded for health/employees in spec 010 cross-links.

## Complexity Tracking

No constitution violations. OpenAPI removal for active UI paths reduces dual-contract drift.
