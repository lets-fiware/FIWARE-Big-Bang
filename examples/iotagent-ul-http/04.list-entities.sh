#!/bin/sh
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

if [ -z "${IOTAGENT_UL}" ]; then
  echo "IoT Agent for UltraLight 2.0 not found"
  exit 1
fi

ngsi services --host "${IOTAGENT_UL}" list -P
ngsi devices --host "${IOTAGENT_UL}" list -P
ngsi list --host "${ORION}" --service openiot --path / entities -P
