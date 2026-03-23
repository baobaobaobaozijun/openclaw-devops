#!/bin/bash

# OpenClaw Deployment Script
# Usage: ./deploy.sh [up|down|restart|logs|status]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "Warning: .env file not found. Using default values from .env.example"
fi

case "${1:-up}" in
    up)
        echo "Starting OpenClaw services..."
        docker-compose up -d
        echo "Services started. Check logs with: ./deploy.sh logs"
        ;;
    down)
        echo "Stopping OpenClaw services..."
        docker-compose down
        echo "Services stopped."
        ;;
    restart)
        echo "Restarting OpenClaw services..."
        docker-compose restart
        echo "Services restarted."
        ;;
    logs)
        docker-compose logs -f "${2:-}"
        ;;
    status)
        docker-compose ps
        ;;
    rebuild)
        echo "Rebuilding and restarting services..."
        docker-compose up -d --build
        echo "Build complete."
        ;;
    *)
        echo "Usage: $0 {up|down|restart|logs|status|rebuild}"
        exit 1
        ;;
esac
