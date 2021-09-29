#!/bin/sh
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

if [ -z "${IOTAGENT}" ]; then
  echo "IoT Agent not found"
  exit
fi

ngsi version --host "${IOTAGENT}" -P
