#!/bin/sh
if [ -e docker-compose.yml ]; then
  /usr/bin/docker compose build
else
  echo "docker-compose.yml not found"
fi
