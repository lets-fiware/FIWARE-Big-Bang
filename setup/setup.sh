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

NGSI_GO="/usr/local/bin/ngsi --batch"
IDM=keyrock-`date +%Y%m%d_%H-%M-%S`
MYSQL_DIR=./mysql

#
# Validate domain
#
validate_domain() {
  if [ -z "${IP_ADDRESS}" ]; then
      IP_ADDRESS=($(hostname -I))
  else
      IP_ADDRESS=("${IP_ADDRESS}")
  fi

  for name in KEYROCK ORION COMET WIRECLOUD NGSIPROXY NODE_RED
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
  if [ ! -d "/etc/letsencrypt/live/\$1" ]; then
    wait \$1
    echo "sudo docker run --rm -v \${CERT_DIR}/\$1:/var/www/html/\$1 -v /etc/letsencrypt:/etc/letsencrypt \${CERTBOT} certonly --webroot -w /var/www/html/\$1 -d \$1"
    sudo docker run --rm -v \${CERT_DIR}/\$1:/var/www/html/\$1 -v /etc/letsencrypt:/etc/letsencrypt \${CERTBOT} certonly --webroot -w /var/www/html/\$1 -d \$1
  else
    echo "Skip: /etc/letsencrypt/live/\$1 direcotry already exits"
  fi
}

EOF

  for name in KEYROCK ORION COMET WIRECLOUD NGSIPROXY NODE_RED
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
# Keyrock
#
setup_keyrock() {
  if [ -d ${MYSQL_DIR} ]; then
    rm -fr ${MYSQL_DIR}
  fi

  mkdir ${MYSQL_DIR}

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
  
  rm -fr ${MYSQL_DIR}
}

#
# Orion, Wilma and Tokenproxy
#
setup_orion() {
  if [ -z "${WIRECLOUD}" ]; then
    URL=${ORION}
  else
    URL=${WIRECLOUD}
  fi

  cp ${TEMPLEATE}/docker-base.yml ./docker-compose.yml

  rm -fr ${NGINX_SITES}
  mkdir -p ${NGINX_SITES}
  sed -e "s/HOST/${KEYROCK}/" ${TEMPLEATE}/nginx-keyrock > ${NGINX_SITES}/${KEYROCK}
  sed -e "s/HOST/${ORION}/" ${TEMPLEATE}/nginx-orion > ${NGINX_SITES}/${ORION}

  # Create Applicaton for WireCloud
  AID=$(${NGSI_GO} applications --host ${IDM} create --name "WireCloud" --description "WireCloud application" --url "https://${URL}/" --redirectUri "https://${URL}/complete/fiware/")
  SECRET=$(${NGSI_GO} applications --host ${IDM} get --aid ${AID} | jq -r .application.secret )

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
EOF
  fi
}

#
# clean up
#
clean_up() {
  ${NGSI_GO} server delete --host ${IDM}
  rm -f docker-keyrock.yml
  rm -f docker-cert.yml
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
  setup_wirecloud
  setup_node_red
  setup_grafana

  down_keyrock
}

setup_main

sudo ${DOCKER_COMPOSE} up -d --build

clean_up
