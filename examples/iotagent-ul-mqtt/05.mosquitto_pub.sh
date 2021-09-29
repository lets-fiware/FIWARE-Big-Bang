#!/bin/bash
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

while true 
do
  DATE=$(date "+%Y-%m-%dT%H:%M:%S+0000" -u)
  MSG="d|${DATE}|t|$RANDOM|h|$RANDOM|p|$RANDOM"
  echo "MSG: ${MSG}"
  mosquitto_pub -d -h "${IOTAGENT}" -p 1883 -u "${MQTT_USERNAME}" -P "${MQTT_PASSWORD}" \
    -t "/8f9z57ahxmtzx21oczr5vaabot/sensor001/attrs" \
    -m "${MSG}"
  sleep 1
done
