#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="finale"
VOLUME_NAME="finale_volume"
CONTAINER_DIR="/app/data"

# Create volume only if it doesn't exist
if ! docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
    echo "📦 Creating Docker volume: $VOLUME_NAME"
    docker volume create "$VOLUME_NAME" >/dev/null
fi

# Build image only if it doesn't exist
if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "🐳 Building Docker image: $IMAGE_NAME"
    docker build -t "$IMAGE_NAME" .
fi

# Run container with volume mounted
docker run -it \
    -v "$VOLUME_NAME":"$CONTAINER_DIR" \
    "$IMAGE_NAME"
