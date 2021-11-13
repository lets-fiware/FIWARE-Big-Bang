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
  --description "Notify Cygnus of all context changes and store it into Elasticsearch" \
  --idPattern ".*" \
  --uri "http://cygnus:5058/notify"
