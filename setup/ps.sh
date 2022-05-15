#!/bin/sh
if [ -e docker-compose.yml ]; then
  /usr/bin/docker compose ps
else
  echo "docker-compose.yml not found"
fi
