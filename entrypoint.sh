#!/bin/bash
set -e

rm -f tmp/pids/server.pid

# Сборка Vite для production (только при запуске)
if [ "$RAILS_ENV" = "production" ]; then
  echo "Building Vite assets..."
  bin/vite build
fi

bundle exec rails db:prepare

exec "$@"