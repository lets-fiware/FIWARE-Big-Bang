#!/bin/sh
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

ngsi create \
  --host "${ORION}" \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Draco of all context changes" \
  --idPattern ".*" \
  --uri "http://draco:5050/v2/notify"
