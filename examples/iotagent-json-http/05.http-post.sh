#!/bin/bash
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

if [ -z "${IOTAGENT_HTTP}" ]; then
  echo "IoT Agent over HTTP not found"
  exit 1
fi

if [ -z "${IOTA_JSON_DEFAULT_RESOURCE}" ]; then
  echo "IoT Agent for JSON default resource not found"
  exit 1
fi

while true 
do
  DATE=$(date "+%Y-%m-%dT%H:%M:%S+0000" -u)
  MSG="{\"d\":\"${DATE}\",\"t\":$RANDOM,\"h\":$RANDOM,\"p\":$RANDOM}"
  echo "MSG: ${MSG}"

  case "${IOTA_HTTP_AUTH}" in
    "none")
      curl -X POST "https://${IOTAGENT_HTTP}${IOTA_JSON_DEFAULT_RESOURCE}?k=XaEMQ86tTBHCwN0C9MjiHXcYFX&i=sensor004" \
      -H "Content-Type: application/json" \
      -d "${MSG}"
      ;;
    "basic")
      curl -X POST "https://${IOTAGENT_HTTP}${IOTA_JSON_DEFAULT_RESOURCE}?k=XaEMQ86tTBHCwN0C9MjiHXcYFX&i=sensor004" \
      -u "${IOTA_HTTP_BASIC_USER}:${IOTA_HTTP_BASIC_PASS}" \
      -H "Content-Type: application/json" \
      -d "${MSG}"
      ;;
    "bearer")
      curl -X POST "https://${IOTAGENT_HTTP}${IOTA_JSON_DEFAULT_RESOURCE}?k=XaEMQ86tTBHCwN0C9MjiHXcYFX&i=sensor004" \
      -H "Authorization: Bearer $(ngsi token --host "${ORION}")" \
      -H "Content-Type: application/json" \
      -d "${MSG}"
      ;;
  esac
  sleep 1
done
