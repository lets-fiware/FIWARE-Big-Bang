#!/bin/bash

set -ue

install_kcov() {
  if type kcov >/dev/null 2>&1; then
    return
  fi
  sudo apt update
  sudo apt-get install binutils-dev libiberty-dev libcurl4-openssl-dev libelf-dev libdw-dev cmake gcc g++

  pushd /opt
  sudo sh -c "curl -sSL https://github.com/SimonKagstrom/kcov/archive/refs/tags/38.tar.gz | tar xz"
  sudo mkdir kcov-38/build
  cd kcov-38/build
  sudo cmake ..
  sudo make install
  popd
}

build_certmock() {
  pushd ./tests/certmock/
  docker build -t letsfiware/certmock:0.2.0 .
  popd
}

setup() {
  install_kcov
  build_certmock

  export FIBB_TEST=true

  if [ -d coverage ]; then
    rm -fr coverage
  fi

  mkdir coverage

  sudo rm -f /usr/local/bin/docker-compose
  curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.8.0/ngsi-v0.8.0-linux-amd64.tar.gz
  sudo tar zxvf ngsi-v0.8.0-linux-amd64.tar.gz -C /usr/local/bin
  rm -f ngsi-v0.8.0-linux-amd64.tar.gz

  KCOV="/usr/local/bin/kcov --exclude-path=tests,.git,setup,coverage,.github,.vscode"
}

fibb_down() {
  make down

  while [ "1" != "$(docker ps | wc -l)" ]
  do
    sleep 1
  done

  sleep 5

  make clean
}

install_test1() {
  sed -i -e "s/^\(COMET=\).*/\1comet/" config.sh
  sed -i -e "s/^\(QUANTUMLEAP=\).*/\1quantumleap/" config.sh
  sed -i -e "s/^\(WIRECLOUD=\).*/\1wirecloud/" config.sh
  sed -i -e "s/^\(NGSIPROXY=\).*/\1ngsiproxy/" config.sh
  sed -i -e "s/^\(NODE_RED=\).*/\1node-red/" config.sh
  sed -i -e "s/^\(GRAFANA=\).*/\1grafana/" config.sh
  sed -i -e "s/^\(IMAGE_CERTBOT=\).*/\1letsfiware\/certmock:0.2.0/" config.sh
  sed -i -e "s/^\(CERT_REVOKE=\).*/\1true/" config.sh

  ${KCOV} ./coverage ./lets-fiware.sh example.com
}


install_test2() {
  sleep 5

  ${KCOV} ./coverage ./lets-fiware.sh example.com
}

install_test3() {
  sleep 5

  git checkout config.sh

  ${KCOV} ./coverage ./lets-fiware.sh example.com
}

install_test4() {
  sleep 5

  # shellcheck disable=SC2207
  IPS=($(hostname -I))

  git checkout config.sh

  sed -i -e "s/^\(KEYROCK_POSTGRES=\).*/\1true/" config.sh

  ${KCOV} ./coverage ./lets-fiware.sh example.com "${IPS[0]}"
}

setup

install_test1

install_test2

fibb_down

install_test3

fibb_down

install_test4

fibb_down
