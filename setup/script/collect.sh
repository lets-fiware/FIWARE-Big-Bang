#!/bin/bash

# MIT License
#
# Copyright (c) 2021 Kazuhito Suda
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

echo "Docker containers: "

make ps


check_cmd curl 
if "$FOUND"; then
  echo "Keyrock: "
  curl "https://${KEYROCK}/version"
fi

echo -e '\n```'
