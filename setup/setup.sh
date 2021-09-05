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

set -ue

. ./.env

if [ -d ${DATA_DIR} ]; then
  echo "${DATA_DIR} - directory already exists"
  exit 1
fi

WORK_DIR=./.work
MYSQL_DIR="${WORK_DIR}/mysql"
LOG_DIR=/var/log/fiware

if [ -d "${WORK_DIR}" ]; then
  rm -fr "${WORK_DIR}"
fi

mkdir "${WORK_DIR}"
mkdir "${MYSQL_DIR}"

RSYSLOG_CONF=${WORK_DIR}/rsyslog.conf
LOGROTATE_CONF=${WORK_DIR}/logrotate.conf

NGSI_GO="/usr/local/bin/ngsi --batch --config ${WORK_DIR}/ngsi-go-config.json --cache ${WORK_DIR}/ngsi-go-token-cache.json"
IDM=keyrock-`date +%Y%m%d_%H-%M-%S`

#
# Validate domain
#
validate_domain() {
  if [ -z "${IP_ADDRESS}" ]; then
      IP_ADDRESS=($(hostname -I))
  else
      IP_ADDRESS=("${IP_ADDRESS}")
  fi

  for name in KEYROCK ORION COMET WIRECLOUD NGSIPROXY NODE_RED GRAFANA QUANTUMLEAP
  do
    eval val=\"\$${name}\"
    if [ -n "${val}" ]; then
        IP=$(host -4 ${val} | awk 'match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/) { print substr($0, RSTART, RLENGTH) }')
        found=false
        for ip_addr in "${IP_ADDRESS[@]}"
        do
          if [ "${IP}" = "${ip_addr[@]}" ] ; then
            found=true
          fi
        done
        if ! "${found}"; then
            echo "IP address error: ${val}, ${IP_ADDRESS}"
            exit 1
        fi 
    fi 
  done
}

#
# setup cert
#
setup_cert() {
  rm -fr ${NGINX_SITES}
  mkdir -p ${NGINX_SITES}

  rm -fr ${CERT_DIR}
  mkdir -p ${CERT_DIR}

  CERT_SH=./cert.sh
  touch ${CERT_SH}
  chmod +x ${CERT_SH}

  cat <<EOF > ${CERT_SH}
#!/bin/bash

. ./.env

if [ \${EUID:-\${UID}} != 0 ]; then
  echo 'run as root.'
  exit 1
fi

wait() {
  echo "Wait for \$1"
  while [ "404" != \$(curl http://\$1/ -o /dev/null -w '%{http_code}\n' -s) ]
  do
    sleep 1
  done
}

cert() {
  if [ -d "/etc/letsencrypt/live/\$1" ] && ${CERT_REVOKE}; then
    sudo docker run --rm -v /etc/letsencrypt:/etc/letsencrypt \${CERTBOT} revoke -n -v --cert-path /etc/letsencrypt/live/\$1/cert.pem
  fi

  if [ ! -d "/etc/letsencrypt/live/\$1" ]; then
    wait \$1
    sudo docker run --rm -v \${CERT_DIR}/\$1:/var/www/html/\$1 -v /etc/letsencrypt:/etc/letsencrypt \${CERTBOT} certonly --agree-tos -m \${CERT_EMAIL} --webroot -w /var/www/html/\$1 -d \$1
  else
    echo "Skip: /etc/letsencrypt/live/\$1 direcotry already exits"
  fi
}

EOF

  for name in KEYROCK ORION COMET WIRECLOUD NGSIPROXY NODE_RED GRAFANA QUANTUMLEAP
  do
    eval val=\"\$${name}\"
    if [ -n "${val}" ]; then
      if [ ! -d ${CERT_DIR}/${val} ]; then
        mkdir ${CERT_DIR}/${val}
      fi
      echo "cert ${val}" >> ${CERT_SH}
      sed -e "s/HOST/${val}/" ${TEMPLEATE}/nginx-cert > ${NGINX_SITES}/${val}
    fi 
  done

  cp ${TEMPLEATE}/setup-cert.yml ./docker-cert.yml

  mkdir -p ${CONFIG_DIR}/nginx
  cp ${TEMPLEATE}/nginx.conf ${CONFIG_DIR}/nginx/

  sudo ${DOCKER_COMPOSE} -f docker-cert.yml up -d

  sudo ./cert.sh

  sudo ${DOCKER_COMPOSE} -f docker-cert.yml down

  rm -f ${CERT_SH}
}

#
# Add fiware.conf
#
add_rsyslog_conf() {
  cat <<EOF >> ${RSYSLOG_CONF}
:syslogtag,startswith,"[$1]" /var/log/fiware/$1.log
& stop

EOF

  echo "${LOG_DIR}/$1.log" >> "${LOGROTATE_CONF}"
}

#
# setup_logging
#
setup_logging() {
  if "${LOGGING}"; then
      if [ -d "${LOG_DIR}" ]; then
          sudo rm -fr "${LOG_DIR}"
      fi
      sudo mkdir "${LOG_DIR}"
      sudo chown syslog:adm "${LOG_DIR}"
      files=($(cat "${LOGROTATE_CONF}" | sed -z -e "s/\n/ /g"))
      for file in "${files[@]}"
      do
        sudo touch "${file}"
        sudo chown syslog:adm "${file}"
      done
      if [ "${DISTRO}" = "Ubuntu" ]; then
        sudo cp "${RSYSLOG_CONF}" /etc/rsyslog.d/10-fiware.conf
        ROTATE_CMD="/usr/lib/rsyslog/rsyslog-rotate"
      else
        sudo cp "${RSYSLOG_CONF}" /etc/rsyslog.d/fiware.conf
        ROTATE_CMD="/bin/kill -HUP \`cat /var/run/syslogd.pid 2> /dev/null\` 2> /dev/null || true"
      fi
      sudo systemctl restart rsyslog.service

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
      sudo cp "${LOGROTATE_CONF}" /etc/logrotate.d/fiware
  fi

}

#
# Keyrock
#
setup_keyrock() {

  MYSQL_ROOT_PASSWORD=$(pwgen -s 16 1)

  IDM_HOST=https://${KEYROCK}
  CB_HOST=https://${ORION}

  IDM_DB_HOST=mysql
  IDM_DB_NAME=idm
  IDM_DB_USER=idm
  IDM_DB_PASS=$(pwgen -s 16 1)

  IDM_ADMIN_USER=admin

  cat <<EOF >> .env
IDM_HOST=${IDM_HOST}
CB_HOST=${CB_HOST}

# Mysql

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

IDM_DB_HOST=${IDM_DB_HOST}
IDM_DB_NAME=${IDM_DB_NAME}
IDM_DB_USER=${IDM_DB_USER}
IDM_DB_PASS=${IDM_DB_PASS}

# Keyrock

IDM_ADMIN_ID=admin
IDM_ADMIN_USER=${IDM_ADMIN_USER}
IDM_ADMIN_EMAIL=${IDM_ADMIN_EMAIL}
IDM_ADMIN_PASS=${IDM_ADMIN_PASS}
IDM_SESSION_SECRET=$(pwgen -s 16 1)
IDM_ENCRYPTION_KEY=$(pwgen -s 16 1)

EOF

  cat <<EOF > ${MYSQL_DIR}/init.sql
CREATE USER '${IDM_DB_USER}'@'%' IDENTIFIED BY '${IDM_DB_PASS}';
GRANT ALL PRIVILEGES ON ${IDM_DB_NAME}.* TO '${IDM_DB_USER}'@'%';
flush PRIVILEGES;
EOF

  cp -a ${TEMPLEATE}/setup-keyrock.yml ./docker-keyrock.yml

  sudo ${DOCKER_COMPOSE} -f docker-keyrock.yml up -d

  while [ "200" != $(curl http://localhost:3000/ -o /dev/null -w '%{http_code}\n' -s) ]
  do
    sleep 1
  done

  ${NGSI_GO} server add --host ${IDM} --serverType keyrock --serverHost http://localhost:3000 --idmType idm --username ${IDM_ADMIN_EMAIL} --password ${IDM_ADMIN_PASS}
}

#
# Tear down Keyrock
#
down_keyrock() {
  sudo ${DOCKER_COMPOSE} -f docker-keyrock.yml down
}

#
# Orion, Wilma and Tokenproxy
#
setup_orion() {
  cp ${TEMPLEATE}/docker-base.yml ./docker-compose.yml

  rm -fr ${NGINX_SITES}
  mkdir -p ${NGINX_SITES}
  sed -e "s/HOST/${KEYROCK}/" ${TEMPLEATE}/nginx-keyrock > ${NGINX_SITES}/${KEYROCK}
  sed -e "s/HOST/${ORION}/" ${TEMPLEATE}/nginx-orion > ${NGINX_SITES}/${ORION}

  if [ -z "${WIRECLOUD}" ]; then
    # Create Applicaton for Orion
    AID=$(${NGSI_GO} applications --host ${IDM} create --name "Orion" --description "Orion application" --url "https://${ORION}/" --redirectUri "https://${ORION}/complete/fiware/")
    SECRET=$(${NGSI_GO} applications --host ${IDM} get --aid ${AID} | jq -r .application.secret )
  else
    # Create Applicaton for WireCloud
    AID=$(${NGSI_GO} applications --host ${IDM} create --name "WireCloud" --description "WireCloud application" --url "https://${WIRECLOUD}/" --redirectUri "https://${WIRECLOUD}/complete/fiware/")
    SECRET=$(${NGSI_GO} applications --host ${IDM} get --aid ${AID} | jq -r .application.secret )
    RID=$(${NGSI_GO} applications --host ${IDM} roles --aid ${AID} create --name Admin)
    ${NGSI_GO} applications --host ${IDM} users --aid ${AID} assign --rid ${RID} --uid admin > /dev/null
  fi

  # Create PEP Proxy for FIWARE Orion
  PEP_PASSWORD=$(${NGSI_GO} applications --host ${IDM} pep --aid ${AID} create --run | jq -r .pep_proxy.password)
  PEP_ID=$(${NGSI_GO} applications --host ${IDM} pep --aid ${AID} list | jq -r .pep_proxy.id)

  cat <<EOF >> .env

# Tokenproxy for Orion
CLIENT_ID=${AID}
CLIENT_SECRET=${SECRET}

# PEP Proxy for Orion
PEP_PROXY_APP_ID=${AID}
PEP_PROXY_USERNAME=${PEP_ID}
PEP_PASSWORD=${PEP_PASSWORD}
EOF

  mkdir -p ${CONFIG_DIR}/mongo
  cp ${TEMPLEATE}/mongo-init.js ${CONFIG_DIR}/mongo/

  mkdir -p ${CONFIG_DIR}/tokenproxy
  cp ${TEMPLEATE}/Dockerfile.tokenproxy ${CONFIG_DIR}/tokenproxy/Dockerfile

  add_rsyslog_conf "nginx"
  add_rsyslog_conf "orion"
  add_rsyslog_conf "mongo"
  add_rsyslog_conf "keyrock"
  add_rsyslog_conf "mysql"
  add_rsyslog_conf "pep-proxy"
  add_rsyslog_conf "tokenproxy"
}

#
# Cygnus and Comet
#
setup_comet() {
  if [ -n "${COMET}" ]; then
    sed -e "s/HOST/${COMET}/" ${TEMPLEATE}/nginx-comet > ${NGINX_SITES}/${COMET}

    cat ${TEMPLEATE}/docker-comet.yml >> ./docker-compose.yml

    sed -i -e "/ __NGINX_DEPENDS_ON__/ i \      - comet" ./docker-compose.yml
    sed -i -e "/ __NGINX_DEPENDS_ON__/ i \      - cygnus" ./docker-compose.yml

    add_rsyslog_conf "cygnus"
    add_rsyslog_conf "comet"
  fi
}

#
# QuantumLeap
#
setup_quantumleap() {
  if [ -n "${QUANTUMLEAP}" ]; then
    sed -e "s/HOST/${QUANTUMLEAP}/" ${TEMPLEATE}/nginx-quantumleap > ${NGINX_SITES}/${QUANTUMLEAP}

    cat ${TEMPLEATE}/docker-quantumleap.yml >> ./docker-compose.yml

    sed -i -e "/ __NGINX_DEPENDS_ON__/ i \      - quantumleap" ./docker-compose.yml

    # Workaround for CrateDB. See https://crate.io/docs/crate/howtos/en/latest/deployment/containers/docker.html#troubleshooting
    sudo sysctl -w vm.max_map_count=262144

    add_rsyslog_conf "quantumleap"
    add_rsyslog_conf "redis"
    add_rsyslog_conf "crate"
  fi
}

#
# WireCLoud and ngsiproxy
#
setup_wirecloud() {
  if [ -n "${WIRECLOUD}" ]; then
    cat ${TEMPLEATE}/docker-wirecloud.yml >> ./docker-compose.yml
    sed -i -e "/ __NGINX_DEPENDS_ON__/ i \      - wirecloud" ./docker-compose.yml
    sed -i -e "/ __NGINX_DEPENDS_ON__/ i \      - ngsiproxy" ./docker-compose.yml
    sed -i -e "/ __NGINX_VOLUMES__/ i \      - ./data/wirecloud/wirecloud-static:/var/www/static:ro" ./docker-compose.yml

    sed -e "s/HOST/${WIRECLOUD}/" ${TEMPLEATE}/nginx-wirecloud > ${NGINX_SITES}/${WIRECLOUD}
    sed -e "s/HOST/${NGSIPROXY}/" ${TEMPLEATE}/nginx-ngsiproxy > ${NGINX_SITES}/${NGSIPROXY}

    cat <<EOF >> .env

# Postgres

POSTGRES_PASSWORD=$(pwgen -s 16 1)
EOF

    add_rsyslog_conf "wirecloud"
    add_rsyslog_conf "postgres"
    add_rsyslog_conf "elasticsearch"
    add_rsyslog_conf "memcached"
    add_rsyslog_conf "ngsiproxy"
  fi
}

#
# Node-RED
#
setup_node_red() {
  if [ -n "${NODE_RED}" ]; then
    cat ${TEMPLEATE}/docker-node-red.yml >> ./docker-compose.yml
    sed -i -e "/ __NGINX_DEPENDS_ON__/ i \      - node-red" ./docker-compose.yml

    sed -e "s/HOST/${NODE_RED}/" ${TEMPLEATE}/nginx-node-red > ${NGINX_SITES}/${NODE_RED}
  
    NODE_RED_URL=https://${NODE_RED}/
    NODE_RED_CALLBACK_URL=https://${NODE_RED}/auth/strategy/callback
  
    # Create application for Node-RED
    NODE_RED_CLIENT_ID=$(${NGSI_GO} applications --host ${IDM} create --name "node-RED" --description "nore-RED application" --url "${NODE_RED_URL}" --redirectUri "${NODE_RED_CALLBACK_URL}")
    NODE_RED_CLIENT_SECRET=$(${NGSI_GO} applications --host ${IDM} get --aid ${NODE_RED_CLIENT_ID} | jq -r .application.secret )

    mkdir ${DATA_DIR}/node-red
    sudo chown 1000:1000 ${DATA_DIR}/node-red

    mkdir ${CONFIG_DIR}/node-red
    cp ${TEMPLEATE}/Dockerfile.node-red ${CONFIG_DIR}/node-red/Dockerfile
    cp ${TEMPLEATE}/settings.js.node-red ${CONFIG_DIR}/node-red/settings.js

    cat <<EOF >> .env

# Node-RED

NODE_RED_CLIENT_ID=${NODE_RED_CLIENT_ID}
NODE_RED_CLIENT_SECRET=${NODE_RED_CLIENT_SECRET}
NODE_RED_CALLBACK_URL=${NODE_RED_CALLBACK_URL}
EOF

    add_rsyslog_conf "node-red"
  fi
}

#
# Grafana
#
setup_grafana() {
  if [ -n "${GRAFANA}" ]; then
    cat ${TEMPLEATE}/docker-grafana.yml>> ./docker-compose.yml
    sed -i -e "/ __NGINX_DEPENDS_ON__/ i \      - grafana" ./docker-compose.yml

    sed -e "s/HOST/${GRAFANA}/" ${TEMPLEATE}/nginx-grafana > ${NGINX_SITES}/${GRAFANA}

    # Create application for Grafana
    GF_SERVER_ROOT_URL=https://${GRAFANA}/
    GF_SERVER_REDIRECT_URL=https://${GRAFANA}/login/generic_oauth
    GRAFANA_CLIENT_ID=$(${NGSI_GO} applications --host ${IDM} create --name "Grafana" --description "Grafana application" --url "${GF_SERVER_ROOT_URL}" --redirectUri "${GF_SERVER_REDIRECT_URL}" --responseType "code,token,id_token")
    GRAFANA_CLIENT_SECRET=$(${NGSI_GO} applications --host ${IDM} get --aid ${GRAFANA_CLIENT_ID} | jq -r .application.secret )

    mkdir -p ${DATA_DIR}/grafana
    sudo chown 472:472 ${DATA_DIR}/grafana

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

    add_rsyslog_conf "grafana"
  fi
}

setup_ngsi_go() {
  NGSI_GO="/usr/local/bin/ngsi --batch"
  SERVERS=($(${NGSI_GO} server list --all -1))

  for NAME in KEYROCK ORION COMET WIRECLOUD NGSIPROXY NODE_RED GRAFANA QUANTUMLEAP
  do
    eval VAL=\"\$$NAME\"
    if [ -n "$VAL" ]; then
      for name in "${SERVERS[@]}"
      do
        if [ "${VAL}" = "${name}" ]; then
          ngsi server delete --host ${name}
        fi
      done
    fi
  done

  for NAME in KEYROCK ORION COMET WIRECLOUD NGSIPROXY NODE_RED GRAFANA QUANTUMLEAP
  do
    eval VAL=\"\$$NAME\"
    if [ -n "$VAL" ]; then
      case "${NAME}" in
          "KEYROCK" ) ${NGSI_GO} server add --host "${VAL}" --serverType keyrock --serverHost "https://${VAL}" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" ;;
          "ORION" )  ${NGSI_GO} broker add --host "${VAL}" --ngsiType v2 --brokerHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${ORION}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" ;;
          "COMET" ) ${NGSI_GO} server add --host "${VAL}" --serverType comet --serverHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${ORION}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" ;;
          "WIRECLOUD" ) ${NGSI_GO} server add --host "${VAL}" --serverType wirecloud --serverHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${ORION}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" ;;
          "QUANTUMLEAP" ) ${NGSI_GO} server add --host "${VAL}" --serverType quantumleap --serverHost "https://${VAL}" --idmType tokenproxy --idmHost "https://${ORION}/token" --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}" ;;
      esac
    fi
  done
}

#
# clean up
#
clean_up() {
  rm -f docker-keyrock.yml
  rm -f docker-cert.yml
  rm -fr "${WORK_DIR}"
}

#
# main
#
setup_main() {
  validate_domain
  setup_cert

  setup_keyrock

  setup_orion
  setup_comet
  setup_quantumleap
  setup_wirecloud
  setup_node_red
  setup_grafana

  down_keyrock

  setup_ngsi_go
  setup_logging
}

setup_main

sudo ${DOCKER_COMPOSE} up -d --build

clean_up
