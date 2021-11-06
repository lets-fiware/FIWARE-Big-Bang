#!/bin/sh
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

if [ -z "${IOTAGENT_JSON}" ]; then
  echo "IoT Agent for JSON not found"
  exit 1
fi

ngsi version --host "${IOTAGENT_JSON}" -P
