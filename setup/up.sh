#!/bin/sh
if [ -e docker-compose.yml ]; then
  /usr/bin/docker compose up -d
else
  echo "docker-compose.yml not found"
fi
