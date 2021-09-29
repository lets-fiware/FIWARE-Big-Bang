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

ngsi services --host "${IOTAGENT}" list -P
ngsi devices --host "${IOTAGENT}" list -P
ngsi list --host "${ORION}" --service openiot --path / entities -P
