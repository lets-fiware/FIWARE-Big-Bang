#!/bin/sh
set -eu

cd "$(dirname "$0")"
cd ../..

. ./.env

ngsi get --host "${ORION}" --service openiot --path / entity --id urn:ngsi-ld:WeatherObserved:sensor004 --pretty
