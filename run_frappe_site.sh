#!/bin/bash

set -e



# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# Check if Docker and Docker Compose are installed
command -v docker >/dev/null 2>&1 || error "Docker is not installed. Please install Docker first."
command -v docker-compose >/dev/null 2>&1 || error "Docker Compose is not installed. Please install Docker Compose first."

log "Starting Frappe services with Docker Compose..."
source .env
envsubst '${APP_TOKEN}' < app-template.json > apps.json
# updating base64 app var
source .env
docker build \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=PYTHON_VERSION=3.11.9 \
  --build-arg=NODE_VERSION=18.20.2 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=${FRAPPE_IMAGE_NAME} \
  --file=images/custom/Containerfile .

docker compose -f 'docker-compose.yml' --env-file .env  up  || error "Failed to start Docker Compose services"

log "Stopping Frappe services with Docker Compose..."
# docker compose down
