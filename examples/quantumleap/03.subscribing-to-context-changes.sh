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
  --description "Notify QuantumLeap of all context changes" \
  --idPattern ".*" \
  --uri "http://quantumleap:8668/v2/notify"
