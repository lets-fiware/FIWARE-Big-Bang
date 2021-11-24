#!/bin/sh

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

set -ue

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

if ${MULTI_SERVER}; then
  echo "This command shoud be run on a base VM."
  exit 1
fi

echo "MULTI_SERVER_KEYROCK=https://${KEYROCK}"
echo "MULTI_SERVER_ADMIN_EMAIL=${IDM_ADMIN_EMAIL}"
printf "MULTI_SERVER_ADMIN_PASS=%s\n\n" "${IDM_ADMIN_PASS}"

echo "MULTI_SERVER_PEP_PROXY_USERNAME=${PEP_PROXY_USERNAME}"
printf "MULTI_SERVER_PEP_PASSWORD=%s\n\n" "${PEP_PASSWORD}"

echo "MULTI_SERVER_CLIENT_ID=${TOKENPROXY_CLIENT_ID}"
echo "MULTI_SERVER_CLIENT_SECRET=${TOKENPROXY_CLIENT_SECRET}"

if [ -n "${ORION}" ]; then
  printf "\nMULTI_SERVER_ORION_HOST=%s\n" "${ORION}"
fi

if [ -n "${QUANTUMLEAP}" ]; then
  printf "\nMULTI_SERVER_QUANTUMLEAP_HOST=%s/\n" "${QUANTUMLEAP}"
fi
