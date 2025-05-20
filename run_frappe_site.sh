#!/bin/bash

# Script to run Frappe locally using Docker Compose

# Exit on error
set -e

# Default environment variables
export FRAPPE_BENCH_IMAGE="docker.io/frappe/bench:latest"
export DB_HOST=${DB_HOST:-db}
export DB_PORT=${DB_PORT:-3306}
export REDIS_URL=${REDIS_URL:-redis-cache:6379}
export SOCKETIO_PORT=${SOCKETIO_PORT:-9000}
export SITE_NAME=${SITE_NAME:-frontend}
export FRONTEND_PORT=${FRONTEND_PORT:-8080}
export WAIT_TIMEOUT=${WAIT_TIMEOUT:-120}
export DB_ROOT_USERNAME=${DB_ROOT_USERNAME:-root}
export MARIADB_ROOT_PASSWORD=${MARIADB_ROOT_PASSWORD:-frappe123}
export ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin123}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Log function
log() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

# Error function
error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# Check if Docker and Docker Compose are installed
command -v docker >/dev/null 2>&1 || error "Docker is not installed. Please install Docker first."
command -v docker-compose >/dev/null 2>&1 || error "Docker Compose is not installed. Please install Docker Compose first."

# Create .env file for Docker Compose
log "Creating .env file with environment variables..."
cat > .env << EOL
FRAPPE_BENCH_IMAGE=$FRAPPE_BENCH_IMAGE
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
REDIS_URL=$REDIS_URL
SOCKETIO_PORT=$SOCKETIO_PORT
SITE_NAME=$SITE_NAME
FRONTEND_PORT=$FRONTEND_PORT
WAIT_TIMEOUT=$WAIT_TIMEOUT
DB_ROOT_USERNAME=$DB_ROOT_USERNAME
MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD
ADMIN_PASSWORD=$ADMIN_PASSWORD
EOL
log ".env file created"

# Start Docker Compose services
log "Starting Frappe services with Docker Compose..."
docker-compose up -d || error "Failed to start Docker Compose services"





# Instructions for next steps
log "To stop the services, run: docker-compose down"
log "To view logs, run: docker-compose logs"
log "To access the Frappe container, run: docker-compose exec frappe bash"

# Optional: Keep the script running to monitor logs (uncomment if desired)
# log "Tailing logs (press Ctrl+C to stop)..."
# docker-compose logs -f