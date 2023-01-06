#!/bin/bash
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

if [ -z "${MOSQUITTO}" ]; then
  echo "Mosquitto not found"
  exit 1
fi

if ! ${MQTT_TLS}; then
  echo "MQTT TLS not available"
  exit 1
fi

if ! type mosquitto_pub >/dev/null 2>&1; then
  echo "sudo apt-get install mosquitto-clients or sudo yum install mosquitto-clients"
  exit 1
fi

while true 
do
  DATE=$(date "+%Y-%m-%dT%H:%M:%S+0000" -u)
  MSG="{\"d\":\"${DATE}\",\"t\":$RANDOM,\"h\":$RANDOM,\"p\":$RANDOM}"
  echo "MSG: ${MSG}"
  mosquitto_pub \
    --debug \
    --host "${MOSQUITTO}" --port "${MQTT_TLS_PORT}" \
    --username "${MQTT_USERNAME}" --pw "${MQTT_PASSWORD}" \
    --topic "/SMoCnNjlrAfeFOtlaC8XAhM8o1/sensor002/attrs" \
    --message "${MSG}" \
    --cafile "${ROOT_CA}"
  sleep 1
done
