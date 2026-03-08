#!/bin/bash
set -e

echo "🚀 Starting deploy..."

PROJECT_DIR="/opt/canopy_company"
APP_CONTAINER="canopy-app-prod"
POSTGRES_CONTAINER="canopy-postgres-prod"
IMAGE_NAME="canopy-app-prod:latest"
DATE=$(date +%F_%H-%M-%S)

cd $PROJECT_DIR

echo "📥 Pull latest code..."
git pull origin main

echo "💾 Backup database..."
mkdir -p backups
docker exec $POSTGRES_CONTAINER pg_dump -U admin canopy_company_production > backups/db_$DATE.sql

echo "📦 Build docker image..."
docker build -t $IMAGE_NAME .

echo "🛠 Run migrations..."
docker compose -f docker-compose.production.yml run --rm app bundle exec rails db:migrate

echo "🔁 Restart app container..."
docker compose -f docker-compose.production.yml up -d app

echo "🧹 Clean docker build cache..."
docker builder prune -af

echo "🧹 Clean old docker images..."
docker image prune -af

echo "✅ Deploy finished!"