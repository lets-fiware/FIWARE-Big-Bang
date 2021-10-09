#!/bin/sh

ORION=orion
LOG_LEVEL="${LOG_LEVEL:-info}"
HOST="${HOST:-http://orion:1026}"
URL="${URL:-/v2/ex/entities}"
VERBOSE="${VERBOSE:-false}"

if ${VERBOSE}; then
  VERBOSE=--verbose
else
  VERBOSE=""
fi

echo "LOG_LEVEL=${LOG_LEVEL}"
echo "HOST=${HOST}"
echo "URL=${URL}"
echo "VERBOSE=${VERBOSE}"

NGSI_GO="/usr/local/bin/ngsi --stderr ${LOG_LEVEL} --config ./ngsi-go-config.json --cache ./ngsi-go-token-cache.json"

${NGSI_GO} broker add --host "${ORION}" --ngsiType v2 --brokerHost "${HOST}" 

${NGSI_GO} broker get --host "${ORION}"

${NGSI_GO} queryproxy server --host "${ORION}" --replaceURL "${URL}" "${VERBOSE}" --qhost 0.0.0.0
