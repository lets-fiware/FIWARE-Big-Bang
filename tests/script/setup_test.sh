#!/bin/bash

set -ue

pushd ./tests/certmock/
docker build -t letsfiware/certmock:0.2.0 .
popd

sed -i -e "s/^\(IMAGE_CERTBOT=\).*/\1letsfiware\/certmock:0.2.0/" config.sh

export FIBB_TEST=true
./lets-fiware.sh example.com
