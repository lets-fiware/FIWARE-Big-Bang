#!/bin/sh
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

TOKEN=$(ngsi token --host "${ORION}")
export TOKEN

curl "https://${NODE_RED}/settings" \
  --header "Authorization: Bearer ${TOKEN}"
