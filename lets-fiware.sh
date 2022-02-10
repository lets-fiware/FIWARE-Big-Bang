#!/bin/bash

# MIT License
#
# Copyright (c) 2021-2022 Kazuhito Suda
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

VERSION=0.10.0-next

#
# Syslog info
#
logging_info() {
  echo "setup: $1" 1>&2
  /usr/bin/logger -i -p "user.info" -t "FI-BB" "setup: $1"
}

#
# Syslog err
#
logging_err() {
  echo "error: $1" 1>&2
  /usr/bin/logger -i -p "user.err" -t "FI-BB" "setup error: $1"
}

#
# Setup logging step1
#
setup_logging_step1() {
  logging_info "${FUNCNAME[0]}"

  LOG_DIR=/var/log/fiware
  NGINX_LOG_DIR=${LOG_DIR}/nginx

  RSYSLOG_CONF=${WORK_DIR}/rsyslog.conf
  LOGROTATE_CONF=${WORK_DIR}/logrotate.conf

  if [ -d "${LOG_DIR}" ]; then
    ${SUDO} rm -fr "${LOG_DIR}"
  fi
  ${SUDO} mkdir "${LOG_DIR}"
  ${SUDO} mkdir "${NGINX_LOG_DIR}"
  if [ "${DISTRO}" = "Ubuntu" ]; then
    ${SUDO} chown syslog:adm "${LOG_DIR}"
  fi

  # FI-BB log
  echo "${LOG_DIR}/fi-bb.log" >> "${LOGROTATE_CONF}"
  cat <<EOF >> "${RSYSLOG_CONF}"
:syslogtag,contains,"FI-BB" ${LOG_DIR}/fi-bb.log
& stop

EOF

  ${SYSTEMCTL} restart rsyslog.service
}

#
# Check data direcotry
#
check_data_direcotry() {
  logging_info "${FUNCNAME[0]}"

  if [ -d ./data ]; then
    ${DOCKER_COMPOSE} up -d --build
    exit "${ERR_CODE}"
  fi
}

#
# Get config sh
#
get_config_sh() {
  logging_info "${FUNCNAME[0]}"

  if [ ! -e ./config.sh ]; then
    logging_err "config.sh file not found"
    exit "${ERR_CODE}"
  fi

  . ./config.sh

  if $FIBB_TEST; then
    MOCK_PATH="${FIBB_TEST_MOCK_PATH-""}"
    IMAGE_CERTBOT="letsfiware/certmock:0.2.0"
  fi
}

#
# Set default values
#
set_default_values() {
  logging_info "${FUNCNAME[0]}"

  if [ -z "${ORION_EXPOSE_PORT}" ]; then
    ORION_EXPOSE_PORT=none
  fi

  if [ -z "${ORION_LD_EXPOSE_PORT}" ]; then
    ORION_LD_EXPOSE_PORT=none
  fi

  if [ -z "${MINTAKA_EXPOSE_PORT}" ]; then
    MINTAKA_EXPOSE_PORT=none
  fi

  if [ -z "${TIMESCALE_EXPOSE_PORT}" ]; then
    TIMESCALE_EXPOSE_PORT=none
  fi

  MINTAKA="${MINTAKA:-true}"

  if [ -z "${CYGNUS_EXPOSE_PORT}" ]; then
    CYGNUS_EXPOSE_PORT=none
  fi

  if [ -z "${COMET_EXPOSE_PORT}" ]; then
    COMET_EXPOSE_PORT=none
  fi

  if [ -z "${QUANTUMLEAP_EXPOSE_PORT}" ]; then
    QUANTUMLEAP_EXPOSE_PORT=none
  fi

  if [ -z "${ELASTICSEARCH_EXPOSE_PORT}" ]; then
    ELASTICSEARCH_EXPOSE_PORT=none
  fi

  if [ -z "${MONGO_EXPOSE_PORT}" ]; then
    MONGO_EXPOSE_PORT=none
  fi

  if [ -z "${MYSQL_EXPOSE_PORT}" ]; then
    MYSQL_EXPOSE_PORT=none
  fi

  if [ -z "${POSTGRES_EXPOSE_PORT}" ]; then
    POSTGRES_EXPOSE_PORT=none
  fi

  if [ -z "${POSTFIX}" ]; then
    POSTFIX=false
  fi

  if [ -z "${QUERYPROXY}" ]; then
    QUERYPROXY=false
  fi

  if [ -z "${REGPROXY}" ]; then
    REGPROXY=false
  fi

  if [ -z "${KEYROCK_POSTGRES}" ]; then
    KEYROCK_POSTGRES=false
  fi

  if [ -z "${IDM_ADMIN_USER}" ]; then
    IDM_ADMIN_USER="admin"
  fi

  if [ -z "${IDM_ADMIN_EMAIL}" ]; then
    IDM_ADMIN_EMAIL=${IDM_ADMIN_USER}@${DOMAIN_NAME}
  fi

  if [ -z "${CERT_EMAIL}" ]; then
    CERT_EMAIL=${IDM_ADMIN_EMAIL}
  fi

  if [ -z "${CERT_REVOKE}" ]; then
    CERT_REVOKE=false
  fi

  CERT_DIR=/etc/letsencrypt

}

#
# Check multi server values
#
check_multi_server_values() {
  logging_info "${FUNCNAME[0]}"

  if echo "${MULTI_SERVER_KEYROCK}" | grep "^https://" > /dev/null || echo "${MULTI_SERVER_KEYROCK}" | grep "^http://" > /dev/null ; then
    logging_info "multiple servers mode"
    if [ "${MULTI_SERVER_ADMIN_EMAIL}" = "" ] || [ "${MULTI_SERVER_ADMIN_PASS}" = "" ]; then
      logging_err "MULTI_SERVER_ADMIN_EMAIL or MULTI_SERVER_ADMIN_PASS is empty"
      exit "${ERR_CODE}"
    fi
    if [ "${MULTI_SERVER_PEP_PROXY_USERNAME}" = "" ] || [ "${MULTI_SERVER_PEP_PASSWORD}" = "" ]; then
      logging_err "MULTI_SERVER_PEP_PROXY_USERNAME or MULTI_SERVER_PEP_PASSWORD is empty"
      exit "${ERR_CODE}"
    fi
    if [ "${MULTI_SERVER_CLIENT_ID}" = "" ] || [ "${MULTI_SERVER_CLIENT_SECRET}" = "" ]; then
      logging_err "MULTI_SERVER_CLIENT_ID or MULTI_SERVER_CLIENT_SECRET is empty"
      exit "${ERR_CODE}"
    fi
    KEYROCK_HOST="${MULTI_SERVER_KEYROCK}"
    KEYROCK=$(echo "${MULTI_SERVER_KEYROCK}" | sed -E 's/^.*(http|https):\/\/([^/]+).*/\2/g')
    IDM_ADMIN_EMAIL="${MULTI_SERVER_ADMIN_EMAIL}"
    IDM_ADMIN_PASS="${MULTI_SERVER_ADMIN_PASS}"
    ORION_CLIENT_ID="${MULTI_SERVER_CLIENT_ID}"
    ORION_CLIENT_SECRET="${MULTI_SERVER_CLIENT_SECRET}"
    MULTI_SERVER=true
  else
    logging_err "MULTI_SERVER_KEYROCK not http or https"
    exit "${ERR_CODE}"
  fi

  if [ -z "${ORION}" ]; then
    if [ -n "${PERSEO}" ] || [ -n "${IOTAGENT_UL}" ] || [ -n "${IOTAGENT_JSON}" ]; then
      if [ -z "${MULTI_SERVER_ORION_INTERNAL_IP}" ]; then
        logging_err "MULTI_SERVER_ORION_INTERNAL_IP not found"
        exit "${ERR_CODE}"
      fi
      ORION_INTERNAL_HOST=${MULTI_SERVER_ORION_INTERNAL_IP}
      ORION_INTERNAL_URL="http://${ORION_INTERNAL_HOST}:${ORION_INTERNAL_PORT}/"
    fi

    if [ -n "${PERSEO}" ] || [ -n "${IOTAGENT_UL}" ] || [ -n "${IOTAGENT_JSON}" ] || [ -n "${WIRECLOUD}" ]; then
      if [ -z "${MULTI_SERVER_ORION_HOST}" ]; then
        logging_err "MULTI_SERVER_ORION_HOST not found"
        exit "${ERR_CODE}"
      fi
      MULTI_SERVER_ORION_URL="https://${MULTI_SERVER_ORION_HOST}/"
    fi
  fi

  if [ -n "${MULTI_SERVER_QUANTUMLEAP_HOST}" ]; then
    MULTI_SERVER_QUANTUMLEAP_URL="https://${MULTI_SERVER_QUANTUMLEAP_HOST}"
  fi
}

#
# Check Cygnus values
#
check_cygnus_values() {
  logging_info "${FUNCNAME[0]}"

  if [ "${CYGNUS}" != "" ]; then
    if [ -z "${CYGNUS_MONGO}" ]; then
      CYGNUS_MONGO=false
    fi
    if [ -z "${CYGNUS_MYSQL}" ]; then
      CYGNUS_MYSQL=false
    fi
    if [ -z "${CYGNUS_POSTGRES}" ]; then
      CYGNUS_POSTGRES=false
    fi
    if [ -z "${CYGNUS_ELASTICSEARCH}" ]; then
      CYGNUS_ELASTICSEARCH=false
    fi
    if ! ${CYGNUS_MONGO} && ! ${CYGNUS_MYSQL} && ! ${CYGNUS_POSTGRES} && ! ${CYGNUS_ELASTICSEARCH} ; then
      logging_err "error: Specify one or more Cygnus sinks"
      exit "${ERR_CODE}"
    fi
    if ${CYGNUS_ELASTICSEARCH}; then
      if [ "${ELASTICSEARCH}" = "" ]; then
        logging_err "error: ELASTICSEARCH is empty"
        exit "${ERR_CODE}"
      fi
    fi
  else
    ELASTICSEARCH=""
  fi
}

#
# Check Draco values
#
check_draco_values() {
  logging_info "${FUNCNAME[0]}"

  if [ "${DRACO}" != "" ]; then
    if [ -z "${DRACO_MONGO}" ]; then
      DRACO_MONGO=false
    fi
    if [ -z "${DRACO_MYSQL}" ]; then
      DRACO_MYSQL=false
    fi
    if [ -z "${DRACO_POSTGRES}" ]; then
      DRACO_POSTGRES=false
    fi
    if ! ${DRACO_MONGO} && ! ${DRACO_MYSQL} && ! ${DRACO_POSTGRES} ; then
      logging_err "error: Specify one or more Draco sinks"
      exit "${ERR_CODE}"
    fi
  fi

  DRACO_MONGO_HOST=
  DRACO_MONGO_PORT=
  DRACO_MONGO_USER=
  DRACO_MONGO_PASS=
  
  DRACO_MYSQL_HOST=
  DRACO_MYSQL_PORT=
  DRACO_MYSQL_USER=
  DRACO_MYSQL_PASS=

  DRACO_POSTGRES_HOST=
  DRACO_POSTGRES_PORT=
  DRACO_POSTGRES_USER=
  DRACO_POSTGRES_PASS=

  DRACO_CASSANDRA_HOST=
  DRACO_CASSANDRA_PORT=
}

#
# Check IoT Agent values
#
check_iot_agent_values() {
  logging_info "${FUNCNAME[0]}"

  if [ "${IOTAGENT_UL}" = "" ] && [ "${IOTAGENT_JSON}" = "" ]; then
    MOSQUITTO=""
    IOTAGENT_HTTP=""
  else
    if [ "${MOSQUITTO}" = "" ] && [ "${IOTAGENT_HTTP}" = "" ]; then
      logging_err "error: MOSQUITTO and IOTAGENT_HTTP are empty"
      exit "${ERR_CODE}"
    fi
    if [ "${MOSQUITTO}" != "" ]; then
      if [ -z "${MQTT_1883}" ]; then
        MQTT_1883=false
      fi
      if [ -z "${MQTT_TLS}" ]; then
        MQTT_TLS=true
      fi
      if ! "${MQTT_1883}" && ! "${MQTT_TLS}"; then
        logging_err "error: Both MQTT_1883 and MQTT_TLS are false"
        exit "${ERR_CODE}"
      fi
    fi
    if [ "${IOTAGENT_HTTP}" != "" ]; then
      if [ -z "${IOTA_HTTP_AUTH}" ]; then
        IOTA_HTTP_AUTH=bearer
      fi
      if [ "${IOTA_HTTP_AUTH}" != "none" ] && [ "${IOTA_HTTP_AUTH}" != "basic" ] && [ "${IOTA_HTTP_AUTH}" != "bearer" ]; then
        logging_err "error: IOTA_HTTP_AUTH is unknwon value. (none, basic or bearer)"
        exit "${ERR_CODE}"
      fi
      if [ "${IOTA_HTTP_AUTH}" = "basic" ]; then
        if [ -z "${IOTA_HTTP_BASIC_USER}" ]; then
          IOTA_HTTP_BASIC_USER=fiware
        fi
        if [ -z "${IOTA_HTTP_BASIC_PASS}" ]; then
          IOTA_HTTP_BASIC_PASS=$(pwgen -s 16 1)
        fi
      else
        IOTA_HTTP_BASIC_USER=
        IOTA_HTTP_BASIC_PASS=
      fi
    fi
  fi
}

#
# Check Node-RED values
#
check_node_red_values() {
  logging_info "${FUNCNAME[0]}"

  if [ -n "${NODE_RED_INSTANCE_NUMBER}" ]; then
    if [ "${NODE_RED_INSTANCE_NUMBER}" -lt 2 ] || [ "${NODE_RED_INSTANCE_NUMBER}" -gt 20 ]; then
      echo "error: NODE_RED_INSTANCE_NUMBER out of range (2-20)"
      exit "${ERR_CODE}"
    fi
    if [ -z "${NODE_RED_INSTANCE_HTTP_ADMIN_ROOT}" ]; then
      NODE_RED_INSTANCE_HTTP_ADMIN_ROOT=/node-red
    fi
    if [ -z "${NODE_RED_INSTANCE_USERNAME}" ]; then
      NODE_RED_INSTANCE_USERNAME=node-red
    fi
  else
    NODE_RED_INSTANCE_NUMBER=1
  fi
}

#
# Set and check values
#
set_and_check_values() {
  logging_info "${FUNCNAME[0]}"

  SSL_CERTIFICATE=fullchain.pem
  SSL_CERTIFICATE_KEY=privkey.pem

  IDM_ADMIN_UID="admin"

  SETUP_DIR=./setup
  TEMPLEATE=${SETUP_DIR}/templeate

  set_default_values

  ORION_INTERNAL_HOST=orion
  ORION_INTERNAL_PORT=1026
  ORION_INTERNAL_URL="http://${ORION_INTERNAL_HOST}:${ORION_INTERNAL_PORT}/"

  if [ -n "${KEYROCK}" ] && [ -z "${MULTI_SERVER_KEYROCK}" ]; then
    MULTI_SERVER=false
    MULTI_SERVER_KEYROCK=
    MULTI_SERVER_ADMIN_EMAIL=
    MULTI_SERVER_ADMIN_PASS=
    MULTI_SERVER_CLIENT_ID=
    MULTI_SERVER_CLIENT_SECRET=
    MULTI_SERVER_ORION_HOST=
    MULTI_SERVER_ORION_URL=
    MULTI_SERVER_QUANTUMLEAP_HOST=
    MULTI_SERVER_QUANTUMLEAP_URL=
    MULTI_SERVER_ORION_INTERNAL_IP=
  elif [ -n "${MULTI_SERVER_KEYROCK}" ] && [ -z "${KEYROCK}" ]; then
    check_multi_server_values
  else
    logging_err "Set either KEYROCK or MULTI_SERVER_KEYROCK"
    exit "${ERR_CODE}"
  fi

  if [ "${WIRECLOUD}" = "" ]; then
    NGSIPROXY=""
  fi

  if [ "${WIRECLOUD}" != "" ] && [ "${NGSIPROXY}" = "" ]; then
    logging_err "error: NGSIPROXY is empty"
    exit "${ERR_CODE}"
  fi

  if [ "${COMET}" != "" ] && [ "${CYGNUS}" != "" ]; then
    CYGNUS_MONGO=true
  fi

  if ${QUERYPROXY} && [ -z "${ORION}" ]; then
    logging_err "error: Queryroxy is enabled but Orion not found"
    exit "${ERR_CODE}"
  fi

  if [ -n "${ORION}" ] && [ -n "${ORION_LD}" ]; then
    logging_err "Set either Orion or Orion-LD"
    exit "${ERR_CODE}"
  fi

  if [ -n "${CYGNUS}" ] && [ -n "${DRACO}" ]; then
    logging_err "Set either Cygnus or Draco"
    exit "${ERR_CODE}"
  fi

  check_cygnus_values

  check_draco_values

  check_iot_agent_values

  check_node_red_values
}

#
# Add variables to .env file
#
add_env() {
  logging_info "${FUNCNAME[0]}"

  if [ -z "${IDM_ADMIN_PASS}" ]; then
    IDM_ADMIN_PASS=$(pwgen -s 16 1)
  fi

  cat <<EOF >> .env
VERSION=${VERSION}

MULTI_SERVER=${MULTI_SERVER}
DATA_DIR=${DATA_DIR}
CERTBOT_DIR=${CERTBOT_DIR}
CONFIG_DIR=${CONFIG_DIR}
CONFIG_NGINX=${CONFIG_NGINX}
NGINX_SITES=${NGINX_SITES}
SETUP_DIR=${SETUP_DIR}
WORK_DIR=${WORK_DIR}
CONTRIB_DIR=${CONTRIB_DIR}
TEMPLEATE=${TEMPLEATE}

LOG_DIR=${LOG_DIR}
NGINX_LOG_DIR=${NGINX_LOG_DIR}

DOMAIN_NAME=${DOMAIN_NAME}

DOCKER_COMPOSE="${DOCKER_COMPOSE}"

CURL="${CURL}"
NGSI_GO="${NGSI_GO}"

FIREWALL=${FIREWALL}

KEYROCK_POSTGRES=${KEYROCK_POSTGRES}

CERT_DIR=${CERT_DIR}
IMAGE_CERTBOT=${IMAGE_CERTBOT}
CERT_EMAIL=${CERT_EMAIL}
CERT_REVOKE=${CERT_REVOKE}
CERT_TEST=${CERT_TEST}
CERT_FORCE_RENEWAL=${CERT_FORCE_RENEWAL}

IDM_ADMIN_UID=${IDM_ADMIN_UID}
IDM_ADMIN_USER=${IDM_ADMIN_USER}

ORION_INTERNAL_HOST=${ORION_INTERNAL_HOST}
ORION_INTERNAL_PORT=${ORION_INTERNAL_PORT}
ORION_INTERNAL_URL=${ORION_INTERNAL_URL}

IMAGE_KEYROCK=${IMAGE_KEYROCK}
IMAGE_WILMA=${IMAGE_WILMA}
IMAGE_ORION=${IMAGE_ORION}
IMAGE_ORION_LD=${IMAGE_ORION_LD}
IMAGE_MINTAKA=${IMAGE_MINTAKA}
IMAGE_TIMESCALE=${IMAGE_TIMESCALE}
IMAGE_CYGNUS=${IMAGE_CYGNUS}
IMAGE_COMET=${IMAGE_COMET}
IMAGE_WIRECLOUD=${IMAGE_WIRECLOUD}
IMAGE_NGSIPROXY=${IMAGE_NGSIPROXY}
IMAGE_DRACO=${IMAGE_DRACO}
IMAGE_QUANTUMLEAP=${IMAGE_QUANTUMLEAP}
IMAGE_IOTAGENT_UL=${IMAGE_IOTAGENT_UL}
IMAGE_IOTAGENT_JSON=${IMAGE_IOTAGENT_JSON}
IMAGE_PERSEO_CORE=${IMAGE_PERSEO_CORE}
IMAGE_PERSEO_FE=${IMAGE_PERSEO_FE}

IMAGE_TOKENPROXY=${IMAGE_TOKENPROXY}
IMAGE_QUERYPROXY=${IMAGE_QUERYPROXY}
IMAGE_REGPROXY=${IMAGE_REGPROXY}

IMAGE_MONGO=${IMAGE_MONGO}
IMAGE_MYSQL=${IMAGE_MYSQL}
IMAGE_POSTGRES=${IMAGE_POSTGRES}
IMAGE_CRATE=${IMAGE_CRATE}

IMAGE_NGINX=${IMAGE_NGINX}
IMAGE_REDIS=${IMAGE_REDIS}
IMAGE_ELASTICSEARCH=${IMAGE_ELASTICSEARCH}
IMAGE_ELASTICSEARCH_DB=${IMAGE_ELASTICSEARCH_DB}
IMAGE_MEMCACHED=${IMAGE_MEMCACHED}
IMAGE_GRAFANA=${IMAGE_GRAFANA}
IMAGE_MOSQUITTO=${IMAGE_MOSQUITTO}
IMAGE_NODE_RED=${IMAGE_NODE_RED}
IMAGE_POSTFIX=${IMAGE_POSTFIX}

# Logging settings
IDM_DEBUG=${IDM_DEBUG}
CYGNUS_LOG_LEVEL=${CYGNUS_LOG_LEVEL}
COMET_LOGOPS_LEVEL=${COMET_LOGOPS_LEVEL}
QUANTUMLEAP_LOGLEVEL=${QUANTUMLEAP_LOGLEVEL}
WIRECLOUD_LOGLEVEL=${WIRECLOUD_LOGLEVEL}
TOKENPROXY_LOGLEVEL=${TOKENPROXY_LOGLEVEL}
TOKENPROXY_VERBOSE=${TOKENPROXY_VERBOSE}
QUERYPROXY_LOGLEVEL=${QUERYPROXY_LOGLEVEL}
NODE_RED_LOGGING_LEVEL=${NODE_RED_LOGGING_LEVEL}
NODE_RED_LOGGING_METRICS=${NODE_RED_LOGGING_METRICS}
NODE_RED_LOGGING_AUDIT=${NODE_RED_LOGGING_AUDIT}
GF_LOG_LEVEL=${GF_LOG_LEVEL}
MOSQUITTO_LOG_TYPE=${MOSQUITTO_LOG_TYPE}

EOF
}

#
# Add sub-domains to .env file
#
add_domain_to_env() {
  logging_info "${FUNCNAME[0]}"

  for NAME in "${APPS[@]}"
  do
    if ${MULTI_SERVER} && [ "${NAME}" = "KEYROCK" ]; then
      echo "KEYROCK=${KEYROCK}" >> .env
      continue
    fi
    eval VAL=\"\$"$NAME"\"
    if [ -n "$VAL" ]; then
        eval echo "${NAME}"=\"\$"${NAME}"."${DOMAIN_NAME}"\" >> .env
        eval "${NAME}"=\"\$"${NAME}"."${DOMAIN_NAME}"\"
    else
        echo "${NAME}"= >> .env
    fi 
  done

  echo -e -n "\n" >> .env
}

#
# Setup complete
#
setup_complete() {
  logging_info "${FUNCNAME[0]}"

  rm -f "${INSTALL}"

  . ./.env

  if ! ${MULTI_SERVER}; then
    KEYROCK_HOST="https://${KEYROCK}"
  fi
  echo "*** Setup has been completed ***"
  echo "IDM: ${KEYROCK_HOST}"
  echo "User: ${IDM_ADMIN_EMAIL}"
  echo "Password: ${IDM_ADMIN_PASS}"
  echo "docs: https://fi-bb.letsfiware.jp/"
  echo "Please see the .env file for details."
  if [ -e "${NODE_RED_USERS_TEXT}" ]; then
    echo "User informatin for Node-RED is here: ${NODE_RED_USERS_TEXT}"
  fi
}

#
# Get distribution name
#
get_distro() {
  logging_info "${FUNCNAME[0]}"

  DISTRO=

  if [ -e /etc/redhat-release ]; then
    DISTRO="CentOS"
  elif [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then

    if [ -e /etc/lsb-release ]; then
      ver="$(sed -n -e "/DISTRIB_RELEASE=/s/DISTRIB_RELEASE=\(.*\)/\1/p" /etc/lsb-release | awk -F. '{printf "%2d%02d", $1,$2}')"
      if [ "${ver}" -ge 1804 ]; then
        DISTRO="Ubuntu"
      else
        MSG="Error: Ubuntu ${ver} not supported"
        logging_err "${FUNCNAME[0]} ${MSG}"
        exit "${ERR_CODE}"
      fi
    else
      MSG="Error: not Ubuntu"
      logging_err "${FUNCNAME[0]} ${MSG}"
      exit "${ERR_CODE}"
    fi
  else
    MSG="Unknown distro"
    logging_err "${FUNCNAME[0]} ${MSG}"
    exit "${ERR_CODE}"
  fi

  echo "DISTRO=${DISTRO}" >> .env
  echo -e -n "\n" >> .env
  logging_info "${FUNCNAME[0]} ${DISTRO}"
}

#
# Check machine architecture
#
check_machine() {
  logging_info "${FUNCNAME[0]}"

  machine=$("${UNAME}" -m)
  if [ "${machine}" = "x86_64" ]; then
    logging_info "${FUNCNAME[0]} ${machine}"
    return
  fi

  MSG="Error: ${machine} not supported"
  logging_err "${FUNCNAME[0]} ${MSG}"
  exit "${ERR_CODE}"
}

#
# Install commands for Ubuntu
#
install_commands_ubuntu() {
  logging_info "${FUNCNAME[0]}"

  ${APT} update
  ${APT} install -y curl pwgen jq make zip
}

#
# Install commands for CentOS
#
install_commands_centos() {
  logging_info "${FUNCNAME[0]}"

  ${YUM} install -y epel-release
  ${YUM} install -y curl pwgen jq bind-utils make zip
}

#
# Install commands
#
install_commands() {
  logging_info "${FUNCNAME[0]}"

  update=false
  for cmd in curl pwgen jq zip
  do
    if ! type "${cmd}" >/dev/null 2>&1; then
        update=true
    fi
  done

  if "${update}"; then
    case "${DISTRO}" in
      "Ubuntu" ) install_commands_ubuntu ;;
      "CentOS" ) install_commands_centos ;;
    esac
  fi

  CURL=$(type curl | sed "s/.* \(\/.*\)/\1/")
  if $FIBB_TEST; then
    CURL="${CURL} --insecure"
  fi
}

#
# Setup firewall
#
setup_firewall() {
  logging_info "${FUNCNAME[0]}"

  if [ -z "${FIREWALL}" ]; then
    FIREWALL=false
  fi
  
  if "${FIREWALL}"; then
    case "${DISTRO}" in
      "Ubuntu" ) ${APT} install -y firewalld ;;
      "CentOS" ) ${YUM} -y install firewalld ;;
    esac
    ${SYSTEMCTL} start firewalld
    ${SYSTEMCTL} enable firewalld
    ${FIREWALL-CMD} --zone=public --add-service=http --permanent
    ${FIREWALL-CMD} --zone=public --add-service=https --permanent
    ${FIREWALL-CMD} --reload
  fi
}

#
# Install Docker for Ubuntu
#
#   https://docs.docker.com/engine/install/ubuntu/
#
install_docker_ubuntu() {
  logging_info "${FUNCNAME[0]}"

  ${SUDO} cp -p /etc/apt/sources.list{,.bak}
  ${APT_GET} update
  ${APT_GET} install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${APT_KEY} add -
  ${ADD_APT_REPOSITORY} "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  ${APT_GET} install -y docker-ce docker-ce-cli containerd.io
  ${SYSTEMCTL} start docker
  ${SYSTEMCTL} enable docker
}

#
# Install Docker for CentOS
#
#   https://docs.docker.com/engine/install/centos/
#
install_docker_centos() {
  logging_info "${FUNCNAME[0]}"

  ${YUM} install -y yum-utils
  ${YUM_CONFIG_MANAGER} --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  ${YUM} install -y docker-ce docker-ce-cli containerd.io
  ${SYSTEMCTL} start docker
  ${SYSTEMCTL} enable docker
}

#
# Check Docker
#
check_docker() {
  logging_info "${FUNCNAME[0]}"

  if ! type "${DOCKER_CMD}" >/dev/null 2>&1; then
    case "${DISTRO}" in
       "Ubuntu" ) install_docker_ubuntu ;;
       "CentOS" ) install_docker_centos ;;
    esac
  fi

  DOCKER="${SUDO} $(type docker | sed "s/.* \(\/.*\)/\1/")"
  if $FIBB_TEST; then
    DOCKER="${SUDO} ${MOCK_PATH}docker"
  fi
  
  local ver
  ver=$(${DOCKER} --version)
  logging_info "${FUNCNAME[0]} ${ver}"

  ver=$(${DOCKER} version -f "{{.Server.Version}}" | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
  if [ "${ver}" -ge 201006 ]; then
      return
  fi

  MSG="Docker engine requires equal or higher version than 20.10.6"
  logging_err "${FUNCNAME[0]} ${MSG}"
  exit "${ERR_CODE}"
}

#
# Check docker-compose
#
check_docker_compose() {
  logging_info "${FUNCNAME[0]}"

  if [ -e "${DOCKER_COMPOSE_CMD}" ]; then
    local ver
    ver=$(${DOCKER_COMPOSE} --version)
    logging_info "${FUNCNAME[0]} ${ver}"

    ver=$(${DOCKER_COMPOSE} version --short | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
    if [ "${ver}" -ge 11700 ]; then
      return
    fi
  fi

  curl -sOL https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64
  ${SUDO} mv docker-compose-Linux-x86_64 "${DOCKER_COMPOSE_CMD}"
  ${SUDO} chmod a+x "${DOCKER_COMPOSE_CMD}"
}

#
# Check NGSI Go
#
check_ngsi_go() {
  logging_info "${FUNCNAME[0]}"

  local ngsi_go_version
  ngsi_go_version=v0.11.0

  if [ -e /usr/local/bin/ngsi ]; then
    local ver
    ver=$(/usr/local/bin/ngsi --version)
    logging_info "${ver}"
    ver=$(/usr/local/bin/ngsi --version | sed -e "s/ngsi version \([^ ]*\) .*/\1/" | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
    if [ "${ver}" -ge 1100 ]; then
        cp /usr/local/bin/ngsi "${WORK_DIR}"
        return
    fi
  fi

  curl -sOL https://github.com/lets-fiware/ngsi-go/releases/download/${ngsi_go_version}/ngsi-${ngsi_go_version}-linux-amd64.tar.gz
  ${SUDO} tar zxf ngsi-${ngsi_go_version}-linux-amd64.tar.gz -C /usr/local/bin
  rm -f ngsi-${ngsi_go_version}-linux-amd64.tar.gz

  if [ -d /etc/bash_completion.d ]; then
    curl -OL https://raw.githubusercontent.com/lets-fiware/ngsi-go/main/autocomplete/ngsi_bash_autocomplete
    ${SUDO} mv ngsi_bash_autocomplete /etc/bash_completion.d/
    source /etc/bash_completion.d/ngsi_bash_autocomplete
    if [ -e ~/.bashrc ]; then
      set +e
      FOUND=$(grep -c "ngsi_bash_autocomplete" ~/.bashrc)
      set -e
      if [ "${FOUND}" -eq 0 ]; then
        echo "source /etc/bash_completion.d/ngsi_bash_autocomplete" >> ~/.bashrc
      fi
    fi
  fi

  cp /usr/local/bin/ngsi "${WORK_DIR}"
}

#
# Setup init
#
setup_init() {
  logging_info "${FUNCNAME[0]}"

  KEYROCK_DIR="${WORK_DIR}/keyrock"
  MYSQL_DIR="${WORK_DIR}/mysql"
  POSTGRES_DIR="${WORK_DIR}/postgres"

  CONFIG_NGINX=${CONFIG_DIR}/nginx
  NGINX_SITES=${CONFIG_DIR}/nginx/sites-enable

  CERTBOT_DIR=$(pwd)/data/cert

  NGSI_GO="/usr/local/bin/ngsi --batch --configDir ${WORK_DIR}/ngsi-go"
  if $FIBB_TEST; then
    NGSI_GO="${NGSI_GO} --insecureSkipVerify"
  fi

  IDM=keyrock-$(date +%Y%m%d_%H-%M-%S)

  DOCKER_COMPOSE_YML=./docker-compose.yml

  readonly APPS=(KEYROCK ORION ORION_LD CYGNUS COMET WIRECLOUD NGSIPROXY NODE_RED GRAFANA QUANTUMLEAP PERSEO IOTAGENT_UL IOTAGENT_JSON IOTAGENT_HTTP MOSQUITTO ELASTICSEARCH DRACO)

  val=

  WILMA_INSTALLED=false

  TOKENPROXY_INSTALLED=false

  MONGO_INSTALLED=false

  MYSQL_INSTALLED=false

  POSTGRES_INSTALLED=false
  POSTGRES_PASSWORD=

  MOSQUITTO_INSTALLED=false

  IOTAGENT_HTTP_INSTALLED=false

  TOKENPROXY=true

  OPENIOT_MONGO_INDEX=false

  CONTRIB_DIR=./CONTRIB
}

#
# Make directories
#
make_directories() {
  logging_info "${FUNCNAME[0]}"

  if [ -d "${WORK_DIR}" ]; then
    rm -fr "${WORK_DIR}"
  fi

  mkdir "${DATA_DIR}"
  mkdir "${WORK_DIR}"
  mkdir "${KEYROCK_DIR}"
  mkdir "${MYSQL_DIR}"
  mkdir "${POSTGRES_DIR}"

  mkdir -p "${CONFIG_DIR}"/nginx
  mkdir -p "${NGINX_SITES}"

  rm -fr "${CERTBOT_DIR}"
  mkdir -p "${CERTBOT_DIR}"
}

#
# Add /etc/hosts
#
add_etc_hosts() {
  logging_info "${FUNCNAME[0]}"

  if [ "$1" = "0.0.0.0" ]; then
    return
  fi

  for name in "${APPS[@]}"
  do
    if ${MULTI_SERVER} && [ "${name}" = "KEYROCK" ]; then
      continue
    fi 
    eval val=\"\$"${name}"\"
    if [ -n "${val}" ]; then
      result=0
      output=$(grep "${val}" /etc/hosts 2> /dev/null) || result=$?
      echo "${output}" > /dev/null
      if [ ! "$result" = "0" ]; then
        ${SUDO} bash -c "echo $1 ${val} >> /etc/hosts"
        logging_info "Add '$1 ${val}' to /etc/hosts"
      fi
    fi
  done

  cat /etc/hosts
}

#
# Validate domain
#
validate_domain() {
  logging_info "${FUNCNAME[0]}"

  local IPS

  if [ -n "${IP_ADDRESS}" ]; then
      IPS="${IP_ADDRESS}"
  else
      # shellcheck disable=SC2207
      IPS=$(hostname -I)
  fi

  if "$FIBB_TEST"; then
    IP_ADDRESS=${IPS[0]}
    IP_ADDRESS=$(echo "${IP_ADDRESS}" | awk '{ print $1 }')
    logging_info "${IP_ADDRESS}"
    add_etc_hosts "${IP_ADDRESS}" 
  fi

  logging_info "IPS=$IPS"

  # shellcheck disable=SC2068
  for name in ${APPS[@]}
  do
    if ${MULTI_SERVER} && [ "${name}" = "KEYROCK" ]; then
      continue
    fi 
    eval val=\"\$"${name}"\"
    if [ -n "${val}" ]; then
        logging_info "Sub-domain: ${val}"
        # shellcheck disable=SC2086
        IP=$(${HOST_CMD} -4 ${val} | sed -n -r "/ has address /s/^.* has address ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*$/\1/p" || true)
        if [ "$IP" = "" ]; then
          IP=$(sed -n -e "/${val}/s/\([^ ].*\) .*/\1/p" /etc/hosts)
        fi
        logging_info "IP address: ${IP}"
        found=false
        # shellcheck disable=SC2068
        for ip_addr in $IPS
        do
          if [ "${IP}" = "${ip_addr}" ] ; then
            found=true
            IP_ADDRESS="${IP}"
          fi
        done
        if ! "${found}"; then
            # shellcheck disable=SC2124
            MSG="IP address error: ${val}, ${IP_ADDRESS[@]}"
            logging_err "${MSG}"
            exit "${ERR_CODE}"
        fi 
    fi 
  done

  logging_info "IP_ADDRESS: ${IP_ADDRESS}"
  cat <<EOF >> .env
IP_ADDRESS=${IP_ADDRESS}
EOF
}

#
# wait for serive
#
wait() {
  logging_info "${FUNCNAME[0]}"

  local host
  local ret

  host=$1
  ret=$2

  echo "Wait for ${host} to be ready (${WAIT_TIME} sec)" 1>&2

  for i in $(seq "${WAIT_TIME}")
  do
    # shellcheck disable=SC2086
    if [ "${ret}" == "$(${CURL} ${host} -o /dev/null -w '%{http_code}\n' -s)" ]; then
      logging_info "${host} is ready."
      return
    fi
    sleep 1
  done

  logging_err "${host}: Timeout was reached."
  exit "${ERR_CODE}"
}

#
# get cert
#
get_cert() {
  logging_info "${FUNCNAME[0]}"

  echo "${CERT_DIR}/live/$1" 1>&2

  if ${SUDO} [ -d "${CERT_DIR}/live/$1" ] && ${CERT_REVOKE}; then
    # shellcheck disable=SC2086
    ${DOCKER} run --rm -v "${CERT_DIR}:/etc/letsencrypt" "${IMAGE_CERTBOT}" revoke -n -v ${CERT_TEST} --cert-path "${CERT_DIR}/live/$1/cert.pem"
  fi

  if ${SUDO} [ ! -d "${CERT_DIR}/live/$1" ]; then
    local root_ca
    root_ca="${PWD}/config/root_ca"
    if [ ! -d "${root_ca}" ]; then
      mkdir "${root_ca}"
    fi
    wait "http://$1/" "404"
    # shellcheck disable=SC2086
    ${SUDO} docker run --rm \
      -v "${CERTBOT_DIR}/$1:/var/www/html/$1" \
      -v "${CERT_DIR}:/etc/letsencrypt" \
      -v "${root_ca}":/root_ca \
      -e IP_ADDRESS="${IP_ADDRESS}" \
      "${IMAGE_CERTBOT}" \
      certonly ${CERT_TEST} --agree-tos -m "${CERT_EMAIL}" --webroot -w "/var/www/html/$1" -d "$1"
  else
    echo "Skip: ${CERT_DIR}/live/$1 direcotry already exits"
  fi
}

#
# setup cert
#
setup_cert() {
  logging_info "${FUNCNAME[0]}"

  for name in "${APPS[@]}"
  do
    if ${MULTI_SERVER} && [ "${name}" = "KEYROCK" ]; then
      continue
    fi 
    eval val=\"\$"${name}"\"
    if [ -n "${val}" ]; then
      if [ ! -d "${CERTBOT_DIR}"/"${val}" ]; then
        mkdir "${CERTBOT_DIR}"/"${val}"
      fi
      sed -e "s/HOST/${val}/" "${TEMPLEATE}"/nginx/nginx-cert > "${NGINX_SITES}"/"${val}"
    fi 
  done

  cp "${TEMPLEATE}"/docker/setup-cert.yml ./docker-cert.yml
  cp "${TEMPLEATE}"/nginx/nginx.conf "${CONFIG_DIR}"/nginx/

  ${DOCKER_COMPOSE} -f docker-cert.yml up -d

  for name in "${APPS[@]}"
  do
    if ${MULTI_SERVER} && [ "${name}" = "KEYROCK" ]; then
      continue
    fi 
    eval val=\"\$"${name}"\"
    if [ -n "${val}" ]; then
      get_cert "${val}"
    fi 
  done

  ${DOCKER_COMPOSE} -f docker-cert.yml down

  RND=$(od -An -tu1 -N1 /dev/urandom)
  HOUR=$(( "${RND}" % 5 ))
  RND=$(od -An -tu1 -N1 /dev/urandom)
  MINUTE=$(( "${RND}" % 60 ))

  CRON_FILE=/etc/cron.d/fiware-big-bang

  if [ -e "${CRON_FILE}" ]; then
    ${SUDO} rm -f "${CRON_FILE}"
  fi

  CRON_SH="${MINUTE} ${HOUR} \* \* \* root ${PWD}/config/script/renew.sh > /dev/null 2>&1"
  ${SUDO} sh -c "echo ${CRON_SH} > ${CRON_FILE}"

  local msg
  msg=$(echo "${CRON_FILE}: $CRON_SH" | sed -e "s/\\\\//g")
  logging_info "${msg}"
}

#
# Add fiware.conf
#
add_rsyslog_conf() {
  logging_info "${FUNCNAME[0]}"

  set +u
  while [ "$1" ]
  do
    cat <<EOF >> "${RSYSLOG_CONF}"
:syslogtag,startswith,"[$1]" /var/log/fiware/$1.log
& stop

EOF
    echo "${LOG_DIR}/$1.log" >> "${LOGROTATE_CONF}"
    shift
  done
  set -u
}

#
# setup_logging_step2
#
setup_logging_step2() {
  logging_info "${FUNCNAME[0]}"

  files=("$(sed -z -e "s/\n/ /g" "${LOGROTATE_CONF}")")
  # shellcheck disable=SC2068
  for file in ${files[@]}
  do
    ${SUDO} touch "${file}"
    if [ "${DISTRO}" = "Ubuntu" ]; then
      ${SUDO} chown syslog:adm "${file}"
    else
      ${SUDO} chown root:root "${file}"
      ${SUDO} chmod 0644 "${file}"
    fi
  done

  if [ "${DISTRO}" = "Ubuntu" ]; then
    ${SUDO} cp "${RSYSLOG_CONF}" /etc/rsyslog.d/10-fiware.conf
    ROTATE_CMD="/usr/lib/rsyslog/rsyslog-rotate"
  else
    ${SUDO} cp "${RSYSLOG_CONF}" /etc/rsyslog.d/fiware.conf
    ROTATE_CMD="/bin/kill -HUP \`cat /var/run/syslogd.pid 2> /dev/null\` 2> /dev/null || true"
  fi

  ${SYSTEMCTL} restart rsyslog.service

  cat <<EOF >> "${LOGROTATE_CONF}"
{
        rotate 4
        weekly
        dateext
        missingok
        notifempty
        compress
        delaycompress
        sharedscripts
        postrotate
                ${ROTATE_CMD}
        endscript
}
EOF

  ${SUDO} cp "${LOGROTATE_CONF}" /etc/logrotate.d/fiware
}

#
# Up Keyrock with MySQL
#
up_keyrock_mysql() {
  logging_info "${FUNCNAME[0]}"

  mkdir -p "${CONFIG_DIR}"/keyrock/certs/applications

  cp -a "${TEMPLEATE}"/docker/setup-keyrock-mysql.yml ./docker-idm.yml
  cp "${CONTRIB_DIR}/keyrock/applications.js" "${CONFIG_DIR}/keyrock"
  add_to_docker_idm_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/certs/applications:/opt/fiware-idm/certs/applications"
  add_to_docker_idm_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/applications.js:/opt/fiware-idm/controllers/api/applications.js"

  MYSQL_ROOT_PASSWORD=$(pwgen -s 16 1)

  IDM_HOST=https://${KEYROCK}

  IDM_DB_HOST=mysql
  IDM_DB_NAME=idm
  IDM_DB_USER=idm
  IDM_DB_PASS=$(pwgen -s 16 1)

  cat <<EOF >> .env
IDM_HOST=${IDM_HOST}

# Mysql

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

IDM_DB_HOST=${IDM_DB_HOST}
IDM_DB_NAME=${IDM_DB_NAME}
IDM_DB_USER=${IDM_DB_USER}
IDM_DB_PASS=${IDM_DB_PASS}

# Keyrock

IDM_ADMIN_UID=${IDM_ADMIN_UID}
IDM_ADMIN_USER=${IDM_ADMIN_USER}
IDM_ADMIN_EMAIL=${IDM_ADMIN_EMAIL}
IDM_ADMIN_PASS=${IDM_ADMIN_PASS}
IDM_SESSION_SECRET=$(pwgen -s 16 1)
IDM_ENCRYPTION_KEY=$(pwgen -s 16 1)
EOF

  cat <<EOF > "${MYSQL_DIR}"/init.sql
CREATE USER '${IDM_DB_USER}'@'%' IDENTIFIED BY '${IDM_DB_PASS}';
GRANT ALL PRIVILEGES ON ${IDM_DB_NAME}.* TO '${IDM_DB_USER}'@'%';
flush PRIVILEGES;
EOF
}

#
# UP keyrock with PostgreSQL
#
up_keyrock_postgres() {
  logging_info "${FUNCNAME[0]}"

  mkdir -p "${CONFIG_DIR}"/keyrock/certs/applications

  cp "${CONTRIB_DIR}/keyrock/20210603073911-hashed-access-tokens.js" "${CONFIG_DIR}/keyrock"
  cp "${CONTRIB_DIR}/keyrock/applications.js" "${CONFIG_DIR}/keyrock"
  cp -a "${TEMPLEATE}"/docker/setup-keyrock-postgres.yml ./docker-idm.yml

  add_to_docker_idm_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/20210603073911-hashed-access-tokens.js:/opt/fiware-idm/migrations/20210603073911-hashed-access-tokens.js"
  add_to_docker_idm_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/certs/applications:/opt/fiware-idm/certs/applications"
  add_to_docker_idm_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/applications.js:/opt/fiware-idm/controllers/api/applications.js"

  POSTGRES_PASSWORD=$(pwgen -s 16 1)

  IDM_HOST=https://${KEYROCK}

  IDM_DB_DIALECT=postgres
  IDM_DB_HOST=postgres
  IDM_DB_PORT=5432
  IDM_DB_NAME=idm
  IDM_DB_USER=idm
  IDM_DB_PASS=$(pwgen -s 16 1)

  cat <<EOF >> .env
IDM_HOST=${IDM_HOST}

# PostgreSQL

POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

IDM_DB_DIALECT=${IDM_DB_DIALECT}
IDM_DB_HOST=${IDM_DB_HOST}
IDM_DB_PORT=${IDM_DB_PORT}
IDM_DB_NAME=${IDM_DB_NAME}
IDM_DB_USER=${IDM_DB_USER}
IDM_DB_PASS=${IDM_DB_PASS}

# Keyrock

IDM_ADMIN_UID=${IDM_ADMIN_UID}
IDM_ADMIN_USER=${IDM_ADMIN_USER}
IDM_ADMIN_EMAIL=${IDM_ADMIN_EMAIL}
IDM_ADMIN_PASS=${IDM_ADMIN_PASS}
IDM_SESSION_SECRET=$(pwgen -s 16 1)
IDM_ENCRYPTION_KEY=$(pwgen -s 16 1)
EOF

  cat <<EOF > "${POSTGRES_DIR}"/init.sql
create role ${IDM_DB_USER} with SUPERUSER CREATEDB login password '${IDM_DB_PASS}';
EOF
}

#
# Up keyrock
#
up_keyrock() {
  logging_info "${FUNCNAME[0]}"

  if ${MULTI_SERVER}; then
    SERVER_HOST="${KEYROCK_HOST}"
  cat <<EOF >> .env

# Keyrock

IDM_HOST=${KEYROCK_HOST}
IDM_ADMIN_EMAIL=${MULTI_SERVER_ADMIN_EMAIL}
IDM_ADMIN_PASS=${MULTI_SERVER_ADMIN_PASS}
EOF
  else
    if "${KEYROCK_POSTGRES}"; then
      up_keyrock_postgres
    else
      up_keyrock_mysql
    fi
    ${DOCKER_COMPOSE} -f docker-idm.yml up -d
    SERVER_HOST="http://localhost:3000"
  fi

  wait "${SERVER_HOST}" "200"

  ${NGSI_GO} server add --host "${IDM}" --serverType keyrock --serverHost "${SERVER_HOST}" --idmType idm --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}"
}

#
# Tear down Keyrock
#
down_keyrock() {
  logging_info "${FUNCNAME[0]}"

  if ${MULTI_SERVER}; then
    return
  fi

  ${DOCKER_COMPOSE} -f docker-idm.yml down
}

#
# Add docker-compose.yml
#
add_docker_compose_yml() {
  logging_info "${FUNCNAME[0]} $1"

  echo "" >> ${DOCKER_COMPOSE_YML}
  sed -e '/^version:/,/services:/d' "${TEMPLEATE}"/docker/"$1" >> ${DOCKER_COMPOSE_YML}
}

#
# Create nginx conf
#
create_nginx_conf() {
  sed -e "s/HOST/$1/" "${TEMPLEATE}/nginx/$2" > "${NGINX_SITES}/$1"
}

#
# Add nginx ports
#
add_nginx_ports() {
  set +u
  while [ "$1" ]
  do
    sed -i -e "/__NGINX_PORTS__/ i \      - $1" ${DOCKER_COMPOSE_YML}
    shift
  done
  set -u
}

#
# Add nginx depends_on
#
add_nginx_depends_on() {
  set +u
  while [ "$1" ]
  do
    sed -i -e "/__NGINX_DEPENDS_ON__/ i \      - $1" ${DOCKER_COMPOSE_YML}
    shift
  done
  set -u
}

#
# Add nginx volumes
#
add_nginx_volumes() {
  set +u
  while [ "$1" ]
  do
    sed -i -e "/__NGINX_VOLUMES__/ i \      - $1" "${DOCKER_COMPOSE_YML}"
    shift
  done
  set -u
}

#
# Add to docker_compose.yml
#
add_to_docker_compose_yml() {
  sed -i -e "/$1/i \ $2" "${DOCKER_COMPOSE_YML}"
}

#
# Add to docker_idm.yml
#
add_to_docker_idm_yml() {
  sed -i -e "/$1/i \ $2" docker-idm.yml
}

#
# Delete from docker_compose.yml
#
delete_from_docker_compose_yml() {
  sed -i -e "/$1/d" "${DOCKER_COMPOSE_YML}"
}

#
# create_dummy_cert
#
create_dummy_cert() {
  logging_info "${FUNCNAME[0]}"

  echo "subjectAltName=IP:${IP_ADDRESS}" > "${WORK_DIR}/ip.txt"

  openssl genrsa 2048 > "${WORK_DIR}/server.key"
  openssl req -new -key "${WORK_DIR}/server.key" << EOF > "${WORK_DIR}/server.csr"
JP
Tokyo
Smart city
Let's FIWARE
FI-BB
${DOMAIN_NAME}
admin@${DOMAIN_NAME}
fiware

EOF

  openssl x509 -days 3650 --extfile "${WORK_DIR}/ip.txt" -req -signkey "${WORK_DIR}/server.key" < "${WORK_DIR}/server.csr" > "${WORK_DIR}/server.crt"
  openssl rsa -in "${WORK_DIR}/server.key" -out "${WORK_DIR}/server.key" << EOF
fiware
EOF

  cp "${WORK_DIR}/server.crt" "${CONFIG_NGINX}/fullchain.pem"
  cp "${WORK_DIR}/server.key" "${CONFIG_NGINX}/privkey.pem"
}

#
# Add exposed ports
#
add_exposed_ports() {
  logging_info "${FUNCNAME[0]}"

  local mode
  local key
  local ports

  mode=$1
  shift
  key=$1
  shift

  case "${mode}" in
    "all" )
      ports="   ports:"
      set +u
      while [ "$1" ]
      do
        ports="${ports}\n      - $1:$1"
        shift
      done
      set -u
      sed -i -e "/${key}/i \ ${ports}" "${DOCKER_COMPOSE_YML}"
      ;;
    "local" )
      ports="   ports:"
      set +u
      while [ "$1" ]
      do
        ports="${ports}\n      - 127.0.0.1:$1:$1"
        shift
      done
      set -u
      sed -i -e "/${key}/i \ ${ports}" "${DOCKER_COMPOSE_YML}"
      ;;
  esac
}

#
# Nginx
#
setup_nginx() {
  logging_info "${FUNCNAME[0]}"

  rm -fr "${NGINX_SITES}"
  mkdir -p "${NGINX_SITES}"

  cp "${TEMPLEATE}"/docker/docker-nginx.yml "${DOCKER_COMPOSE_YML}"

  cp "${TEMPLEATE}"/nginx/default_server "${NGINX_SITES}"

  create_dummy_cert

  add_rsyslog_conf "nginx"
}

#
#  Setup MySQL
#
setup_mysql() {
  logging_info "${FUNCNAME[0]}"

  if "${MYSQL_INSTALLED}"; then
    return
  else
    MYSQL_INSTALLED=true
  fi

  add_docker_compose_yml "docker-mysql.yml"

  add_exposed_ports "${MYSQL_EXPOSE_PORT}" "__MYSQL_PORTS__" "3306"

  sed -i -e "/- IDM_DB_DIALECT/d" ${DOCKER_COMPOSE_YML}
  sed -i -e "/- IDM_DB_PORT/d" ${DOCKER_COMPOSE_YML}

  sed -i -e "/ __KEYROCK_DEPENDS_ON__/s/^.*/      - mysql/" ${DOCKER_COMPOSE_YML}

  add_rsyslog_conf "mysql"
}

#
#  Setup Postgres
#
setup_postgres() {
  logging_info "${FUNCNAME[0]}"

  if "${POSTGRES_INSTALLED}"; then
    return
  else
    POSTGRES_INSTALLED=true
  fi

  add_docker_compose_yml "docker-postgres.yml"

  add_exposed_ports "${POSTGRES_EXPOSE_PORT}" "__POSTGRES_PORTS__" "5432"

  sed -i -e "/ __KEYROCK_DEPENDS_ON__/s/^.*/      - postgres/" ${DOCKER_COMPOSE_YML}

  add_rsyslog_conf "postgres"

  if [ -n "${POSTGRES_PASSWORD}" ]; then
    return
  fi

  POSTGRES_PASSWORD=$(pwgen -s 16 1)

  cat <<EOF >> .env

# Postgres

POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
EOF
}

#
# Setup Elasticsearch
#
setup_elasticsearch() {
  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-elasticsearch.yml"

  add_exposed_ports "${ELASTICSEARCH_EXPOSE_PORT}" "__ELASTICSEARCH_PORTS__" "9200"

  sed -i -e "/ __KEYROCK_DEPENDS_ON__/s/^.*/      - elasticsearch-db/" ${DOCKER_COMPOSE_YML}

  create_nginx_conf "${ELASTICSEARCH}" "nginx-elasticsearch"

  add_rsyslog_conf "elasticsearch-db"

  ELASTICSEARCH_PASSWORD=$(pwgen -s 16 1)

  mkdir -p "${DATA_DIR}"/elasticsearch-db

  cat <<EOF >> .env

# Elasticsearch

ELASTICSEARCH_JAVA_OPTS="${ELASTICSEARCH_JAVA_OPTS}"
ELASTICSEARCH_PASSWORD=${ELASTICSEARCH_PASSWORD}
EOF
}

#
# Wilma
#
setup_wilma() {
  if ${WILMA_INSTALLED}; then
    return
  fi
  WILMA_INSTALLED=true

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-wilma.yml"

  if ! ${MULTI_SERVER}; then
    add_to_docker_compose_yml "__WILMA_DEPENDS_ON__" "   depends_on:\n      - keyrock"
  fi 

  add_nginx_depends_on "wilma"

  add_rsyslog_conf "pep-proxy"

  if  ${MULTI_SERVER}; then
    AID=${MULTI_SERVER_CLIENT_ID}
    SECRET=${MULTI_SERVER_CLIENT_SECRET}
  else
    # Create Applicaton for Orion
    AID=$(${NGSI_GO} applications --host "${IDM}" create --name "Wilma" --description "Wilma application (${HOST_NAME})" --url "http://localhost/" --redirectUri "http://localhost/")
    SECRET=$(${NGSI_GO} applications --host "${IDM}" get --aid "${AID}" | jq -r .application.secret )
  fi

  ORION_CLIENT_ID=${AID}
  ORION_CLIENT_SECRET=${SECRET}

  if  ${MULTI_SERVER}; then
    PEP_PASSWORD=${MULTI_SERVER_PEP_PASSWORD}
    PEP_ID=${MULTI_SERVER_PEP_PROXY_USERNAME}
  else
    # Create PEP Proxy for FIWARE Orion
    PEP_PASSWORD=$(${NGSI_GO} applications --host "${IDM}" pep --aid "${AID}" create --run | jq -r .pep_proxy.password)
    PEP_ID=$(${NGSI_GO} applications --host "${IDM}" pep --aid "${AID}" list | jq -r .pep_proxy.id)
  fi

  if  ${MULTI_SERVER}; then
    PEP_PROXY_IDM_HOST=${KEYROCK}
    PEP_PROXY_IDM_PORT=443
    PEP_PROXY_IDM_SSL_ENABLED=true
  else
    PEP_PROXY_IDM_HOST=keyrock
    PEP_PROXY_IDM_PORT=3000
    PEP_PROXY_IDM_SSL_ENABLED=false
  fi
  cat <<EOF >> .env

# PEP Proxy

PEP_PROXY_IDM_HOST=${PEP_PROXY_IDM_HOST}
PEP_PROXY_IDM_PORT=${PEP_PROXY_IDM_PORT}
PEP_PROXY_IDM_SSL_ENABLED=${PEP_PROXY_IDM_SSL_ENABLED}
PEP_PROXY_APP_ID=${AID}
PEP_PROXY_USERNAME=${PEP_ID}
PEP_PASSWORD=${PEP_PASSWORD}
EOF
}

#
# Tokenproxy
#
setup_tokenproxy() {
  if ${TOKENPROXY}; then
    if ${TOKENPROXY_INSTALLED}; then
      return
    fi
    TOKENPROXY_INSTALLED=true

    logging_info "${FUNCNAME[0]}"

    add_docker_compose_yml "docker-tokenproxy.yml"

    if ! ${MULTI_SERVER}; then
      add_to_docker_compose_yml "__TOKENPROXY_DEPENDS_ON__" "   depends_on:\n      - keyrock"
    fi 

    add_nginx_depends_on "tokenproxy"

    add_rsyslog_conf "tokenproxy"

    cp -r "${SETUP_DIR}"/docker/tokenproxy "${CONFIG_DIR}"/
    cp "${WORK_DIR}"/ngsi "${CONFIG_DIR}"/tokenproxy/

    cd "${CONFIG_DIR}"/tokenproxy > /dev/null
    ${DOCKER} build -t "${IMAGE_TOKENPROXY}" .
    rm -f ngsi
    cd - > /dev/null

    if  ${MULTI_SERVER}; then
      TOKENPROXY_KEYROCK=${MULTI_SERVER_KEYROCK}
    else
      TOKENPROXY_KEYROCK=http://keyrock:3000
    fi

    cat <<EOF >> .env

# Tokenproxy

TOKENPROXY_KEYROCK=${MULTI_SERVER_KEYROCK}
TOKENPROXY_CLIENT_ID=${ORION_CLIENT_ID}
TOKENPROXY_CLIENT_SECRET=${ORION_CLIENT_SECRET}
EOF
  fi
}

#
# Keyrock
#
setup_keyrock() {
  logging_info "${FUNCNAME[0]}"

  if ${MULTI_SERVER}; then
    return
  fi

  add_docker_compose_yml "docker-keyrock.yml"

  create_nginx_conf "${KEYROCK}" "nginx-keyrock"

  add_nginx_depends_on "keyrock"

  add_rsyslog_conf "keyrock"

  echo "${DOMAIN_NAME}" > "${CONFIG_DIR}"/keyrock/whitelist.txt

  cp "${CONTRIB_DIR}/keyrock/list_users.js" "${CONFIG_DIR}/keyrock"
  cp "${CONTRIB_DIR}/keyrock/users.js" "${CONFIG_DIR}/keyrock"
  cp "${CONTRIB_DIR}/keyrock/applications.js" "${CONFIG_DIR}/keyrock"
  cp "${CONTRIB_DIR}/keyrock/version.json" "${CONFIG_DIR}/keyrock"

  add_to_docker_compose_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/whitelist.txt:/opt/fiware-idm/etc/email_list/whitelist.txt"
  add_to_docker_compose_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/list_users.js:/opt/fiware-idm/controllers/web/list_users.js"
  add_to_docker_compose_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/users.js:/opt/fiware-idm/controllers/web/users.js"
  add_to_docker_compose_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/applications.js:/opt/fiware-idm/controllers/api/applications.js"
  add_to_docker_compose_yml "__KEYROCK_VOLUMES__" "     - ${CONFIG_DIR}/keyrock/version.json:/opt/fiware-idm/version.json"
  add_to_docker_compose_yml "__KEYROCK_ENVIRONMENT__" "     - IDM_EMAIL_LIST=whitelist"

  if ${KEYROCK_POSTGRES}; then
    setup_postgres
  else
    setup_mysql
  fi

  setup_wilma

  setup_tokenproxy

  if ${TOKENPROXY}; then
    sed -i -e "/# __NGINX_KEYROCK__/i \  location /token {\n    proxy_pass http://tokenproxy:1029/token;\n    proxy_redirect     default;\n  }" "${NGINX_SITES}/${KEYROCK}"
  fi

  if ! ${IDM_DEBUG}; then
    sed -i "/- DEBUG=idm:\*/d" "${DOCKER_COMPOSE_YML}"
  fi
}

#
# Mongo
#
setup_mongo() {
  if ${MONGO_INSTALLED}; then
    return
  fi
  MONGO_INSTALLED=true

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-mongo.yml"

  add_exposed_ports "${MONGO_EXPOSE_PORT}" "__MONGO_PORTS__" "27017"
  add_rsyslog_conf "mongo"

  mkdir -p "${CONFIG_DIR}/mongo"
}

#
# Orion
#
setup_orion() {
  if [ -z "${ORION}" ]; then
    if [ -n "${MULTI_SERVER_ORION_HOST}" ]; then
      if [ -n "${PERSEO}" ] || [ -n "${IOTAGENT_UL}" ] || [ -n "${IOTAGENT_JSON}" ] || [ -n "${WIRECLOUD}" ]; then
        cat <<EOF >> .env

# Orion Context Broker host

ORION=${MULTI_SERVER_ORION_HOST}
CB_URL=${MULTI_SERVER_ORION_URL}
EOF
      fi
    fi
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-orion.yml"

  add_exposed_ports "${ORION_EXPOSE_PORT}" "__ORION_PORTS__" "1026"

  create_nginx_conf "${ORION}" "nginx-orion"

  add_nginx_depends_on "orion"

  add_rsyslog_conf "orion"

  setup_mongo
  cp "${TEMPLEATE}/mongo/orion.js" "${CONFIG_DIR}/mongo/mongo-init.js"

  setup_wilma

  setup_tokenproxy

  if ${TOKENPROXY}; then
    sed -i -e "/# __NGINX_ORION__/i \  location /token {\n    proxy_pass http://tokenproxy:1029/token;\n    proxy_redirect     default;\n  }\n" "${NGINX_SITES}/${ORION}"
  fi

  CB_URL=https://${ORION}

  cat <<EOF >> .env

# Orion Context Broker host

CB_URL=${CB_URL}
EOF
}

#
# Mintaka
#
setup_mintaka() {
  logging_info "${FUNCNAME[0]}"

  TIMESCALE_USER=orion
  TIMESCALE_PASS=$(pwgen -s 16 1)

  add_docker_compose_yml "docker-mintaka.yml"

  add_exposed_ports "${MINTAKA_EXPOSE_PORT}" "__MINTAKA_PORTS__" "8080"

  add_exposed_ports "${TIMESCALE_EXPOSE_PORT}" "__TIMESCALE_PORTS__" "5432"

  sed -i "/__NGINX_ORION_LD__/r ${SETUP_DIR}/templeate/nginx/nginx-mintaka" "${NGINX_SITES}/${ORION_LD}"

  add_nginx_depends_on "mintaka"

  add_rsyslog_conf "mintaka"

  add_rsyslog_conf "timescale"

  cat <<EOF >> .env

# Mintaka

TIMESCALE_USER=${TIMESCALE_USER}
TIMESCALE_PASS=${TIMESCALE_PASS}
EOF
}

#
# Orion-LD
#
setup_orion_ld() {
  if [ -z "${ORION_LD}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-orion-ld.yml"

  add_exposed_ports "${ORION_LD_EXPOSE_PORT}" "__ORION_LD_PORTS__" "1026"

  create_nginx_conf "${ORION_LD}" "nginx-orion-ld"

  add_nginx_depends_on "orion-ld"

  add_rsyslog_conf "orion-ld"

  setup_mongo
  cp "${TEMPLEATE}/mongo/orion-ld.js" "${CONFIG_DIR}/mongo/mongo-init.js"

  setup_wilma

  setup_tokenproxy

  if ${TOKENPROXY}; then
    sed -i -e "/# __NGINX_ORION_LD__/i \  location /token {\n    proxy_pass http://tokenproxy:1029/token;\n    proxy_redirect     default;\n  }\n" "${NGINX_SITES}/${ORION_LD}"
  fi

  CB_LD_URL=https://${ORION_LD}

  cat <<EOF >> .env

# Orion-LD Context Broker host

CB_LD_URL=${CB_LD_URL}
EOF

  if ${MINTAKA}; then
    setup_mintaka
  fi
}

#
# Queryproxy
#
setup_queryproxy() {
  if ! ${QUERYPROXY}; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  cp -r "${SETUP_DIR}"/docker/queryproxy "${CONFIG_DIR}"/
  cp "${WORK_DIR}"/ngsi "${CONFIG_DIR}"/queryproxy/

  cd "${CONFIG_DIR}"/queryproxy > /dev/null
  ${DOCKER} build -t "${IMAGE_QUERYPROXY}" .
  rm -f ngsi
  cd - > /dev/null

  add_docker_compose_yml "docker-queryproxy.yml"

  add_nginx_depends_on "queryproxy"

  add_rsyslog_conf "queryproxy"

  cat <<EOF > "${WORK_DIR}"/nginx_queryproxy
  location /v2/ex/entities {
    set \$req_uri "\$uri";
    auth_request /_check_oauth2_token;

    proxy_pass http://queryproxy:1030;
    proxy_redirect     default;
  }

  location /health {
    set \$req_uri "\$uri";
    auth_request /_check_oauth2_token;

    proxy_pass http://queryproxy:1030;
    proxy_redirect     default;
  }

EOF

  sed -i -e "/# __NGINX_ORION__/r ${WORK_DIR}/nginx_queryproxy" "${NGINX_SITES}/${ORION}"
}

#
# Regproxy
#
setup_regproxy() {
  if ! ${REGPROXY}; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  cp -r "${SETUP_DIR}"/docker/regproxy "${CONFIG_DIR}"/
  cp "${WORK_DIR}"/ngsi "${CONFIG_DIR}"/regproxy/

  cd "${CONFIG_DIR}"/regproxy > /dev/null
  ${DOCKER} build -t "${IMAGE_REGPROXY}" .
  rm -f ngsi
  cd - > /dev/null

  add_docker_compose_yml "docker-regproxy.yml"

  add_nginx_depends_on "regproxy"

  add_to_docker_compose_yml "__ORION_DEPENDS_ON__" "     - regproxy"

  add_rsyslog_conf "regproxy"

  REGPROXY_NGSITYPE="${REGPROXY_NGSITYPE:-v2}"
  : "${REGPROXY_HOST:?REGPROXY_HOST missing}"
  : "${REGPROXY_IDMTYPE:?REGPROXY_IDMTYPE missing}"
  : "${REGPROXY_IDMHOST:?REGPROXY_IDMHOST missing}"
  : "${REGPROXY_USERNAME:?REGPROXY_USERNAME missing}"
  : "${REGPROXY_PASSWORD:?REGPROXY_PASSWORD missing}"
  REGPROXY_CLIENT_ID="${REGPROXY_CLIENT_ID:-}"
  REGPROXY_CLIENT_SECRET="${REGPROXY_CLIENT_SECRET:-}"
  LOG_LEVEL="${LOG_LEVEL:-info}"

  cat <<EOF >> .env

# Regproxy

REGPROXY_HOST=${REGPROXY_HOST}
REGPROXY_NGSITYPE=${REGPROXY_NGSITYPE}
REGPROXY_IDMTYPE=${REGPROXY_IDMTYPE}
REGPROXY_IDMHOST=${REGPROXY_IDMHOST}
REGPROXY_USERNAME=${REGPROXY_USERNAME}
REGPROXY_PASSWORD=${REGPROXY_PASSWORD}
REGPROXY_CLIENT_ID=${REGPROXY_CLIENT_ID}
REGPROXY_CLIENT_SECRET=${REGPROXY_CLIENT_SECRET}
REGPROXY_LOGLEVEL=${REGPROXY_LOGLEVEL}
REGPROXY_VERBOSE=${REGPROXY_VERBOSE}
EOF
}

#
# Cygnus
#
setup_cygnus() {
  if [ -z "${CYGNUS}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-cygnus.yml"

  local sink
  sink=0

  local expose_ports
  expose_ports=

  if ${CYGNUS_MONGO}; then
    sink=$((sink+1))
    setup_mongo
    sed -i -e "/__CYGNUS_DEPENDS_ON__/i \      - mongo" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_MONGO_SERVICE_PORT=5051" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_MONGO_HOSTS=mongo:27017" "${DOCKER_COMPOSE_YML}"
    expose_ports="${expose_ports} 5051"
  fi

  if ${CYGNUS_MYSQL}; then
    sink=$((sink+1))
    setup_mysql
    sed -i -e "/__CYGNUS_DEPENDS_ON__/i \      - mysql" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_MYSQL_SERVICE_PORT=5050" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_MYSQL_HOST=mysql" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_MYSQL_PORT=3306" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_MYSQL_USER=root" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_MYSQL_PASS=\${MYSQL_ROOT_PASSWORD}" "${DOCKER_COMPOSE_YML}"
    expose_ports="${expose_ports} 5050"
  fi

  if ${CYGNUS_POSTGRES}; then
    sink=$((sink+1))
    setup_postgres
    sed -i -e "/__CYGNUS_DEPENDS_ON__/i \      - postgres" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_POSTGRESQL_SERVICE_PORT=5055" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_POSTGRESQL_HOST=postgres" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_POSTGRESQL_PORT=5432" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_POSTGRESQL_USER=postgres" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_POSTGRESQL_PASS=\${POSTGRES_PASSWORD}" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_POSTGRESQL_ENABLE_CACHE=true" "${DOCKER_COMPOSE_YML}"
    expose_ports="${expose_ports} 5055"
  fi

  if ${CYGNUS_ELASTICSEARCH}; then
    sink=$((sink+1))
    setup_elasticsearch
    sed -i -e "/__CYGNUS_DEPENDS_ON__/i \      - elasticsearch-db" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_ELASTICSEARCH_HOST=elasticsearch-db:9200" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_ELASTICSEARCH_PORT=5058" "${DOCKER_COMPOSE_YML}"
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_ELASTICSEARCH_SSL=false" "${DOCKER_COMPOSE_YML}"
    expose_ports="${expose_ports} 5058"
  fi

  if [ $sink -ge 2 ]; then
    sed -i -e "/__CYGNUS_ENVIRONMENT__/i \      - CYGNUS_MULTIAGENT=true" "${DOCKER_COMPOSE_YML}"
  fi

  # shellcheck disable=SC2086
  add_exposed_ports "${CYGNUS_EXPOSE_PORT}" "__CYGNUS_PORTS__" ${expose_ports}

  create_nginx_conf "${CYGNUS}" "nginx-cygnus"

  add_nginx_depends_on "cygnus"

  add_rsyslog_conf "cygnus"

  setup_wilma
}

#
# Comet
#
setup_comet() {
  if [ -z "${COMET}" ]; then
    return
  fi 

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-comet.yml"

  add_exposed_ports "${COMET_EXPOSE_PORT}" "__COMET_PORTS__" "8666"

  create_nginx_conf "${COMET}" "nginx-comet"

  add_nginx_depends_on "comet"

  if [ -n "${CYGNUS}" ]; then
    add_to_docker_compose_yml "__COMET_DEPENDS_ON__" "     - cygnus"
  fi

  add_rsyslog_conf "comet"

  setup_wilma
}

#
# QuantumLeap
#
setup_quantumleap() {
  if [ -z "${QUANTUMLEAP}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-quantumleap.yml"

  add_exposed_ports "${QUANTUMLEAP_EXPOSE_PORT}" "__QUANTUMLEAP_PORTS__" "8668"

  create_nginx_conf "${QUANTUMLEAP}" "nginx-quantumleap"

  add_nginx_depends_on  "quantumleap"

  add_rsyslog_conf "quantumleap" "redis" "crate"

  # Workaround for CrateDB. See https://crate.io/docs/crate/howtos/en/latest/deployment/containers/docker.html#troubleshooting
  ${SUDO} sysctl -w vm.max_map_count=262144

  setup_wilma
}

#
# Perseo
#
setup_perseo() {
  if [ -z "${PERSEO}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-perseo.yml"

  create_nginx_conf "${PERSEO}" "nginx-perseo"

  add_nginx_depends_on "perseo-fe"

  add_rsyslog_conf "perseo-fe" "perseo-core"

  if [ -z "${PERSEO_MAX_AGE}" ]; then
    PERSEO_MAX_AGE=6000
  fi

  if [ -z "${PERSEO_LOG_LEVEL}" ]; then
    PERSEO_LOG_LEVEL=info
  fi

  cat <<EOF >> .env

# Perseo
PERSEO_MAX_AGE=${PERSEO_MAX_AGE}
PERSEO_LOG_LEVEL=${PERSEO_LOG_LEVEL}
EOF

  if [ -n "${PERSEO_SMTP_HOST}" ]; then
    sed -i -e "/__PERSEO_FE_ENVIRONMENT__/i \      - PERSEO_SMTP_HOST=\${PERSEO_SMTP_HOST}" "${DOCKER_COMPOSE_YML}"
    echo "PERSEO_SMTP_HOST=${PERSEO_SMTP_HOST}" >> .env
  fi

  if [ -n "${PERSEO_SMTP_PORT}" ]; then
    sed -i -e "/__PERSEO_FE_ENVIRONMENT__/i \      - PERSEO_SMTP_PORT=\${PERSEO_SMTP_PORT}" "${DOCKER_COMPOSE_YML}"
    echo "PERSEO_SMTP_PORT=${PERSEO_SMTP_PORT}" >> .env
  fi

  if [ -n "${PERSEO_SMTP_SECURE}" ]; then
    sed -i -e "/__PERSEO_FE_ENVIRONMENT__/i \      - PERSEO_SMTP_SECURE=\${PERSEO_SMTP_SECURE}" "${DOCKER_COMPOSE_YML}"
    echo "PERSEO_SMTP_SECURE=${PERSEO_SMTP_SECURE}" >> .env
  fi

  setup_mongo

  setup_wilma
}

#
# patch widget
#
patch_widget() {
  local widget widget_path patch_dir ql_patch

  widget=$1
  widget_path=$(cd "$(dirname "$2")"; pwd)/$(basename "$2")
  patch_dir="${WORK_DIR}/widget_patch"
  ql_patch="\"URL of the QuantumLeap server to use for retrieving entity information\"\\n                default="

  local orion_url
  local quantumleap_url

  orion_url=${MULTI_SERVER_ORION_URL}
  if [ -z "${orion_url}" ]; then
    orion_url=https://${ORION}
  fi

  quantumleap_url=${MULTI_SERVER_QUANTUMLEAP_URL}
  if [ -z "${quantumleap_url}" ]; then
    quantumleap_url=https://${QUANTUMLEAP}
  fi

  for name in ngsi-browser ngsi-source ngsi-type-browser quantumleap-source
  do
    # shellcheck disable=SC2143
    if [ "$(echo "${widget}" | grep "${name}")" ]; then
      logging_info "Patch ${name}"
      mkdir "${patch_dir}"
      cd "${patch_dir}"
      unzip "${widget_path}" > /dev/null
      sed -i "s%http://orion.lab.fiware.org:1026%${orion_url}%" config.xml
      sed -i "s%ngsiproxy.lab.fiware.org%${NGSIPROXY}%" config.xml
      sed -i ":l; N; s%${ql_patch}\"\"%${ql_patch}\"${quantumleap_url}\"%; b l;" config.xml
      rm "${widget_path}"
      # shellcheck disable=SC2035
      zip -r "${widget_path}" -b /tmp * > /dev/null
      cd - > /dev/null
      rm -fr "${patch_dir}"
      return
  fi
  done
}

#
# install widgets for WireCloud
#
install_widgets_for_wirecloud() {
  if [ -z "${WIRECLOUD}" ]; then
    return
  fi

  if ${SKIP_INSTALL_WIDGET}; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  wait "https://${WIRECLOUD}/" "200"

  sleep 1

  local found
  local ql_installed
  ql_installed=false
  if [ -n "${QUANTUMLEAP}" ] || [ -n "${MULTI_SERVER_QUANTUMLEAP_URL}" ]; then
    ql_installed=true
  fi

  # shellcheck disable=SC2002
  cat "${SETUP_DIR}/widgets_list.txt" | while read -r line
  do
    set +e
    found=$(echo "${line}" | grep -ic QUANTUMLEAP)
    set -e
    if "${ql_installed}" || [ "${found}" -eq 0 ]; then
      name="$(basename "${line}")"
      logging_info "Installing ${name}"
      fullpath="${WIDGET_DIR}/${name}"

      curl -sL "${line}" -o "${fullpath}"
      patch_widget "${name}" "${fullpath}"
      ${DOCKER_COMPOSE} exec --tty wirecloud python manage.py addtocatalogue --public "/widgets/${name}"
    fi
  done
}

#
# WireCLoud and ngsiproxy
#
setup_wirecloud() {
  if [ -z "${WIRECLOUD}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-wirecloud.yml"

  local aid
  local secret
  local rid

  # Create Applicaton for WireCloud
  aid=$(${NGSI_GO} applications --host "${IDM}" create --name "WireCloud" --description "WireCloud application (${HOST_NAME})" --url "https://${WIRECLOUD}/" --redirectUri "https://${WIRECLOUD}/complete/fiware/")
  secret=$(${NGSI_GO} applications --host "${IDM}" get --aid "${aid}" | jq -r .application.secret)
  rid=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${aid}" create --name Admin)
  ${NGSI_GO} applications --host "${IDM}" users --aid "${aid}" assign --rid "${rid}" --uid "${IDM_ADMIN_UID}" > /dev/null

  # Add WireCloud application as a trusted application to WireCloud application
  ${NGSI_GO} applications --host "${IDM}" trusted --aid "${ORION_CLIENT_ID}" add --tid "${aid}"  > /dev/null

  create_nginx_conf "${WIRECLOUD}" "nginx-wirecloud"
  create_nginx_conf "${NGSIPROXY}" "nginx-ngsiproxy"

  add_nginx_depends_on "wirecloud" "ngsiproxy"

  add_nginx_volumes "./data/wirecloud/wirecloud-static:/var/www/static:ro"

  add_rsyslog_conf "wirecloud" "elasticsearch" "memcached" "ngsiproxy"

  WIDGET_DIR="${DATA_DIR}/wirecloud/widgets"
  mkdir -p "${WIDGET_DIR}"

  WIRECLOUD_CLIENT_ID=${aid}
  WIRECLOUD_CLIENT_SECRET=${secret}

  cat <<EOF >> .env

# WireCloud 

WIRECLOUD_CLIENT_ID=${WIRECLOUD_CLIENT_ID}
WIRECLOUD_CLIENT_SECRET=${WIRECLOUD_CLIENT_SECRET}
EOF

  setup_postgres

  if $FIBB_TEST; then
    add_to_docker_compose_yml "__WIRECLOUD_ENVIRONMENT__" "     - REQUESTS_CA_BUNDLE=/root_ca/root-ca.crt"
    add_to_docker_compose_yml "__WIRECLOUD_VOLUMES__" "     - \${CONFIG_DIR}/root_ca/root-ca.crt:/root_ca/root-ca.crt"
  fi
}

#
# mosquitto
#
setup_mosquitto() {
  logging_info "${FUNCNAME[0]}"

  if "${MOSQUITTO_INSTALLED}"; then
    return
  else
    MOSQUITTO_INSTALLED=true
  fi

  add_docker_compose_yml "docker-mosquitto.yml"

  add_nginx_depends_on "mosquitto"

  add_rsyslog_conf "mosquitto"

  mkdir -p "${CONFIG_DIR}"/mosquitto
  cd "${CONFIG_DIR}"/mosquitto
  local dir
  dir=$PWD  
  cd - > /dev/null

  if [ -z "${MQTT_USERNAME}" ]; then
    MQTT_USERNAME=fiware
  fi
  if [ -z "${MQTT_PASSWORD}" ]; then
    MQTT_PASSWORD=$(pwgen -s 16 1)
  fi
  echo "${MQTT_USERNAME}:${MQTT_PASSWORD}" > "${dir}"/password.txt

  cat <<EOF >> .env

# MQTT

MQTT_USERNAME=${MQTT_USERNAME}
MQTT_PASSWORD=${MQTT_PASSWORD}
MQTT_1883=${MQTT_1883}
MQTT_TLS=${MQTT_TLS}
EOF

  ${DOCKER} run --rm -v "${dir}":/work "${IMAGE_MOSQUITTO}" mosquitto_passwd -U /work/password.txt

  cat <<EOF > "${dir}/mosquitto.conf"
persistence true
persistence_location /mosquitto/data/

log_dest stdout

listener 1883

allow_anonymous false
password_file /mosquitto/config/password.txt

connection_messages true
log_timestamp true
EOF

  local log_types
  local log_type

  # shellcheck disable=SC2206
  log_types=(${MOSQUITTO_LOG_TYPE//,/ })

  for log_type in "${log_types[@]}"
  do
    echo "log_type ${log_type}" >> "${dir}/mosquitto.conf"
  done

  # Add nginx.conf to mosquitto configuration
  local nginx_conf
  nginx_conf="${CONFIG_DIR}"/nginx/nginx.conf

  cat <<EOF >> "${nginx_conf}"

stream {
    upstream mqtt {
      server mosquitto:1883;
    }
EOF

  if ${MQTT_1883}; then
    add_nginx_ports "1883:1883"

    echo "MQTT_PORT=1883" >> .env

    cat <<EOF >> "${CONFIG_DIR}"/nginx/nginx.conf
    server {
      listen 1883;
      proxy_pass mqtt;
    }
EOF
  fi

  if ${MQTT_TLS}; then 
    # ISRG Root X1 - https://letsencrypt.org/certificates/
    local file
    file="${dir}/isrgrootx1.pem"
    curl -s https://letsencrypt.org/certs/isrgrootx1.pem -o "${file}"
    echo "ROOT_CA=${file}" >> .env

    add_nginx_ports "8883:8883"

    echo "MQTT_TLS_PORT=8883" >> .env

    cat <<EOF >> "${CONFIG_DIR}"/nginx/nginx.conf
    server {
      listen 8883 ssl;
      proxy_pass mqtt;
      ssl_certificate ${CERT_DIR}/live/${MOSQUITTO}/fullchain.pem;
      ssl_certificate_key ${CERT_DIR}/live/${MOSQUITTO}/privkey.pem;
    }
EOF
  fi

echo "}" >> "${nginx_conf}"
}

#
# Iot Agent over HTTP
#
setup_iotagent_over_http() {
  if ! ${IOTAGENT_HTTP_INSTALLED}; then
    IOTAGENT_HTTP_INSTALLED=true
    create_nginx_conf "${IOTAGENT_HTTP}" "nginx-iotagent-http"
  cat <<EOF >> .env

# IoT Agent over HTTP

IOTA_HTTP_AUTH=${IOTA_HTTP_AUTH}
EOF
  if [ "${IOTA_HTTP_AUTH}" = "basic" ]; then
    echo "${IOTA_HTTP_BASIC_USER}":"$(openssl passwd -6 "${IOTA_HTTP_BASIC_PASS}")" >> "${CONFIG_NGINX}"/.htpasswd
    add_nginx_volumes "${CONFIG_NGINX}/.htpasswd:/etc/nginx/.htpasswd:ro"
    cat <<EOF >> .env
IOTA_HTTP_BASIC_USER=${IOTA_HTTP_BASIC_USER}
IOTA_HTTP_BASIC_PASS=${IOTA_HTTP_BASIC_PASS}
EOF
    fi
  fi

  case "${IOTA_HTTP_AUTH}" in
    "none" ) sed -i -e "/__NGINX_IOTAGENT_HTTP__/i \  location $1 {\n    proxy_pass $2$1;\n  }" "${NGINX_SITES}/${IOTAGENT_HTTP}" ;;
    "basic" ) sed -i -e "/__NGINX_IOTAGENT_HTTP__/i \  location $1 {\n    auth_basic \"Restricted\";\n    auth_basic_user_file /etc/nginx/.htpasswd;\n\n    proxy_pass $2$1;\n  }" "${NGINX_SITES}/${IOTAGENT_HTTP}" ;;
    * ) sed -i -e "/__NGINX_IOTAGENT_HTTP__/i \  location $1 {\n    set \$req_uri \"\$uri\";\n    auth_request /_check_oauth2_token;\n\n    proxy_pass $2$1;\n  }" "${NGINX_SITES}/${IOTAGENT_HTTP}" ;;
  esac
}

#
# Create openiot mongo index
#
create_openiot_mongo_index() {
  if ${OPENIOT_MONGO_INDEX}; then
    return
  fi
  OPENIOT_MONGO_INDEX=true
  cat "${TEMPLEATE}/mongo/orion-openiot.js" >> "${CONFIG_DIR}/mongo/mongo-init.js"
}

#
# IoT Agent for UltraLight 2.0
#
setup_iotagent_ul() {
  if [ -z "${IOTAGENT_UL}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-iotagent-ul.yml"

  create_nginx_conf "${IOTAGENT_UL}" "nginx-iotagent-ul"

  add_nginx_depends_on "iotagent-ul"

  add_rsyslog_conf "iotagent-ul"

  setup_mongo
  create_openiot_mongo_index
  cat "${TEMPLEATE}/mongo/iotagentul.js" >> "${CONFIG_DIR}/mongo/mongo-init.js"

  cat <<EOF >> .env

# IoT Agent for UltraLight 2.0

IOTA_UL_DEFAULT_RESOURCE=${IOTA_UL_DEFAULT_RESOURCE}
IOTA_UL_LOG_LEVEL=${IOTA_UL_LOG_LEVEL}
IOTA_UL_TIMESTAMP=${IOTA_UL_TIMESTAMP}
IOTA_UL_AUTOCAST=${IOTA_UL_AUTOCAST}
EOF

  if [ -n "${IOTAGENT_HTTP}" ]; then
    add_to_docker_compose_yml "__IOTA_UL_ENVIRONMENT__" "     - IOTA_HTTP_PORT=7896"
    setup_iotagent_over_http "${IOTA_UL_DEFAULT_RESOURCE}" "http://iotagent-ul:7896"
  fi

  if [ -n "${MOSQUITTO}" ]; then
    setup_mosquitto

    add_to_docker_compose_yml "__IOTA_UL_DEPENDS_ON__" "     - mosquitto"
    add_to_docker_compose_yml "__IOTA_UL_ENVIRONMENT__" "     - IOTA_MQTT_HOST=mosquitto"
    add_to_docker_compose_yml "__IOTA_UL_ENVIRONMENT__" "     - IOTA_MQTT_PORT=1883"
    add_to_docker_compose_yml "__IOTA_UL_ENVIRONMENT__" "     - IOTA_MQTT_USERNAME=\${MQTT_USERNAME}"
    add_to_docker_compose_yml "__IOTA_UL_ENVIRONMENT__" "     - IOTA_MQTT_PASSWORD=\${MQTT_PASSWORD}"
  fi

  setup_wilma
}

#
# IoT Agent for JSON
#
setup_iotagent_json() {
  if [ -z "${IOTAGENT_JSON}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-iotagent-json.yml"

  create_nginx_conf "${IOTAGENT_JSON}" "nginx-iotagent-json"

  add_nginx_depends_on "iotagent-json"

  add_rsyslog_conf "iotagent-json"

  setup_mongo
  create_openiot_mongo_index
  cat "${TEMPLEATE}/mongo/iotagentjson.js" >> "${CONFIG_DIR}/mongo/mongo-init.js"

  cat <<EOF >> .env

# IoT Agent for JSON

IOTA_JSON_DEFAULT_RESOURCE=${IOTA_JSON_DEFAULT_RESOURCE}
IOTA_JSON_LOG_LEVEL=${IOTA_JSON_LOG_LEVEL}
IOTA_JSON_TIMESTAMP=${IOTA_JSON_TIMESTAMP}
IOTA_JSON_AUTOCAST=${IOTA_JSON_AUTOCAST}
EOF

  if [ -n "${IOTAGENT_HTTP}" ]; then
    add_to_docker_compose_yml "__IOTA_JSON_ENVIRONMENT__" "     - IOTA_HTTP_PORT=7896"
    setup_iotagent_over_http "${IOTA_JSON_DEFAULT_RESOURCE}" "http://iotagent-json:7896"
  fi

  if [ -n "${MOSQUITTO}" ]; then
    setup_mosquitto

    add_to_docker_compose_yml "__IOTA_JSON_DEPENDS_ON__" "     - mosquitto"
    add_to_docker_compose_yml "__IOTA_JSON_ENVIRONMENT__" "     - IOTA_MQTT_HOST=mosquitto"
    add_to_docker_compose_yml "__IOTA_JSON_ENVIRONMENT__" "     - IOTA_MQTT_PORT=1883"
    add_to_docker_compose_yml "__IOTA_JSON_ENVIRONMENT__" "     - IOTA_MQTT_USERNAME=\${MQTT_USERNAME}"
    add_to_docker_compose_yml "__IOTA_JSON_ENVIRONMENT__" "     - IOTA_MQTT_PASSWORD=\${MQTT_PASSWORD}"
  fi

  setup_wilma
}

#
# Setup draco
#
setup_draco() {
  if [ -z "${DRACO}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-draco.yml"

  if ${DRACO_MONGO}; then
    setup_mongo
    sed -i -e "/__DRACO_DEPENDS_ON__/i \      - mongo" "${DOCKER_COMPOSE_YML}"
  fi

  if ${DRACO_MYSQL}; then
    setup_mysql

    DRACO_MYSQL_USER=root
    DRACO_MYSQL_PASS="${MYSQL_ROOT_PASSWORD}"

    sed -i -e "/__DRACO_DEPENDS_ON__/i \      - mysql" "${DOCKER_COMPOSE_YML}"
  fi

  if ${DRACO_POSTGRES}; then
    setup_postgres

    DRACO_POSTGRES_USER=postgres
    DRACO_POSTGRES_PASS="${POSTGRES_PASSWORD}"

    sed -i -e "/__DRACO_DEPENDS_ON__/i \      - postgres" "${DOCKER_COMPOSE_YML}"
  fi

  # shellcheck disable=SC2086
  add_exposed_ports "${DRACO_EXPOSE_PORT}" "__DRACO_PORTS__" "5050"

  create_nginx_conf "${DRACO}" "nginx-draco"

  add_nginx_depends_on "draco"

  add_rsyslog_conf "draco"

  DRACO_DISABLE_NIFI_DOCS=${DRACO_DISABLE_NIFI_DOCS:-false}

  if "${DRACO_DISABLE_NIFI_DOCS}"; then
    sed -i -e "/# __NGINX_DRACO__/i \  location /nifi-docs/ {\n    return 404;\n  }\n" "${NGINX_SITES}/${DRACO}"
  fi

  local draco_cert
  draco_cert="${CONFIG_DIR}/draco/cert"

  mkdir -p "${draco_cert}"
  mkdir -p "${DATA_DIR}"/draco/conf/templates

  local draco_containter
  draco_container=draco_"$$"

  ${DOCKER} run -d --rm --tty --name "${draco_container}" --entrypoint=/usr/bin/tail "${IMAGE_DRACO}" -f /opt/nifi/nifi-current/conf/bootstrap.conf
  sleep 3
  docker cp "${draco_container}":/opt/nifi/scripts/secure.sh "${CONFIG_DIR}"/draco/secure.sh
  sed -e 1d "${SETUP_DIR}"/draco/nifi-patch.sh >> "${CONFIG_DIR}"/draco/secure.sh

  local file

  for file in $(${DOCKER} exec "${draco_container}" ls -1F conf | grep -v /)
  do
    ${DOCKER} cp "${draco_container}":/opt/nifi/nifi-current/conf/"${file}" "${DATA_DIR}"/draco/conf
  done

  for file in MONGO-TUTORIAL.xml MULTIPLE-SINKS-TUTORIAL.xml MYSQL-TUTORIAL.xml ORION-TO-CASSANDRA.xml ORION-TO-MONGO.xml ORION-TO-MYSQL.xml ORION-TO-POSTGRESQL.xml POSTGRES-TUTORIAL.xml
  do
    ${DOCKER} cp "${draco_container}":/opt/nifi/nifi-current/conf/templates/"${file}" "${DATA_DIR}"/draco/conf/templates
    patch "${DATA_DIR}/draco/conf/templates/${file}" "${SETUP_DIR}/draco/${file}.patch"
  done

  ${DOCKER} stop "${draco_container}"

  set +e
  ${DOCKER} run --rm --tty --entrypoint /bin/sh \
    -v "${draco_cert}":/opt/nifi/nifi-current/localhost \
    "${IMAGE_DRACO}" /opt/nifi/nifi-toolkit-current/bin/tls-toolkit.sh \
    standalone \
    --hostnames localhost \
    --isOverwrite
  set -e

  # Update host information
  DRACO_MONGO_HOST=${DRACO_MONGO_HOST:-mongo}
  DRACO_MONGO_PORT=${DRACO_MONGO_PORT:-27017}
  DRACO_MONGO="${DRACO_MONGO_USER}:${DRACO_MONGO_PASS}@${DRACO_MONGO_HOST}:${DRACO_MONGO_PORT}"

  if [ -z "${DRACO_MONGO_USER}" ] || [ -z "${DRACO_MONGO_PASS}" ]; then
    DRACO_MONGO="${DRACO_MONGO_HOST}:${DRACO_MONGO_PORT}"
  fi

  DRACO_MYSQL_HOST=${DRACO_MYSQL_HOST:-mysql}
  DRACO_MYSQL_PORT=${DRACO_MYSQL_PORT:-3306}
  DRACO_MYSQL="${DRACO_MYSQL_HOST}:${DRACO_MYSQL_PORT}"
  DRACO_MYSQL_USER=${DRACO_MYSQL_USER:-root}
  DRACO_MYSQL_PASS=${DRACO_MYSQL_PASS:-mysql}

  DRACO_POSTGRES_HOST=${DRACO_POSTGRES_HOST:-postgres}
  DRACO_POSTGRES_PORT=${DRACO_POSTGRES_PORT:-5432}
  DRACO_POSTGRES="${DRACO_POSTGRES_HOST}:${DRACO_POSTGRES_PORT}"
  DRACO_POSTGRES_USER=${DRACO_POSTGRES_USER:-postgres}
  DRACO_POSTGRES_PASS=${DRACO_POSTGRES_PASS:-postgres}
 
  DRACO_CASSANDRA_HOST=${DRACO_CASSANDRA_HOST:-cassandra}
  DRACO_CASSANDRA_PORT=${DRACO_CASSANDRA_PORT:-9042}
  DRACO_CASSANDRA="${DRACO_CASSANDRA_HOST}:${DRACO_CASSANDRA_PORT}"

  TEMPLATES="${DATA_DIR}/draco/conf/templates"

  for file in MULTIPLE-SINKS-TUTORIAL.xml MONGO-TUTORIAL.xml ORION-TO-MONGO.xml
  do
    sed -i -e "s/MONGO_HOST/${DRACO_MONGO}/" "${TEMPLATES}/${file}"
  done

  for file in MULTIPLE-SINKS-TUTORIAL.xml MYSQL-TUTORIAL.xml ORION-TO-MYSQL.xml
  do
    sed -i -e "s/MYSQL_HOST/${DRACO_MYSQL}/" \
           -e "s/MYSQL_USER/${DRACO_MYSQL_USER}/" \
           -e "s/MYSQL_PASSWORD/${DRACO_MYSQL_PASS}/" "${TEMPLATES}/${file}"
  done

  for file in MULTIPLE-SINKS-TUTORIAL.xml POSTGRES-TUTORIAL.xml ORION-TO-POSTGRESQL.xml
  do
    sed -i -e "s/POSTGRES_HOST/${DRACO_POSTGRES}/" \
           -e "s/POSTGRES_USER/${DRACO_POSTGRES_USER}/" \
           -e "s/POSTGRES_PASSWORD/${DRACO_POSTGRES_PASS}/" "${TEMPLATES}/${file}"
  done

  sed -i -e "s/CASSANDRA_HOST/${DRACO_CASSANDRA}/" "${TEMPLATES}/ORION-TO-CASSANDRA.xml"

  # Create application for Draco
  DRACO_ROOT_URL=https://${DRACO}/
  DRACO_REDIRECT_URL=https://${DRACO}:443/nifi-api/access/oidc/callback
  set +e
  DRACO_OIDC_CLIENT_ID=$(${NGSI_GO} applications --host "${IDM}" create --name "Draco" --description "Draco application (${HOST_NAME})" --url "${DRACO_ROOT_URL}" --redirectUri "${DRACO_REDIRECT_URL}" --openid)
  DRACO_OIDC_CLIENT_SECRET=$(${NGSI_GO} applications --host "${IDM}" get --aid "${DRACO_OIDC_CLIENT_ID}" | jq -r .application.secret )

  DRACO_OIDC_DISCOVERY_URL="https://${KEYROCK}/idm/applications/${DRACO_OIDC_CLIENT_ID}/.well-known/openid-configuration"
  DRACO_KEYSTORE_PASSWORD=$(sed -n "/^nifi.security.keystorePasswd=/s/\(.*\)=\(.*\)/\2/p" "${draco_cert}/nifi.properties")
  DRACO_TRUSTSTORE_PASSWORD=$(sed -n "/^nifi.security.truststorePasswd=/s%\(.*\)=\(.*\)%\2%p" "${draco_cert}/nifi.properties")
  set -e

  cat <<EOF >> .env

DRACO_KEYSTORE_PASSWORD=${DRACO_KEYSTORE_PASSWORD}
DRACO_TRUSTSTORE_PASSWORD=${DRACO_TRUSTSTORE_PASSWORD}
DRACO_OIDC_DISCOVERY_URL=${DRACO_OIDC_DISCOVERY_URL}
DRACO_OIDC_CLIENT_ID=${DRACO_OIDC_CLIENT_ID}
DRACO_OIDC_CLIENT_SECRET=${DRACO_OIDC_CLIENT_SECRET}
EOF
}

#
# Create API role for Node-RED
#
create_node_red_api_role() {
  logging_info "${FUNCNAME[0]}"

  local idm
  local orion_client_id
  idm=$1
  orion_client_id=$2

  ORION_RID_API=$(${NGSI_GO} applications --host "${idm}" roles --aid "${orion_client_id}" create --name "/node-red/api")
}

#
# Node-RED multi instance
#
setup_node_red_multi_instance() {
  logging_info "${FUNCNAME[0]}"

  local http_node_root
  local http_admin_root
  local username
  local number
  local env_val
  local node_red_yml
  local node_red_nginx

  node_red_yaml="${TEMPLEATE}"/docker/docker-node-red.yml

  create_nginx_conf "${NODE_RED}" "nginx-node-red"

  node_red_nginx="${NGINX_SITES}/${NODE_RED}"

  rm -f "${NODE_RED_USERS_TEXT}"

  cat <<EOF >> .env

# Node-RED

EOF

  create_node_red_api_role "${IDM}" "${ORION_CLIENT_ID}"

  for i in $(seq "${NODE_RED_INSTANCE_NUMBER}")
  do
    number=$(printf "%03d" "$i")
    http_node_root=${NODE_RED_INSTANCE_HTTP_ADMIN_ROOT}${number}${NODE_RED_INSTANCE_HTTP_NODE_ROOT}
    http_admin_root=${NODE_RED_INSTANCE_HTTP_ADMIN_ROOT}${number}
    username=${NODE_RED_INSTANCE_USERNAME}${number}
    env_val=NODE_RED_${number}_
 
    echo "" >> ${DOCKER_COMPOSE_YML}

    sed "s/node-red/${username}/" "${node_red_yaml}" | \
    sed "s/letsfiware\/node-red[0-9][0-9]*:/letsfiware\/node-red:/" | \
    sed "/NODE_RED_CLIENT_ID/s/NODE_RED_/${env_val}/g" | \
    sed "/NODE_RED_CLIENT_SECRET/s/NODE_RED_/${env_val}/g" | \
    sed "/NODE_RED_CALLBACK_URL/s/NODE_RED_/${env_val}/g" | \
    sed "s/${env_val}/NODE_RED_/" | \
    sed "/__NODE_RED_ENVIRONMENT__/i \      - NODE_RED_HTTP_NODE_ROOT=${http_node_root}" | \
    sed "/__NODE_RED_ENVIRONMENT__/i \      - NODE_RED_HTTP_ADMIN_ROOT=${http_admin_root}" | \
    sed "/^version:/,/services:/d" >> ${DOCKER_COMPOSE_YML}

    sed -i -e "s/proxy_pass http:\/\/node-red:1880/return 404/" "${node_red_nginx}"
    sed -i -e "/__NODE_RED_SERVER__/i \  location ${http_admin_root} {\n    proxy_pass http:\/\/${username}:1880${http_admin_root};\n  }\n" "${node_red_nginx}"

    add_rsyslog_conf "${username}"

    NODE_RED_URL=https://${NODE_RED}${http_admin_root}/
    NODE_RED_CALLBACK_URL=https://${NODE_RED}${http_admin_root}/auth/strategy/callback

    # Create application for Node-RED
    NODE_RED_CLIENT_ID=$(${NGSI_GO} applications --host "${IDM}" create --name "Node-RED ${number}" --description "Node-RED ${number} application (${HOST_NAME})" --url "${NODE_RED_URL}" --redirectUri "${NODE_RED_CALLBACK_URL}")
    NODE_RED_CLIENT_SECRET=$(${NGSI_GO} applications --host "${IDM}" get --aid "${NODE_RED_CLIENT_ID}" | jq -r .application.secret )

    # Create roles and add them to Admin
    RID_FULL=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${NODE_RED_CLIENT_ID}" create --name "/node-red/full")
    ${NGSI_GO} applications --host "${IDM}" users --aid "${NODE_RED_CLIENT_ID}" assign --rid "${RID_FULL}" --uid "${IDM_ADMIN_UID}" > /dev/null
    ${NGSI_GO} applications --host "${IDM}" roles --aid "${NODE_RED_CLIENT_ID}" create --name "/node-red/read" > /dev/null
    RID_API=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${NODE_RED_CLIENT_ID}" create --name "/node-red/api")
    ${NGSI_GO} applications --host "${IDM}" users --aid "${NODE_RED_CLIENT_ID}" assign --rid "${RID_API}" --uid "${IDM_ADMIN_UID}" > /dev/null

    # Add Wilma application as a trusted application to Node-RED application
    ${NGSI_GO} applications --host "${IDM}" trusted --aid "${NODE_RED_CLIENT_ID}" add --tid "${ORION_CLIENT_ID}"  > /dev/null
    ${NGSI_GO} applications --host "${IDM}" users --aid "${ORION_CLIENT_ID}" assign --rid "${ORION_RID_API}" --uid "${IDM_ADMIN_UID}" > /dev/null

    password=$(pwgen -s 16 1)
    NODE_RED_UID=$(${NGSI_GO} users --host "${IDM}" create --username "${username}" --password "${password}" --email "${username}@${DOMAIN_NAME}")
    ${NGSI_GO} applications --host "${IDM}" users --aid "${NODE_RED_CLIENT_ID}" assign --rid "${RID_FULL}" --uid "${NODE_RED_UID}" > /dev/null
    ${NGSI_GO} applications --host "${IDM}" users --aid "${NODE_RED_CLIENT_ID}" assign --rid "${RID_API}" --uid "${NODE_RED_UID}" > /dev/null
    ${NGSI_GO} applications --host "${IDM}" users --aid "${ORION_CLIENT_ID}" assign --rid "${ORION_RID_API}" --uid "${NODE_RED_UID}" > /dev/null

    add_nginx_depends_on "${username}"

    mkdir "${DATA_DIR}/${username}"
    ${SUDO} chown 1000:1000 "${DATA_DIR}/${username}"

    echo -e "https://${NODE_RED}${http_admin_root}\t${username}@${DOMAIN_NAME}\t${password}" >> "${NODE_RED_USERS_TEXT}"

  cat <<EOF >> .env
${env_val}CLIENT_ID=${NODE_RED_CLIENT_ID}
${env_val}CLIENT_SECRET=${NODE_RED_CLIENT_SECRET}
${env_val}CALLBACK_URL=${NODE_RED_CALLBACK_URL}
EOF
  done

  sed -i -e "/__NODE_RED_SERVER__/d" "${node_red_nginx}"
}

#
# Node-RED
#
setup_node_red() {
  if [ -z "${NODE_RED}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  cp -r "${SETUP_DIR}"/docker/node-red "${CONFIG_DIR}"/
  cp "${CONTRIB_DIR}/node-red-contrib-FIWARE_official/contextbroker.js" "${CONFIG_DIR}"/node-red/contextbroker.js

  cd "${CONFIG_DIR}"/node-red > /dev/null
  ${DOCKER} build -t "${IMAGE_NODE_RED}" .
  cd - > /dev/null

  if [ "${NODE_RED_INSTANCE_NUMBER}" -ge 2 ]; then
    setup_node_red_multi_instance
    return
  fi

  add_docker_compose_yml "docker-node-red.yml"

  if ! ${MULTI_SERVER}; then
    add_to_docker_compose_yml "__NODE_RED_DEPENDS_ON__" "   depends_on:\n      - keyrock"
  fi 

  create_nginx_conf "${NODE_RED}" "nginx-node-red"

  add_nginx_depends_on  "node-red"

  add_rsyslog_conf "node-red"

  NODE_RED_URL=https://${NODE_RED}/
  NODE_RED_CALLBACK_URL=https://${NODE_RED}/auth/strategy/callback
  
  # Create application for Node-RED
  NODE_RED_CLIENT_ID=$(${NGSI_GO} applications --host "${IDM}" create --name "Node-RED" --description "Node-RED application (${HOST_NAME})" --url "${NODE_RED_URL}" --redirectUri "${NODE_RED_CALLBACK_URL}")
  NODE_RED_CLIENT_SECRET=$(${NGSI_GO} applications --host "${IDM}" get --aid "${NODE_RED_CLIENT_ID}" | jq -r .application.secret )

  # Create roles and add them to Admin
  RID=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${NODE_RED_CLIENT_ID}" create --name "/node-red/full")
  ${NGSI_GO} applications --host "${IDM}" users --aid "${NODE_RED_CLIENT_ID}" assign --rid "${RID}" --uid "${IDM_ADMIN_UID}" > /dev/null
  ${NGSI_GO} applications --host "${IDM}" roles --aid "${NODE_RED_CLIENT_ID}" create --name "/node-red/read" > /dev/null
  RID=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${NODE_RED_CLIENT_ID}" create --name "/node-red/api")
  ${NGSI_GO} applications --host "${IDM}" users --aid "${NODE_RED_CLIENT_ID}" assign --rid "${RID}" --uid "${IDM_ADMIN_UID}" > /dev/null

  # Add Wilma application as a trusted application to Node-RED application
  ${NGSI_GO} applications --host "${IDM}" trusted --aid "${NODE_RED_CLIENT_ID}" add --tid "${ORION_CLIENT_ID}"  > /dev/null
  create_node_red_api_role "${IDM}" "${ORION_CLIENT_ID}"
  RID=${ORION_RID_API}
  ${NGSI_GO} applications --host "${IDM}" users --aid "${ORION_CLIENT_ID}" assign --rid "${RID}" --uid "${IDM_ADMIN_UID}" > /dev/null

  mkdir "${DATA_DIR}"/node-red
  ${SUDO} chown 1000:1000 "${DATA_DIR}"/node-red

  cat <<EOF >> .env

# Node-RED

NODE_RED_CLIENT_ID=${NODE_RED_CLIENT_ID}
NODE_RED_CLIENT_SECRET=${NODE_RED_CLIENT_SECRET}
NODE_RED_CALLBACK_URL=${NODE_RED_CALLBACK_URL}
EOF
}

#
# Grafana
#
setup_grafana() {
  if [ -z "${GRAFANA}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-grafana.yml"

  create_nginx_conf "${GRAFANA}" "nginx-grafana"

  add_nginx_depends_on  "grafana"

  add_rsyslog_conf "grafana"

  # Create application for Grafana
  GF_SERVER_ROOT_URL=https://${GRAFANA}/
  GF_SERVER_REDIRECT_URL=https://${GRAFANA}/login/generic_oauth
  set +e
  GRAFANA_CLIENT_ID=$(${NGSI_GO} applications --host "${IDM}" create --name "Grafana" --description "Grafana application (${HOST_NAME})" --url "${GF_SERVER_ROOT_URL}" --redirectUri "${GF_SERVER_REDIRECT_URL}" --openid)
  GRAFANA_CLIENT_SECRET=$(${NGSI_GO} applications --host "${IDM}" get --aid "${GRAFANA_CLIENT_ID}" | jq -r .application.secret )
  set -e

  mkdir -p "${DATA_DIR}"/grafana
  ${SUDO} chown 472:472 "${DATA_DIR}"/grafana

  cat <<EOF >> .env

# Grafana

GRAFANA_CLIENT_ID=${GRAFANA_CLIENT_ID}
GRAFANA_CLIENT_SECRET=${GRAFANA_CLIENT_SECRET}

GF_SERVER_DOMAIN=${GRAFANA}
GF_SERVER_ROOT_URL=${GF_SERVER_ROOT_URL}

GF_AUTH_DISABLE_LOGIN_FORM=true
GF_AUTH_SIGNOUT_REDIRECT_URL=https://${KEYROCK}/auth/external_logout?_method=DELETE&client_id=${GRAFANA_CLIENT_ID}

GF_AUTH_GENERIC_OAUTH_NAME=keyrock
GF_AUTH_GENERIC_OAUTH_ENABLED=true
GF_AUTH_GENERIC_OAUTH_ALLOW_SIGN_UP=false
GF_AUTH_GENERIC_OAUTH_CLIENT_ID=${GRAFANA_CLIENT_ID}
GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET=${GRAFANA_CLIENT_SECRET}
GF_AUTH_GENERIC_OAUTH_SCOPES=openid
GF_AUTH_GENERIC_OAUTH_EMAIL_ATTRIBUTE_NAME=email
GF_AUTH_GENERIC_OAUTH_AUTH_URL=https://${KEYROCK}/oauth2/authorize
GF_AUTH_GENERIC_OAUTH_TOKEN_URL=https://${KEYROCK}/oauth2/token
GF_AUTH_GENERIC_OAUTH_API_URL=https://${KEYROCK}/user

GF_INSTALL_PLUGINS="https://github.com/orchestracities/grafana-map-plugin/archive/master.zip;grafana-map-plugin,grafana-clock-panel,grafana-worldmap-panel"
EOF
}

setup_postfix() {
  if ! ${POSTFIX}; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  cp -r "${SETUP_DIR}"/docker/postfix "${CONFIG_DIR}"/

  cd "${CONFIG_DIR}"/postfix > /dev/null
  ${DOCKER} build -t "${IMAGE_POSTFIX}" .
  cd - > /dev/null

  add_docker_compose_yml "docker-postfix.yml"

  local file

  for file in main.cf transport_maps aliases.regexp
  do
    sed -i -e "/__POSTFIX_VOLUMES__/i \      - ${CONFIG_DIR}/postfix/${file}:/etc/postfix/${file}" "${DOCKER_COMPOSE_YML}"
    "${SUDO}" chown root.root "${CONFIG_DIR}/postfix/${file}"
    "${SUDO}" chmod 0644 "${CONFIG_DIR}/postfix/${file}"
  done

  sudo sed -i -e "/^myhostname/s/localdomain/${DOMAIN_NAME}/" "${CONFIG_DIR}/postfix/main.cf"
  sudo sed -i -e "/^mydomain/s/localdomain/${DOMAIN_NAME}/" "${CONFIG_DIR}/postfix/main.cf"

  sed -i -e "/__POSTFIX_VOLUMES__/i \      - ${DATA_DIR}/postfix/mail:/var/mail" "${DOCKER_COMPOSE_YML}"

  sed -i -e "/__KEYROCK_DEPENDS_ON__/i \      - postfix" "${DOCKER_COMPOSE_YML}"
  sed -i -e "/__KEYROCK_ENVIRONMENT__/i \      - IDM_EMAIL_HOST=postfix" "${DOCKER_COMPOSE_YML}"
  sed -i -e "/__KEYROCK_ENVIRONMENT__/i \      - IDM_EMAIL_POST=25" "${DOCKER_COMPOSE_YML}"
  sed -i -e "/__KEYROCK_ENVIRONMENT__/i \      - IDM_EMAIL_ADDRESS=${IDM_ADMIN_EMAIL}" "${DOCKER_COMPOSE_YML}"

  add_rsyslog_conf "postfix"
}

setup_ngsi_go() {
  logging_info "${FUNCNAME[0]}"

  NGSI_GO=/usr/local/bin/ngsi
  if $FIBB_TEST; then
    NGSI_GO="${NGSI_GO} --insecureSkipVerify"
  fi

  SERVERS=("$(${NGSI_GO} server list --all -1)")

  local save_orion
  save_orion=${ORION}
  local save_keyrock
  save_keyrock=${KEYROCK}

  for NAME in "${APPS[@]}"
  do
    if [ "${NAME}" = "ORION" ] && [ -n "${MULTI_SERVER_ORION_HOST}" ]; then
      ORION=${MULTI_SERVER_ORION_HOST}
    fi
    eval VAL=\"\$"$NAME"\"
    if [ -n "$VAL" ]; then
      case "${NAME}" in
          "KEYROCK" ) ${NGSI_GO} server add --host "${VAL}" --serverType keyrock --serverHost "https://${VAL}" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --overWrite ;;
          "ORION" )  ${NGSI_GO} broker add --host "${VAL}" --ngsiType v2 --brokerHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${KEYROCK}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --overWrite ;;
          "ORION_LD" )  ${NGSI_GO} broker add --host "${VAL}" --ngsiType ld --brokerHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${KEYROCK}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --overWrite ;;
          "CYGNUS" ) ${NGSI_GO} server add --host "${VAL}" --serverType cygnus --serverHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${KEYROCK}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --overWrite ;;
          "COMET" ) ${NGSI_GO} server add --host "${VAL}" --serverType comet --serverHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${KEYROCK}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --overWrite ;;
          "IOTAGENT_UL" ) ${NGSI_GO} server add --host "${VAL}" --serverType iota --serverHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${KEYROCK}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --service openiot --path / --overWrite ;;
          "IOTAGENT_JSON" ) ${NGSI_GO} server add --host "${VAL}" --serverType iota --serverHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${KEYROCK}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --service openiot --path / --overWrite ;;
          "WIRECLOUD" ) ${NGSI_GO} server add --host "${VAL}" --serverType wirecloud --serverHost "https://${VAL}" --idmType keyrock --idmHost "https://${KEYROCK}/oauth2/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --clientId "${WIRECLOUD_CLIENT_ID}" --clientSecret "${WIRECLOUD_CLIENT_SECRET}" --overWrite ;;
          "QUANTUMLEAP" ) ${NGSI_GO} server add --host "${VAL}" --serverType quantumleap --serverHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${KEYROCK}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --overWrite ;;
          "PERSEO" ) ${NGSI_GO} server add --host "${VAL}" --serverType perseo --serverHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${KEYROCK}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" --overWrite ;;
      esac
    fi
  done

  ORION=${save_orion}
  KEYROCK=${save_keyrock}

  ${NGSI_GO} settings clear
}

#
# update nginx file
#
update_nginx_file() {
  logging_info "${FUNCNAME[0]}"

  for name in "${APPS[@]}"
  do
    if ${MULTI_SERVER} && [ "${name}" = "KEYROCK" ]; then
      continue
    fi 
    if [ "${name}" = "MOSQUITTO" ]; then
      continue
    fi
    eval val=\"\$"${name}"\"
    if [ -n "${val}" ]; then
      sed -i -e "s/SSL_CERTIFICATE_KEY/${SSL_CERTIFICATE_KEY}/" "${NGINX_SITES}"/"${val}"
      sed -i -e "s/SSL_CERTIFICATE/${SSL_CERTIFICATE}/" "${NGINX_SITES}"/"${val}"
    fi
  done
}

#
# copy scripts
#
copy_scripts() {
  logging_info "${FUNCNAME[0]}"

  mkdir "${CONFIG_DIR}/script"
  cp "${SETUP_DIR}/script/"* "${CONFIG_DIR}/script/"
  chmod a+x "${CONFIG_DIR}/script/"*

  cp "${SETUP_DIR}/_Makefile" ./Makefile
}

#
# Boot up containers
#
boot_up_containers() {
  logging_info "${FUNCNAME[0]}"

  logging_info "docker-compose up -d --build"
  ${DOCKER_COMPOSE} up -d --build

  if [ -n "${DRACO}" ]; then
    "${FIBB_TEST}" || wait "https://${DRACO}/" "200"
  fi

  if ! ${MULTI_SERVER}; then
    wait "https://${KEYROCK}/" "200"
  fi
}

#
# Setup end
#
setup_end() {
  logging_info "${FUNCNAME[0]}"

  delete_from_docker_compose_yml "# __"

  if ! ${MULTI_SERVER} && [ -n "${KEYROCK}" ]; then
    sed -i -e "/# __NGINX_KEYROCK__/d" "${NGINX_SITES}/${KEYROCK}"
  fi
  if [ -n "${ORION}" ]; then
    sed -i -e "/# __NGINX_ORION__/d" "${NGINX_SITES}/${ORION}"
  fi
  if [ -n "${ORION_LD}" ]; then
    sed -i -e "/# __NGINX_ORION_LD__/d" "${NGINX_SITES}/${ORION_LD}"
  fi
  if [ -n "${DRACO}" ]; then
    sed -i -e "/# __NGINX_DRACO__/d" "${NGINX_SITES}/${DRACO}"
  fi
  if [ -n "${IOTAGENT_HTTP}" ]; then
    sed -i -e "/# __NGINX_IOTAGENT_HTTP__/d" "${NGINX_SITES}/${IOTAGENT_HTTP}"
  fi
}

#
# clean up
#
clean_up() {
  logging_info "${FUNCNAME[0]}"

  rm -f docker-idm.yml
  rm -f docker-cert.yml
  rm -fr "${WORK_DIR}"
}

#
# parse args
#
parse_args() {

  FIBB_TEST="${FIBB_TEST:-false}"

  ERR_CODE=1
  if ${FIBB_TEST}; then
    ERR_CODE=0
  fi

  if [ $# -eq 0 ] || [ $# -ge 3 ]; then
    echo "$0 DOMAIN_NAME [GLOBAL_IP_ADDRESS]"
    exit "${ERR_CODE}"
  fi

  DOMAIN_NAME=$1
  IP_ADDRESS=

  if [ $# -ge 2 ]; then
    IP_ADDRESS=$2
  fi
}

#
# setup main
#
setup_main() {
  logging_info "${FUNCNAME[0]}"

  setup_cert

  up_keyrock

  setup_nginx
  setup_keyrock
  setup_orion
  setup_orion_ld
  setup_queryproxy
  setup_regproxy
  setup_cygnus
  setup_comet
  setup_draco
  setup_quantumleap
  setup_wirecloud
  setup_iotagent_ul
  setup_iotagent_json
  setup_perseo
  setup_node_red
  setup_grafana
  setup_postfix

  down_keyrock

  update_nginx_file
  setup_ngsi_go

  setup_logging_step2

  copy_scripts

  setup_end

  boot_up_containers

  install_widgets_for_wirecloud

  clean_up
}

init_cmd() {
  SUDO=sudo
  IS_ROOT=false 
  MULTI_SERVER=false

  MOCK_PATH=""
  if $FIBB_TEST; then
    MOCK_PATH="${FIBB_TEST_MOCK_PATH-""}"
  fi

  APT="${SUDO} ${MOCK_PATH}apt"
  APT_GET="${SUDO} ${MOCK_PATH}apt-get"
  APT_KEY="${SUDO} ${MOCK_PATH}apt-key"
  ADD_APT_REPOSITORY="${SUDO} ${MOCK_PATH}add-apt-repository"
  SYSTEMCTL="${SUDO} ${MOCK_PATH}systemctl"
  YUM="${SUDO} ${MOCK_PATH}yum"
  YUM_CONFIG_MANAGER="${SUDO} ${MOCK_PATH}yum-config-manager"
  FIREWALL_CMD="${SUDO} ${MOCK_PATH}firewall-cmd"
  UNAME="${FIBB_TEST_UNAME_CMD:-uname}"
  DOCKER_CMD="${FIBB_TEST_DOCKER_CMD:-docker}"
  DOCKER_COMPOSE_CMD="/usr/local/bin/docker-compose"
  DOCKER_COMPOSE="${SUDO} ${DOCKER_COMPOSE_CMD}"
  HOST_CMD="${FIBB_TEST_HOST_CMD:-host}"
  WAIT_TIME=${FIBB_WAIT_TIME:-300}
  SKIP_INSTALL_WIDGET="${FIBB_TEST_SKIP_INSTALL_WIDGET:-false}"

  HOST_NAME=$(hostname)

  INSTALL=".install"

  DATA_DIR=${SELF_DIR}/data
  WORK_DIR=${SELF_DIR}/.work
  CONFIG_DIR=${SELF_DIR}/config
  ENV_FILE=.env
  NODE_RED_USERS_TEXT=node-red_users.txt
}

#
# Remove unnecessary directories and files
#
remove_files() {
  if [ -e "${INSTALL}" ]; then
    for file in docker-compose.yml docker-cert.yml docker-idm.yml
    do
      if [ -e "${file}" ]; then
        set +e
        ${DOCKER_COMPOSE} -f "${file}" down --remove-orphans
        set -e
        sleep 5
        rm -f "${file}"
      fi
    done

    if [ -d "${DATA_DIR}" ]; then
      "${SUDO}" rm -fr "${DATA_DIR}"
    fi

    "${SUDO}" rm -fr "${CONFIG_DIR}"
    rm -fr "${WORK_DIR}"
    rm -f "${ENV_FILE}"
    rm -f "${NODE_RED_USERS_TEXT}"
  fi

  touch "${INSTALL}"
}

#
# main
#
main() {
  LANG=C

  SELF_DIR=$(cd "$(dirname "$0")"; pwd)

  parse_args "$@"

  init_cmd

  remove_files

  check_machine

  get_distro

  setup_init

  check_data_direcotry

  make_directories

  get_config_sh

  set_and_check_values

  setup_logging_step1

  install_commands

  setup_firewall

  check_docker
  check_docker_compose
  check_ngsi_go

  add_env

  add_domain_to_env

  validate_domain

  setup_main

  setup_complete
}

main "$@"
