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


#
##!/bin/bash
#set -e
#
#echo "🚀 Starting deploy..."
#
#PROJECT_DIR="/opt/canopy_company"
#APP_CONTAINER="canopy-app-prod"
#POSTGRES_CONTAINER="canopy-postgres-prod"
#IMAGE_NAME="canopy-app-prod:latest"
#
#LOCKFILE="/tmp/deploy.lock"
#LOGFILE="/var/log/canopy_deploy.log"
#
#DATE=$(date +%F_%H-%M-%S)
#
#exec > >(tee -a $LOGFILE) 2>&1
#
## защита от двойного deploy
#exec 200>$LOCKFILE
#flock -n 200 || { echo "🔒 Deploy already running"; exit 1; }
#
#cd $PROJECT_DIR
#
#CURRENT_REVISION=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
#
#rollback() {
#  echo "⚠️ Rolling back..."
#
#  git reset --hard $CURRENT_REVISION
#
#  docker restart $APP_CONTAINER
#}
#
#notify_failure() {
#  echo "🔴 Deploy failed"
#
#  rollback
#}
#
#trap notify_failure ERR
#
#echo "📥 Syncing with GitHub..."
#
#git fetch origin
#git reset --hard origin/main
#
#echo "🐳 Building Docker image..."
#docker build -t $IMAGE_NAME .
#
#echo "💾 Creating DB backup..."
#
#docker exec $POSTGRES_CONTAINER pg_dump -U postgres postgres | gzip > backup_$DATE.sql.gz || true
#
#echo "🔄 Restarting app container..."
#
#docker stop $APP_CONTAINER || true
#docker rm $APP_CONTAINER || true
#
#docker run -d \
#  --name $APP_CONTAINER \
#  --env-file .env \
#  -p 3000:3000 \
#  $IMAGE_NAME
#
#echo "🗄 Running migrations..."
#
#docker exec $APP_CONTAINER bundle exec rails db:migrate
#
#echo "🩺 Checking application health..."
#
#sleep 5
#
#if ! curl -f http://localhost:3000 > /dev/null; then
#  echo "❌ Healthcheck failed"
#  exit 1
#fi
#
#echo "🧹 Cleaning old docker images..."
#
#docker image prune -f
#
#echo "🎉 Deploy finished successfully!"