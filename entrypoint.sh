#!/bin/bash
set -e

# Удаляем старый pid файл
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Ждем PostgreSQL (ИСПРАВЛЕНО: указываем базу данных)
echo "Waiting for PostgreSQL..."
while ! pg_isready -h pg -p 5432 -U admin -d canopy_company_dev; do
  sleep 2
done
echo "PostgreSQL is ready!"

# Выполняем переданную команду
exec "$@"