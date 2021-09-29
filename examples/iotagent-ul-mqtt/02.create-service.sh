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

ngsi services --host "${IOTAGENT}" create --apikey 8f9z57ahxmtzx21oczr5vaabot --type Thing --resource /iot/d --cbroker http://orion:1026
ngsi services --host "${IOTAGENT}" list -P
