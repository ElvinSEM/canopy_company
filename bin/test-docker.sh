#set -o errexit
#
#bundle install
#yarn install
##bundle exec rake assets:precompile
##bundle exec rake assets:clean
#bundle exec rake db:migratec

#!/bin/bash
set -e

echo "🧹 Cleaning up..."
docker system prune -f 2>/dev/null || true

echo "🔨 Building Docker image..."
if docker build -t canopy-test . 2>&1 | tee build.log; then
    echo "✅ Build successful!"

    echo "🚀 Starting container..."
    CONTAINER_ID=$(docker run -d -p 3000:3000 \
        -e RAILS_ENV=production \
        -e SECRET_KEY_BASE=test_$(openssl rand -hex 32) \
        canopy-test)

    echo "⏳ Waiting for Rails to start..."
    sleep 15

    echo "📊 Checking container logs..."
    docker logs $CONTAINER_ID --tail=20

    echo "🌐 Testing homepage..."
    if curl -f http://localhost:3000 >/dev/null 2>&1; then
        echo "🎉 SUCCESS! Application is running."
        echo "Open http://localhost:3000 in your browser"
    else
        echo "❌ FAILED: Application not responding"
        docker logs $CONTAINER_ID --tail=50
    fi

    echo "🛑 Stopping container..."
    docker stop $CONTAINER_ID
    docker rm $CONTAINER_ID
else
    echo "❌ Build failed!"
    echo "=== Last 30 lines of build log ==="
    tail -30 build.log
    exit 1
fi