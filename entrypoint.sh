#!/bin/sh
set -e

echo "Starting Canopy Production..."

# Проверяем переменные окружения
if [ -z "$DATABASE_USERNAME" ]; then
  echo "ERROR: DATABASE_USERNAME is not set"
  exit 1
fi

if [ -z "$DATABASE_PASSWORD" ]; then
  echo "ERROR: DATABASE_PASSWORD is not set"
  exit 1
fi

if [ -z "$DATABASE_NAME" ]; then
  echo "ERROR: DATABASE_NAME is not set"
  exit 1
fi

# Ждем базу данных перед миграциями
if [[ "$RAILS_ENV" == "production" ]]; then
  echo "Waiting for PostgreSQL at ${DATABASE_HOST:-postgres}:${DATABASE_PORT:-5432}..."

  timeout=60
  while ! pg_isready -h "${DATABASE_HOST:-postgres}" \
                     -p "${DATABASE_PORT:-5432}" \
                     -U "$DATABASE_USERNAME" \
                     -d "$DATABASE_NAME" >/dev/null 2>&1; do
    timeout=$((timeout - 2))
    if [ $timeout -le 0 ]; then
      echo "ERROR: Timeout waiting for PostgreSQL"
      exit 1
    fi
    echo "Database not ready yet. Sleeping..."
    sleep 2
  done

  echo "PostgreSQL is ready!"

  # Проверяем и запускаем миграции
  echo "Checking for pending migrations..."
  if bundle exec rails db:migrate:status 2>/dev/null | grep -q "down"; then
    echo "Running migrations..."
    bundle exec rails db:migrate
  else
    echo "All migrations are up to date"
  fi

  # Проверяем, нужно ли precompile assets
  if [[ ! -f public/assets/manifest.json ]] || [[ ! -f public/vite/manifest.json ]]; then
    echo "Precompiling assets..."
    bundle exec rails assets:precompile
    bundle exec rails vite:build
  fi
fi

exec "$@"