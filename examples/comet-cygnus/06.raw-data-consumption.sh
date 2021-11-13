#!/bin/bash
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

ngsi hget \
  --host "${COMET}" \
  --service openiot \
  --path / \
  attr \
  --lastN 3 \
  --type device \
  --id device001 \
  --attr temperature \
  --pretty
