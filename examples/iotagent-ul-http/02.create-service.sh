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

ngsi services --host "${IOTAGENT_UL}" create --apikey Dk8A0vfwTkTiAY71QyyKzOv9CT --type Thing --resource "${IOTA_UL_DEFAULT_RESOURCE}" --cbroker http://orion:1026
ngsi services --host "${IOTAGENT_UL}" list -P
