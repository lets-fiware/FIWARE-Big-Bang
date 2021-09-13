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

#set -Ceuo pipefail
set -Ceu

. ./.env

. ./setup/constant.sh

logging_info() {
  echo "setup.sh: $1"
  /usr/bin/logger -i -p "user.info" -t "FI-BB" "setup.sh: $1"
}

logging_err() {
  echo "setup.sh: $1"
  /usr/bin/logger -i -p "user.err" -t "FI-BB" "setup.sh: $1"
}

if [ -d "${DATA_DIR}" ]; then
  MSG="${DATA_DIR} - directory already exists"
  logging_err "${MSG}"
  exit 1
fi

#
# Setup init
#
setup_init() {
  logging_info "${FUNCNAME[0]}"

  WORK_DIR=./.work
  MYSQL_DIR="${WORK_DIR}/mysql"

  RSYSLOG_CONF=${WORK_DIR}/rsyslog.conf
  LOGROTATE_CONF=${WORK_DIR}/logrotate.conf

  NGSI_GO="/usr/local/bin/ngsi --batch --config ${WORK_DIR}/ngsi-go-config.json --cache ${WORK_DIR}/ngsi-go-token-cache.json"
  IDM=keyrock-$(date +%Y%m%d_%H-%M-%S)

  DOCKER_COMPOSE_YML=./docker-compose.yml

  APPS=(KEYROCK ORION COMET WIRECLOUD NGSIPROXY NODE_RED GRAFANA QUANTUMLEAP)

  val=
}

#
# Make dir
#
make_dir() {
  logging_info "${FUNCNAME[0]}"

  if [ -d "${WORK_DIR}" ]; then
    rm -fr "${WORK_DIR}"
  fi

  mkdir "${DATA_DIR}"
  mkdir "${WORK_DIR}"
  mkdir "${MYSQL_DIR}"

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

  for name in "${APPS[@]}"
  do
    eval val=\"\$"${name}"\"
    if [ -n "${val}" ]; then
      result=0
      output=$(grep "${val}" /etc/hosts 2> /dev/null) || result=$?
      echo "${output}"
      if [ ! "$result" = "0" ]; then
        sudo bash -c "echo $1 ${val} >> /etc/hosts"
        echo "Add '$1 ${val}' to /etc/hosts"
      fi
    fi
  done
}

#
# Validate domain
#
validate_domain() {
  logging_info "${FUNCNAME[0]}"

  if [ -n "${IP_ADDRESS}" ]; then
      IP_ADDRESS=("${IP_ADDRESS}")
  else
      IP_ADDRESS=("$(hostname -I)")
  fi

  if "$FIBB_TEST"; then
    add_etc_hosts "${IP_ADDRESS[0]}"
    return
  fi

  for name in "${APPS[@]}"
  do
    eval val=\"\$"${name}"\"
    if [ -n "${val}" ]; then
        IP=$(host -4 ${val} | awk 'match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/) { print substr($0, RSTART, RLENGTH) }')
        found=false
        # shellcheck disable=SC2068
        for ip_addr in ${IP_ADDRESS[@]}
        do
          if [ "${IP}" = "${ip_addr}" ] ; then
            found=true
          fi
        done
        if ! "${found}"; then
            MSG="IP address error: ${val}," "${IP_ADDRESS[@]}"
            logging_err "${MSG}"
            exit 1
        fi 
    fi 
  done
}

#
# create test_cert
#
create_test_cert() {
  logging_info "${FUNCNAME[0]}"

  openssl genrsa 2048 > "$2"/server.key
  openssl req -new -key "$2"/server.key << EOF > "$2"/server.csr
JP
Tokyo
Smart city
Let's FIWARE
FI-BB
$1
fiware@example.com
fiware
 
EOF
  openssl x509 -days 3650 -req -signkey "$2"/server.key < "$2"/server.csr > "$2"/server.crt
  openssl rsa -in "$2"/server.key -out "$2"/server.key << EOF
fiware
EOF
}


#
# setup test cert
#
setup_test_cert() {
  logging_info "${FUNCNAME[0]}"

  mkdir -p "${CERT_DIR}"/live

  if "$FIBB_TEST"; then
    SSL_CERTIFICATE=server.crt
    SSL_CERTIFICATE_KEY=server.key
  fi

  for name in "${APPS[@]}"
  do
    eval val=\"\$"${name}"\"
    if [ -n "${val}" ]; then
      mkdir "${CERT_DIR}"/live/"${val}"
      create_test_cert "${val}.${DOMAIN_NAME}" "${CERT_DIR}/live/${val}"
    fi 
  done
  cp "${TEMPLEATE}"/nginx.conf "${CONFIG_DIR}"/nginx/
}

#
# setup cert
#
setup_cert() {
  logging_info "${FUNCNAME[0]}"

  if "$FIBB_TEST"; then
    setup_test_cert
    return
  fi

  if [ -n "${CERT_TEST}" ]; then
    if "${CERT_TEST}"; then
      CERT_TEST=--test-cert
    else
      CERT_TEST=
    fi
  fi

  CERT_SH=./cert.sh
  if [ -e "${CERT_SH}" ]; then
    rm -f "${CERT_SH}"
  fi 

  cat <<EOF > ${CERT_SH}
#!/bin/bash

. ./.env

if [ \${EUID:-\${UID}} != 0 ]; then
  echo "This script must be run as root"
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
  if [ -d "${CERT_DIR}/live/\$1" ] && ${CERT_REVOKE}; then
    sudo docker run --rm -v ${CERT_DIR}:/etc/letsencrypt \${CERTBOT} revoke -n -v ${CERT_TEST} --cert-path ${CERT_DIR}/live/\$1/cert.pem
  fi

  if [ ! -d "${CERT_DIR}/live/\$1" ]; then
    wait \$1
    sudo docker run --rm -v \${CERTBOT_DIR}/\$1:/var/www/html/\$1 -v ${CERT_DIR}:/etc/letsencrypt \${CERTBOT} certonly ${CERT_TEST} --non-interactive --agree-tos -m \${CERT_EMAIL} --webroot -w /var/www/html/\$1 -d \$1
  else
    echo "Skip: ${CERT_DIR}/live/\$1 direcotry already exits"
  fi
}

RND=\$(od -An -tu1 -N1 /dev/urandom)
HOUR=\$(( \$RND % 5 ))
RND=\$(od -An -tu1 -N1 /dev/urandom)
MINUTE=\$(( \$RND % 60 ))

echo "\${MINUTE} \${HOUR} * * * root \${PWD}/config/script/renew.sh > /dev/null 2>&1" > /etc/cron.d/fiware-big-bang

EOF

  chmod +x ${CERT_SH}

  for name in "${APPS[@]}"
  do
    eval val=\"\$"${name}"\"
    if [ -n "${val}" ]; then
      if [ ! -d "${CERTBOT_DIR}"/"${val}" ]; then
        mkdir "${CERTBOT_DIR}"/"${val}"
      fi
      echo "cert ${val}" >> ${CERT_SH}
      sed -e "s/HOST/${val}/" "${TEMPLEATE}"/nginx-cert > "${NGINX_SITES}"/"${val}"
    fi 
  done

  cp "${TEMPLEATE}"/docker/setup-cert.yml ./docker-cert.yml
  cp "${TEMPLEATE}"/nginx.conf "${CONFIG_DIR}"/nginx/

  sudo "${DOCKER_COMPOSE}" -f docker-cert.yml up -d

  sudo ./cert.sh

  sudo "${DOCKER_COMPOSE}" -f docker-cert.yml down

  rm -f ${CERT_SH}
}

#
# Add fiware.conf
#
add_rsyslog_conf() {
  logging_info "${FUNCNAME[0]}"

  set +u
  while [ "$1" ]
  do
    cat <<EOF >> ${RSYSLOG_CONF}
:syslogtag,startswith,"[$1]" /var/log/fiware/$1.log
& stop

EOF
    echo "${LOG_DIR}/$1.log" >> "${LOGROTATE_CONF}"
    shift
  done
  set -u
}

#
# setup_logging
#
setup_logging() {
  logging_info "${FUNCNAME[0]}"

  if "${LOGGING}"; then
      # FI-BB log
      echo "${LOG_DIR}/fi-bb.log" >> "${LOGROTATE_CONF}"
      cat <<EOF >> ${RSYSLOG_CONF}
:syslogtag,contains,"FI-BB" /var/log/fiware/fi-bb.log
& stop

EOF

      files=("$(sed -z -e "s/\n/ /g" ${LOGROTATE_CONF})")
      # shellcheck disable=SC2068
      for file in ${files[@]}
      do
        sudo touch "${file}"
        if [ "${DISTRO}" = "Ubuntu" ]; then
          sudo chown syslog:adm "${file}"
        else
          sudo chown root:root "${file}"
          sudo chmod 0644 "${file}"
        fi
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
  logging_info "${FUNCNAME[0]}"

  MYSQL_ROOT_PASSWORD=$(pwgen -s 16 1)

  IDM_HOST=https://${KEYROCK}
  CB_HOST=https://${ORION}

  IDM_DB_HOST=mysql
  IDM_DB_NAME=idm
  IDM_DB_USER=idm
  IDM_DB_PASS=$(pwgen -s 16 1)

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

IDM_ADMIN_UID=${IDM_ADMIN_UID}
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

  cp -a "${TEMPLEATE}"/docker/setup-keyrock.yml ./docker-keyrock.yml

  sudo "${DOCKER_COMPOSE}" -f docker-keyrock.yml up -d

  while [ "200" != "$(curl http://localhost:3000/ -o /dev/null -w '%{http_code}\n' -s)" ]
  do
    sleep 1
  done

  ${NGSI_GO} server add --host "${IDM}" --serverType keyrock --serverHost http://localhost:3000 --idmType idm --username "${IDM_ADMIN_EMAIL}" --password "${IDM_ADMIN_PASS}"
}

#
# Tear down Keyrock
#
down_keyrock() {
  logging_info "${FUNCNAME[0]}"

  sudo "${DOCKER_COMPOSE}" -f docker-keyrock.yml down
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
  sed -e "s/HOST/$1/" "${TEMPLEATE}/$2" > "${NGINX_SITES}/$1"
}

#
# Add nginx depends_on
#
add_nginx_depends_on() {
  set +u
  while [ "$1" ]
  do
    sed -i -e "/ __NGINX_DEPENDS_ON__/ i \      - $1" ${DOCKER_COMPOSE_YML}
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
    sed -i -e "/ __NGINX_VOLUMES__/ i \      - $1" "${DOCKER_COMPOSE_YML}"
    shift
  done
  set -u
}

#
# Orion, Wilma and Tokenproxy
#
setup_orion() {
  logging_info "${FUNCNAME[0]}"

  cp "${TEMPLEATE}"/docker/docker-base.yml "${DOCKER_COMPOSE_YML}"

  rm -fr "${NGINX_SITES}"
  mkdir -p "${NGINX_SITES}"

  create_nginx_conf "${KEYROCK}" "nginx-keyrock"
  create_nginx_conf "${ORION}" "nginx-orion"

  add_rsyslog_conf "nginx" "orion" "mongo" "keyrock" "mysql" "pep-proxy" "tokenproxy"

  if [ -z "${WIRECLOUD}" ]; then
    # Create Applicaton for Orion
    AID=$(${NGSI_GO} applications --host "${IDM}" create --name "Orion" --description "Orion application" --url "https://${ORION}/" --redirectUri "https://${ORION}/complete/fiware/")
    SECRET=$(${NGSI_GO} applications --host "${IDM}" get --aid "${AID}" | jq -r .application.secret )
  else
    # Create Applicaton for WireCloud
    AID=$(${NGSI_GO} applications --host "${IDM}" create --name "WireCloud" --description "WireCloud application" --url "https://${WIRECLOUD}/" --redirectUri "https://${WIRECLOUD}/complete/fiware/")
    SECRET=$(${NGSI_GO} applications --host "${IDM}" get --aid "${AID}" | jq -r .application.secret )
    RID=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${AID}" create --name Admin)
    ${NGSI_GO} applications --host "${IDM}" users --aid "${AID}" assign --rid "${RID}" --uid "${IDM_ADMIN_UID}" > /dev/null
  fi

  ORION_CLIENT_ID=${AID}

  # Create PEP Proxy for FIWARE Orion
  PEP_PASSWORD=$(${NGSI_GO} applications --host "${IDM}" pep --aid "${AID}" create --run | jq -r .pep_proxy.password)
  PEP_ID=$(${NGSI_GO} applications --host "${IDM}" pep --aid "${AID}" list | jq -r .pep_proxy.id)

  mkdir -p "${CONFIG_DIR}/mongo"
  cp "${TEMPLEATE}/mongo-init.js" "${CONFIG_DIR}/mongo/"

  mkdir -p "${CONFIG_DIR}/tokenproxy"
  cp "${TEMPLEATE}/docker/Dockerfile.tokenproxy" "${CONFIG_DIR}/tokenproxy/Dockerfile"

  cat <<EOF >> .env

# Tokenproxy for Orion
CLIENT_ID=${AID}
CLIENT_SECRET=${SECRET}

# PEP Proxy for Orion
PEP_PROXY_APP_ID=${AID}
PEP_PROXY_USERNAME=${PEP_ID}
PEP_PASSWORD=${PEP_PASSWORD}
EOF
}

#
# Cygnus and Comet
#
setup_comet() {
  if [ -z "${COMET}" ]; then
    return
  fi 

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-comet.yml"

  create_nginx_conf "${COMET}" "nginx-comet"

  add_nginx_depends_on "comet" "cygnus"

  add_rsyslog_conf "cygnus" "comet"
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

  create_nginx_conf "${QUANTUMLEAP}" "nginx-quantumleap"

  add_nginx_depends_on  "quantumleap"

  add_rsyslog_conf "quantumleap" "redis" "crate"

  # Workaround for CrateDB. See https://crate.io/docs/crate/howtos/en/latest/deployment/containers/docker.html#troubleshooting
  sudo sysctl -w vm.max_map_count=262144
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

  create_nginx_conf "${WIRECLOUD}" "nginx-wirecloud"
  create_nginx_conf "${NGSIPROXY}" "nginx-ngsiproxy"

  add_nginx_depends_on "wirecloud" "ngsiproxy"

  add_nginx_volumes "./data/wirecloud/wirecloud-static:/var/www/static:ro"

  add_rsyslog_conf "wirecloud" "postgres" "elasticsearch" "memcached" "ngsiproxy"

  cat <<EOF >> .env

# Postgres

POSTGRES_PASSWORD=$(pwgen -s 16 1)
EOF

}

#
# Node-RED
#
setup_node_red() {
  if [ -z "${NODE_RED}" ]; then
    return
  fi

  logging_info "${FUNCNAME[0]}"

  add_docker_compose_yml "docker-node-red.yml"

  create_nginx_conf "${NODE_RED}" "nginx-node-red"

  add_nginx_depends_on  "node-red"

  add_rsyslog_conf "node-red"

  NODE_RED_URL=https://${NODE_RED}/
  NODE_RED_CALLBACK_URL=https://${NODE_RED}/auth/strategy/callback
  
  # Create application for Node-RED
  NODE_RED_CLIENT_ID=$(${NGSI_GO} applications --host "${IDM}" create --name "Node-RED" --description "Node-RED application" --url "${NODE_RED_URL}" --redirectUri "${NODE_RED_CALLBACK_URL}")
  NODE_RED_CLIENT_SECRET=$(${NGSI_GO} applications --host "${IDM}" get --aid "${NODE_RED_CLIENT_ID}" | jq -r .application.secret )

  # Create roles and add them to Admin
  RID=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${NODE_RED_CLIENT_ID}" create --name "/node-red/full")
  ${NGSI_GO} applications --host "${IDM}" users --aid "${NODE_RED_CLIENT_ID}" assign --rid "${RID}" --uid "${IDM_ADMIN_UID}" > /dev/null
  RID=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${NODE_RED_CLIENT_ID}" create --name "/node-red/read")
  ${NGSI_GO} applications --host "${IDM}" users --aid "${NODE_RED_CLIENT_ID}" assign --rid "${RID}" --uid "${IDM_ADMIN_UID}" > /dev/null
  RID=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${NODE_RED_CLIENT_ID}" create --name "/node-red/api")
  ${NGSI_GO} applications --host "${IDM}" users --aid "${NODE_RED_CLIENT_ID}" assign --rid "${RID}" --uid "${IDM_ADMIN_UID}" > /dev/null

  # Add Orion (or Wirecloud) application as a trusted application to Node-RED application
  ${NGSI_GO} applications --host "${IDM}" trusted --aid "${NODE_RED_CLIENT_ID}" add --tid "${ORION_CLIENT_ID}"  > /dev/null
  RID=$(${NGSI_GO} applications --host "${IDM}" roles --aid "${ORION_CLIENT_ID}" create --name "/node-red/api")
  ${NGSI_GO} applications --host "${IDM}" users --aid "${ORION_CLIENT_ID}" assign --rid "${RID}" --uid "${IDM_ADMIN_UID}" > /dev/null

  mkdir "${DATA_DIR}"/node-red
  sudo chown 1000:1000 "${DATA_DIR}"/node-red

  mkdir "${CONFIG_DIR}"/node-red
  cp "${TEMPLEATE}"/docker/Dockerfile.node-red "${CONFIG_DIR}"/node-red/Dockerfile
  cp "${TEMPLEATE}"/settings.js.node-red "${CONFIG_DIR}"/node-red/settings.js

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

  add_docker_compose_yml "/docker-grafana.yml"

  create_nginx_conf "${GRAFANA}" "nginx-grafana"

  add_nginx_depends_on  "grafana"

  add_rsyslog_conf "grafana"

  # Create application for Grafana
  GF_SERVER_ROOT_URL=https://${GRAFANA}/
  GF_SERVER_REDIRECT_URL=https://${GRAFANA}/login/generic_oauth
  GRAFANA_CLIENT_ID=$(${NGSI_GO} applications --host "${IDM}" create --name "Grafana" --description "Grafana application" --url "${GF_SERVER_ROOT_URL}" --redirectUri "${GF_SERVER_REDIRECT_URL}" --responseType "code,token,id_token")
  GRAFANA_CLIENT_SECRET=$(${NGSI_GO} applications --host "${IDM}" get --aid "${GRAFANA_CLIENT_ID}" | jq -r .application.secret )

  mkdir -p "${DATA_DIR}"/grafana
  sudo chown 472:472 "${DATA_DIR}"/grafana

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

setup_ngsi_go() {
  logging_info "${FUNCNAME[0]}"

  NGSI_GO="/usr/local/bin/ngsi --batch"
  SERVERS=("$(${NGSI_GO} server list --all -1)")

  for NAME in "${APPS[@]}"
  do
    eval VAL=\"\$"$NAME"\"
    if [ -n "$VAL" ]; then
      # shellcheck disable=SC2068
      for name in ${SERVERS[@]}
      do
        if [ "${VAL}" = "${name}" ]; then
          ngsi server delete --host "${name}"
        fi
      done
    fi
  done

  for NAME in "${APPS[@]}"
  do
    eval VAL=\"\$"$NAME"\"
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
# update nginx file
#
update_nginx_file() {
  logging_info "${FUNCNAME[0]}"

  for name in "${APPS[@]}"
  do
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
  chmod o+x "${CONFIG_DIR}/script/"*
}

#
# Setup end
#
setup_end() {
  logging_info "${FUNCNAME[0]}"

  sed -i -e "/# __NGINX_/d" ${DOCKER_COMPOSE_YML}
}

#
# clean up
#
clean_up() {
  logging_info "${FUNCNAME[0]}"

  rm -f docker-keyrock.yml
  rm -f docker-cert.yml
  rm -fr "${WORK_DIR}"
}

#
# main
#
setup_main() {
  logging_info "${FUNCNAME[0]}"

  setup_init
  make_dir

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

  update_nginx_file
  setup_ngsi_go
  setup_logging
  copy_scripts

  setup_end
}

setup_main

logging_info "docker-compose up -d --build"
sudo "${DOCKER_COMPOSE}" up -d --build

clean_up
