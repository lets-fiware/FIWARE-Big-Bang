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

set -Ceuo pipefail

setup_log_directory() {
  if [ -d "${LOG_DIR}" ]; then
    sudo rm -fr "${LOG_DIR}"
  fi
  sudo mkdir "${LOG_DIR}"
  sudo mkdir "${NGINX_LOG_DIR}"
  if [ "${DISTRO}" = "Ubuntu" ]; then
    sudo chown syslog:adm "${LOG_DIR}"
  fi
}

if [ -d ./data ]; then
  sudo /usr/local/bin/docker-compose up -d --build
  exit
fi

if [ $# -eq 0 ] || [ $# -ge 3 ]; then
  echo "$0 DOMAIN_NAME [GLOBAL_IP_ADDRESS]"
  exit 1
fi

DOMAIN_NAME=$1
IP_ADDRESS=

if [ $# -ge 2 ]; then
  IP_ADDRESS=$2
fi

if [ ! -e ./config.sh ]; then
  echo "config.sh file not found"
  exit 1
fi

. ./config.sh

for NAME in KEYROCK ORION
do
  eval VAL=\"\$$NAME\"
  if [ "$VAL" = "" ]; then
      echo "${NAME} is empty"
      exit 1
  fi
done

if [ -z "${FIREWALL}" ]; then
  FIREWALL=false
fi

if ! [ "${FIBB_TEST:+false}" ]; then
  FIBB_TEST=false
  export FIBB_TEST
fi

export FIREWALL

SETUP_DIR=./setup
${SETUP_DIR}/prepare.sh

. ./.env

. ./setup/constant.sh

DATA_DIR=./data
CERTBOT_DIR=$(pwd)/data/cert
CONFIG_DIR=./config

DOCKER_COMPOSE=/usr/local/bin/docker-compose
CERTBOT=certbot/certbot:v1.18.0

LOG_DIR=/var/log/fiware
NGINX_LOG_DIR=${LOG_DIR}/nginx
setup_log_directory

if [ -z "${IDM_ADMIN_USER}" ]; then
  IDM_ADMIN_USER="admin"
fi

if [ -z "${IDM_ADMIN_EMAIL}" ]; then
  IDM_ADMIN_EMAIL=${IDM_ADMIN_USER}@${DOMAIN_NAME}
fi

if [ -z "${IDM_ADMIN_PASS}" ]; then
  IDM_ADMIN_PASS=$(pwgen -s 16 1)
fi

if [ -z "${CERT_EMAIL}" ]; then
  CERT_EMAIL=${IDM_ADMIN_EMAIL}
fi

if [ -z "${CERT_REVOKE}" ]; then
  CERT_REVOKE=false
fi

if "${FIBB_TEST}"; then
  CERT_DIR=${CONFIG_DIR}/cert
else
  CERT_DIR=/etc/letsencrypt 
fi

if [ -z "${LOGGING}" ]; then
  LOGGING=true
fi

if [ "${WIRECLOUD}" = "" ]; then
  NGSIPROXY=""
fi

if [ "${WIRECLOUD}" != "" ] && [ "${NGSIPROXY}" = "" ]; then
  echo "error: NGSIPROXY is empty"
  exit 1
fi

cat <<EOF >> .env
DATA_DIR=${DATA_DIR}
CERTBOT_DIR=${CERTBOT_DIR}
CONFIG_DIR=${CONFIG_DIR}
NGINX_SITES=${CONFIG_DIR}/nginx/sites-enable
SETUP_DIR=${SETUP_DIR}
TEMPLEATE=${SETUP_DIR}/templeate

LOG_DIR=${LOG_DIR}
NGINX_LOG_DIR=${NGINX_LOG_DIR}

DOMAIN_NAME=${DOMAIN_NAME}
IP_ADDRESS=${IP_ADDRESS}

DOCKER_COMPOSE=${DOCKER_COMPOSE}

FIREWALL=${FIREWALL}
LOGGING=${LOGGING}

CERT_DIR=${CERT_DIR}
CERTBOT=${CERTBOT}
CERT_EMAIL=${CERT_EMAIL}
CERT_REVOKE=${CERT_REVOKE}
CERT_TEST=${CERT_TEST}
CERT_FORCE_RENEWAL=${CERT_FORCE_RENEWAL}

IDM_ADMIN_UID=${IDM_ADMIN_UID}
IDM_ADMIN_USER=${IDM_ADMIN_USER}
IDM_ADMIN_EMAIL=${IDM_ADMIN_EMAIL}
IDM_ADMIN_PASS=${IDM_ADMIN_PASS}

EOF

for NAME in KEYROCK ORION COMET WIRECLOUD NGSIPROXY NODE_RED GRAFANA QUANTUMLEAP
do
  eval VAL=\"\$$NAME\"
  if [ -n "$VAL" ]; then
      eval echo ${NAME}=\"\$${NAME}."${DOMAIN_NAME}"\" >> .env
  else
      echo ${NAME}= >> .env
  fi 
done

echo -e -n "\n" >> .env

${SETUP_DIR}/setup.sh

. ./.env

echo "*** Setup has been completed ***"
echo "IDM: https://${KEYROCK}"
echo "User: ${IDM_ADMIN_EMAIL}"
echo "Password: ${IDM_ADMIN_PASS}"
echo "Please see the .env file for details."
