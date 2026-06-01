#!/usr/bin/env bash

# Provision local Postgres using employee-manager-be environment configuration.
# Run from system-specs repo root or any directory.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPECS_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BE_ROOT="${EMPLOYEE_MANAGER_BE_ROOT:-$SPECS_ROOT/../employee-manager-be}"

if [ -f "$BE_ROOT/.env" ]; then
  set -a
  # shellcheck source=/dev/null
  source "$BE_ROOT/.env"
  set +a
elif [ -f "$BE_ROOT/.env.example" ]; then
  set -a
  # shellcheck source=/dev/null
  source "$BE_ROOT/.env.example"
  set +a
else
  echo "[setup-postgres] Missing $BE_ROOT/.env or .env.example" >&2
  echo "[setup-postgres] Set EMPLOYEE_MANAGER_BE_ROOT if the backend repo is elsewhere." >&2
  exit 1
fi

echo "[setup-postgres] Starting PostgreSQL setup (config from $BE_ROOT)..."

POSTGRES_HOST=${POSTGRES_HOST:-localhost}
POSTGRES_PORT=${POSTGRES_PORT:-5432}
POSTGRES_USER=${POSTGRES_USER:-employeeadmin}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-securepassword123}
POSTGRES_DB=${POSTGRES_DB:-employee_management}

echo "[setup-postgres] Creating database '$POSTGRES_DB' with user '$POSTGRES_USER'..."
psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U postgres <<EOF
CREATE USER "$POSTGRES_USER" WITH PASSWORD '$POSTGRES_PASSWORD';
CREATE DATABASE "$POSTGRES_DB" OWNER "$POSTGRES_USER";
EOF

echo "[setup-postgres] Database setup complete!"
echo "[setup-postgres] Connection string: postgresql://$POSTGRES_USER:*****@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"
