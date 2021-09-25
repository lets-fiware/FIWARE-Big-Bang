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

. ./config.sh

if [ "${ORION}" != "orion" ]; then
  echo "Error ORION value in config.sh"
  exit 1
fi

if [ "${KEYROCK}" != "keyrock" ]; then
  echo "Error ORION value in config.sh"
  exit 1
fi

for NAME in COMET QUANTUMLEAP WIRECLOUD NGSIPROXY NODE_RED GRAFANA IDM_ADMIN_USER IDM_ADMIN_EMAIL IDM_ADMIN_PASS FIREWALL CERT_EMAIL CERT_REVOKE CERT_TEST CERT_FORCE_RENEWAL KEYROCK_POSTGRES IOTAGENT MQTT_USERNAME MQTT_PASSWORD
do
  eval VAL=\"\$$NAME\"
  if [ -n "$VAL" ]; then
    echo "${NAME} not empty: ${VAL}"
    exit 1
  fi
done

if [ "${IMAGE_CERTBOT}" != "certbot/certbot:v1.18.0" ]; then
  echo "Error IMAGE_CERTBOT"
  exit 1
fi
