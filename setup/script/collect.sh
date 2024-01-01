#!/bin/bash

# MIT License
#
# Copyright (c) 2021-2024 Kazuhito Suda
#
# This file is part of FIWARE Big Bang
#
# https://github.com/lets-fiware/FIWARE-Big-Bang
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -eu

LANG=C

APPS=(KEYROCK ORION CYGNUS COMET WIRECLOUD NGSIPROXY NODE_RED GRAFANA QUANTUMLEAP IOTAGENT_UL IOTAGENT_JSON IOTAGENT_HTTP MOSQUITTO ELASTICSEARCH)

check_cmd() {
  if type "$1" >/dev/null 2>&1; then
    FOUND=true
  else
    FOUND=false
  fi
}

check_distro() {
  DISTRO=

  if [ -e /etc/redhat-release ]; then
    DISTRO=$(cat /etc/redhat-release)
  elif [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then

    if [ -e /etc/lsb-release ]; then
      ver="$(sed -n -e "/DISTRIB_RELEASE=/s/DISTRIB_RELEASE=\(.*\)/\1/p" /etc/lsb-release | awk -F. '{printf "%2d%02d", $1,$2}')"
      DISTRO="Ubuntu ${ver}"
    else
      DISTRO="not Ubuntu"
    fi
  else
    DISTRO="Unknown distro"
  fi

  echo "OS: ${DISTRO}"
}

check_docker() {
  echo -n "Docker: "
  if type docker >/dev/null 2>&1; then
    sudo docker --version
  else
    echo "not found"
  fi

  echo -n "Docker compose: "
  set +e
  found=$(sudo docker info --format '{{json . }}' | jq -r '.ClientInfo.Plugins | .[].Name' | grep -ic compose)
  set -e

  if [ "${found}" -eq 1 ]; then
    sudo docker compose version
  else
    echo "not found"
  fi
}

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

echo '```'
echo -n "Date: "
date
echo "Version: ${VERSION}"
check_distro
check_docker
id
echo -n "Hash: "

check_cmd shasum
if "$FOUND"; then
  shasum -a 256 lets-fiware.sh
fi

check_cmd git
if "$FOUND" && [ -e .git ]; then
  echo "git-hash: "
  git log -n 3 --pretty=%H
fi

echo -n "App list: "
for NAME in "${APPS[@]}"
do
  eval VAL=\"\$"$NAME"\"
  if [ -n "$VAL" ]; then
    eval echo -n "${NAME}"
    echo -n " "
  fi
done

echo ""

echo -n "Install: "
if [ -e .install ]; then
  echo "in progress"
else
  echo "completed"
fi

echo "WILMA_AUTH_ENABLED: ${WILMA_AUTH_ENABLED}"

echo "Docker containers: "

make ps


check_cmd curl 
if "$FOUND"; then
  echo "Keyrock: "
  curl "https://${KEYROCK}/version"
fi

echo -e '\n```'
