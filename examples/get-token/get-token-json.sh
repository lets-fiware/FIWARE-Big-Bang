#!/bin/sh
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

curl -sS "https://${KEYROCK}/token" \
  --header 'Content-Type: application/json' \
  --data "{\"username\":\"${IDM_ADMIN_EMAIL}\", \"password\": \"${IDM_ADMIN_PASS}\"}"
