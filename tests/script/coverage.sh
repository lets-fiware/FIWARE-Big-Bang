#!/bin/bash

set -ue

sudo apt update
sudo apt-get install binutils-dev libiberty-dev libcurl4-openssl-dev libelf-dev libdw-dev cmake gcc g++

curl -sSL https://github.com/SimonKagstrom/kcov/archive/refs/tags/38.tar.gz | tar xz
mkdir kcov-38/build
pushd kcov-38/build
cmake ..
sudo make install
popd

pushd ./tests/certmock/
make build
popd

sed -i -e "s/^\(COMET=\).*/\1comet/" config.sh
sed -i -e "s/^\(QUANTUMLEAP=\).*/\1quantumleap/" config.sh
sed -i -e "s/^\(WIRECLOUD=\).*/\1wirecloud/" config.sh
sed -i -e "s/^\(NGSIPROXY=\).*/\1ngsiproxy/" config.sh
sed -i -e "s/^\(NODE_RED=\).*/\1node-red/" config.sh
sed -i -e "s/^\(GRAFANA=\).*/\1grafana/" config.sh
sed -i -e "s%^\(IMAGE_CERTBOT=\).*%\1letsfiware/certmock:0.2.0%" config.sh
sed -i -e "s/^\(CERT_REVOKE=\).*/\1true" config.sh

mkdir coverage
export FIBB_TEST=true
kcov --exclude-path=tests,.git,setup,coverage ./coverage/ ./lets-fiware.sh example.com
