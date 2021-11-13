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
  --description "Notify Comet of all context changes" \
  --idPattern ".*" \
  --uri "http://comet:8666/notify" \
  --attrsFormat "legacy"
