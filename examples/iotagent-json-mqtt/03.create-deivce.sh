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

ngsi devices --host "${IOTAGENT_JSON}" create --data '{
 "devices": [
   {
     "device_id":   "sensor002",
     "entity_name": "urn:ngsi-ld:WeatherObserved:sensor002",
     "entity_type": "Sensor",
     "timezone":    "Asia/Tokyo",
     "transport":   "MQTT",
     "attributes": [
       { "object_id": "d", "name": "dateObserved", "type": "DateTime" },
       { "object_id": "t", "name": "temperature", "type": "Number" },
       { "object_id": "h", "name": "relativeHumidity", "type": "Number" },
       { "object_id": "p", "name": "atmosphericPressure", "type": "Number" }
     ],
     "static_attributes": [
       { "name":"location", "type": "geo:json", "value" : { "type": "Point", "coordinates" : [ 139.7671, 35.68117 ] } }
     ]
   }
 ]
}'

ngsi devices --host "${IOTAGENT_JSON}" list -P
