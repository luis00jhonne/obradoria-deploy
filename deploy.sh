#!/bin/bash
set -e
echo "Pulling latest images..."
docker compose pull
echo "Restarting services..."
docker compose up -d --remove-orphans
sleep 10
docker compose ps
echo "Deploy complete."
