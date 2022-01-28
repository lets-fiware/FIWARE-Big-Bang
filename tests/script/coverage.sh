#!/bin/bash

set -ue

#
# Logging
#
logging() {
  echo "$2"
  /usr/bin/logger -is -p "$1" -t "FI-BB" "$2"
}

#
# Install kcov
#
install_kcov() {
  logging "user.info" "${FUNCNAME[0]}"

  if type kcov >/dev/null 2>&1; then
    return
  fi
  sudo apt update
  sudo apt-get -y install binutils-dev libiberty-dev libcurl4-openssl-dev libelf-dev libdw-dev cmake gcc g++

  pushd /opt
  sudo sh -c "curl -sSL https://github.com/SimonKagstrom/kcov/archive/refs/tags/38.tar.gz | tar xz"
  sudo mkdir kcov-38/build
  cd kcov-38/build
  sudo cmake ..
  sudo make install
  popd
}

#
# Build certmock
#
build_certmock() {
  logging "user.info" "${FUNCNAME[0]}"

  pushd ./tests/certmock/
  sudo docker build -t letsfiware/certmock:0.2.0 .
  popd
}

#
# Reset env
#
reset_env() {
  sudo rm -fr config/ data/
  git checkout config.sh
}

#
# Remove example com from hosts
#
remove_example_com_from_hosts() {
  sudo sed -i -e "/example.com/d" /etc/hosts
}

#
# Wait for serive
#
wait() {
  logging "user.info" "${FUNCNAME[0]}"

  WAIT_TIME=300

  local host
  local ret

  host=$1
  ret=$2

  echo "Wait for ${host} to be ready (${WAIT_TIME} sec)" 1>&2

  for i in $(seq "${WAIT_TIME}")
  do
    # shellcheck disable=SC2086
    if [ "${ret}" == "$(curl ${host} -o /dev/null -w '%{http_code}\n' -s)" ]; then
      return
    fi
    sleep 1
  done

  logging "user.err" "${host}: Timeout was reached."
  exit 1
}

#
# Up keyrock for multi server
#
up_keyrock_for_multi_server() {
  cd ./tests/keyrock

  FIBB_KEYROCK_URL=http://localhost:3000/

  sudo /usr/local/bin/docker-compose -f keyrock-compose.yml up -d

  wait "${FIBB_KEYROCK_URL}" "200"

  sleep 3

  rm -f ngsi-go-config.json ngsi-go-token-cache.json
  FIBB_NGSI_GO="/usr/local/bin/ngsi --batch --config ./ngsi-go-config.json --cache ./ngsi-go-token-cache.json"

  ${FIBB_NGSI_GO} server add --host keyrock --serverType keyrock --serverHost "http://localhost:3000" --username "admin@example.com" --password "1234"

  FIBB_AID=$(${FIBB_NGSI_GO} applications --host keyrock create --name "Wilma" --description "Wilma application" --url "http://localhost/" --redirectUri "http://localhost/")
  FIBB_SECRET=$(${FIBB_NGSI_GO} applications --host keyrock get --aid "${FIBB_AID}" | jq -r .application.secret )
  ${FIBB_NGSI_GO} applications --host keyrock roles --aid "${FIBB_AID}" create --name "/node-red/api" > /dev/null

  FIBB_PEP_PASSWORD=$(${FIBB_NGSI_GO} applications --host keyrock  pep --aid "${FIBB_AID}" create --run | jq -r .pep_proxy.password)
  FIBB_PEP_ID=$(${FIBB_NGSI_GO} applications --host keyrock  pep --aid "${FIBB_AID}" list | jq -r .pep_proxy.id)

  cd - > /dev/null
}

#
# Down keyrock for multi server
#
down_keyrock_for_multi_server() {
  cd ./tests/keyrock

  sudo /usr/local/bin/docker-compose -f keyrock-compose.yml down

  rm -f ngsi-go-config.json ngsi-go-token-cache.json

  cd - > /dev/null
}

#
# setup
#
setup() {
  logging "user.info" "${FUNCNAME[0]}"

  LANG=C

  install_kcov
  build_certmock

  remove_example_com_from_hosts

  export FIBB_TEST=true
  export FIBB_TEST_MOCK_PATH="${PWD}/.mock/"
  export FIBB_TEST_IMAGE_CERTBOT="letsfiware/certmock:0.2.0"

  if [ -d coverage ]; then
    rm -fr coverage
  fi

  mkdir coverage

  if [ -e ~/.bashrc ]; then
    sed -i -e "/ngsi_bash_autocomplete/d" ~/.bashrc
  fi

  sudo rm -f /usr/local/bin/docker-compose
  sudo rm -f /etc/redhat-release

  local ngsi_go_version
  ngsi_go_version=v0.10.0

  curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/${ngsi_go_version}/ngsi-${ngsi_go_version}-linux-amd64.tar.gz
  sudo tar zxvf ngsi-${ngsi_go_version}-linux-amd64.tar.gz -C /usr/local/bin
  rm -f ngsi-${ngsi_go_version}-linux-amd64.tar.gz

  KCOV="/usr/local/bin/kcov --exclude-path=tests,.git,setup,coverage,.github,.vscode,examples,docs,.mock"

  SAVE_PATH=${PATH}

  MOCK_DIR=${PWD}/.mock
  rm -fr "${MOCK_DIR}"
  mkdir "${MOCK_DIR}"

  PATH="${MOCK_DIR}:${PATH}"

  cat <<EOF > "${MOCK_DIR}/apt"
#!/bin/sh
while [ "\$1" ]
do
  if [ "\$1" = "firewalld" ]; then
    exit 0
  fi
  shift
done
apt-get update 
sudo apt-get install -y curl pwgen jq make zip
EOF
  chmod +x "${MOCK_DIR}/apt"

  cat <<EOF > "${MOCK_DIR}/yum"
#!/bin/sh
while [ "\$1" ]
do
  if [ "\$1" = "epel-release" ] || [ "\$1" = "firewalld" ] || [ "\$1" = "yum-utils" ] || [ "\$1" = "docker-ce" ]; then
    exit 0
  fi
  shift
done
apt-get update 
sudo apt-get install -y curl pwgen jq make zip
EOF
  chmod +x "${MOCK_DIR}/yum"

  for cmd in systemctl fiware-cmd add-apt-repository apt-key apt-get yum-config-manager
  do
    echo "#!/bin/sh" > "${MOCK_DIR}/${cmd}"
    chmod +x "${MOCK_DIR}/${cmd}"
  done 

  echo "cat - > /dev/null" >> "${MOCK_DIR}/apt-key"

  reset_env
}

fibb_down() {
  logging "user.info" "${FUNCNAME[0]}"

  make down

  while [ "1" != "$(sudo docker ps | wc -l)" ]
  do
    sleep 1
  done

  sleep 5

  make clean
}

install_test1() {
  logging "user.info" "${FUNCNAME[0]}"

  sed -i -e "s/^\(ORION_EXPOSE_PORT=\).*/\1local/" config.sh
  sed -i -e "s/^\(CYGNUS=\).*/\1cygnus/" config.sh
  sed -i -e "s/^\(COMET=\).*/\1comet/" config.sh
  sed -i -e "s/^\(QUANTUMLEAP=\).*/\1quantumleap/" config.sh
  sed -i -e "s/^\(WIRECLOUD=\).*/\1wirecloud/" config.sh
  sed -i -e "s/^\(NGSIPROXY=\).*/\1ngsiproxy/" config.sh
  sed -i -e "s/^\(NODE_RED=\).*/\1node-red/" config.sh
  sed -i -e "s/^\(GRAFANA=\).*/\1grafana/" config.sh
  sed -i -e "s/^\(IOTAGENT_UL=\).*/\1iotagent-ul/" config.sh
  sed -i -e "s/^\(IOTAGENT_JSON=\).*/\1iotagent-json/" config.sh
  sed -i -e "s/^\(IOTAGENT_HTTP=\).*/\1iotagent-http/" config.sh
  sed -i -e "s/^\(MOSQUITTO=\).*/\1mosquitto/" config.sh
  sed -i -e "s/^\(ELASTICSEARCH=\).*/\1elasticsearch/" config.sh
  sed -i -e "s/^\(MQTT_1883=\).*/\1true/" config.sh
  sed -i -e "s/^\(MQTT_TLS=\).*/\1true/" config.sh
  sed -i -e "s/^\(FIREWALL=\).*/\1true/" config.sh
  sed -i -e "s/^\(QUERYPROXY=\).*/\1true/" config.sh
  sed -i -e "s/^\(POSTFIX=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_MONGO=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_MYSQL=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_POSTGRES=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_ELASTICSEARCH=\).*/\1true/" config.sh
  sed -i -e "s/^\(CYGNUS_EXPOSE_PORT=\).*/\1all/" config.sh

  sed -i -e "s/^\(REGPROXY=\).*/\1true/" config.sh
  sed -i -e "s/^\(REGPROXY_NGSITYPE=\).*/\1v2/" config.sh
  sed -i -e "s/^\(REGPROXY_HOST=\).*/\1http:\/\/remote-orion/" config.sh
  sed -i -e "s/^\(REGPROXY_IDMTYPE=\).*/\1tokenproxy/" config.sh
  sed -i -e "s/^\(REGPROXY_IDMHOST=\).*/\1\/token/" config.sh
  sed -i -e "s/^\(REGPROXY_USERNAME=\).*/\1fiware/" config.sh
  sed -i -e "s/^\(REGPROXY_PASSWORD=\).*/\1abcd/" config.sh

  ${KCOV} ./coverage ./lets-fiware.sh example.com
}


install_test2() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  ${KCOV} ./coverage ./lets-fiware.sh example.com
}

install_test3() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  git checkout config.sh

  sed -i -e "s/^\(CERT_REVOKE=\).*/\1true/" config.sh
  sed -i -e "s/^\(PERSEO=\).*/\1perseo/" config.sh
  sed -i -e "s/^\(PERSEO_SMTP_HOST=\).*/\1www.hostname.com/" config.sh
  sed -i -e "s/^\(PERSEO_SMTP_PORT=\).*/\125/" config.sh
  sed -i -e "s/^\(PERSEO_SMTP_SECURE=\).*/\1false/" config.sh

  sed -i -e "s/^\(DRACO=\).*/\1draco/" config.sh
  sed -i -e "s/^\(DRACO_MONGO=\).*/\1true/" config.sh
  sed -i -e "s/^\(DRACO_MYSQL=\).*/\1true/" config.sh
  sed -i -e "s/^\(DRACO_POSTGRES=\).*/\1true/" config.sh
  sed -i -e "s/^\(DRACO_EXPOSE_PORT=\).*/\1all/" config.sh
  sed -i -e "s/^\(DRACO_DISABLE_NIFI_DOCS=\).*/\1true/" config.sh

  sed -i -e "s/^\(ORION=\).*/\1/" config.sh
  sed -i -e "s/^\(ORION_LD=\).*/\1orion-ld/" config.sh

  ${KCOV} ./coverage ./lets-fiware.sh example.com
}

install_test4() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  # shellcheck disable=SC2207
  IPS=($(hostname -I))

  git checkout config.sh

  mkdir .work

  sed -i -e "s/^\(KEYROCK_POSTGRES=\).*/\1true/" config.sh
  sed -i -e "s/^\(WIRECLOUD=\).*/\1wirecloud/" config.sh
  sed -i -e "s/^\(NGSIPROXY=\).*/\1ngsiproxy/" config.sh
  sed -i -e "s/^\(NODE_RED=\).*/\1node-red/" config.sh
  sed -i -e "s/^\(NODE_RED_INSTANCE_NUMBER=\).*/\13/" config.sh
  sed -i -e "s/^\(IOTAGENT_UL=\).*/\1iotagent-ul/" config.sh
  sed -i -e "s/^\(IOTAGENT_HTTP=\).*/\1iotagent-http/" config.sh
  sed -i -e "s/^\(IOTA_HTTP_AUTH=\).*/\1basic/" config.sh
  sed -i -e "s/^\(MOSQUITTO=\).*/\1mosquitto/" config.sh

  export FIBB_TEST_DOCKER_CMD=rekcod
  export FIBB_TEST_SKIP_INSTALL_WIDGET=true

  sudo apt -y remove zip
  sudo apt -y autoremove

  ${KCOV} ./coverage ./lets-fiware.sh example.com "${IPS[0]}"

  export FIBB_TEST_DOCKER_CMD=
}

install_test5() {
  echo "*** Timeout was reached ***" 1>&2
  export FIBB_WAIT_TIME=1
  ${KCOV} ./coverage ./lets-fiware.sh example.com

  sudo docker-compose -f docker-idm.yml down

  while [ "1" != "$(sudo docker ps | wc -l)" ]
  do
    sleep 1
  done

  sleep 5

  reset_env

  unset FIBB_WAIT_TIME
}

install_on_centos() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  sudo touch /etc/redhat-release

  sudo apt remove -y jq

  reset_env

  sed -i -e "s/^\(FIREWALL=\).*/\1true/" config.sh
  sed -i -e "s/^\(IOTAGENT_UL=\).*/\1iotagent-ul/" config.sh
  sed -i -e "s/^\(IOTAGENT_HTTP=\).*/\1iotagent-http/" config.sh
  sed -i -e "s/^\(IOTA_HTTP_AUTH=\).*/\1none/" config.sh

  export FIBB_TEST_DOCKER_CMD=rekcod

  ${KCOV} ./coverage ./lets-fiware.sh example.com

  sudo rm -f /etc/redhat-release
  export FIBB_TEST_DOCKER_CMD=

  sleep 5

  fibb_down
}

#
# Test multi server installation
#
multi_server_test1() {
  logging "user.info" "${FUNCNAME[0]}"

  reset_env

  up_keyrock_for_multi_server

  sleep 2

  sed -i -e "s/^\(KEYROCK=\).*/\1/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_KEYROCK=\).*/\1http:\/\/localhost:3000/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_EMAIL=\).*/\1admin@example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_PASS=\).*/\11234/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PROXY_USERNAME=\).*/\1${FIBB_PEP_ID}/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PASSWORD=\).*/\1${FIBB_PEP_PASSWORD}/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_CLIENT_ID=\).*/\1${FIBB_AID}/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_CLIENT_SECRET=\).*/\1${FIBB_SECRET}/" config.sh

  ${KCOV} ./coverage ./lets-fiware.sh example.com

  down_keyrock_for_multi_server

  fibb_down

  reset_env

  sleep 5
}

#
# Test multi server installation
#
multi_server_test2() {
  logging "user.info" "${FUNCNAME[0]}"

  reset_env

  up_keyrock_for_multi_server

  sleep 2

  sed -i -e "s/^\(KEYROCK=\).*/\1/" config.sh
  sed -i -e "s/^\(ORION=\).*/\1/" config.sh
  sed -i -e "s/^\(NODE_RED=\).*/\1node-red/" config.sh
  sed -i -e "s/^\(PERSEO=\).*/\1perseo/" config.sh
  sed -i -e "s/^\(WIRECLOUD=\).*/\1wirecloud/" config.sh
  sed -i -e "s/^\(NGSIPROXY=\).*/\1ngsiproxy/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_KEYROCK=\).*/\1http:\/\/localhost:3000/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_EMAIL=\).*/\1admin@example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_PASS=\).*/\11234/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PROXY_USERNAME=\).*/\1${FIBB_PEP_ID}/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PASSWORD=\).*/\1${FIBB_PEP_PASSWORD}/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_CLIENT_ID=\).*/\1${FIBB_AID}/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_CLIENT_SECRET=\).*/\1${FIBB_SECRET}/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ORION_HOST=\).*/\1orion.exmaple.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_QUANTUMLEAP_HOST=\).*/\1quantumleap.exmaple.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ORION_INTERNAL_IP=\).*/\1192.168.0.1/" config.sh

  export FIBB_TEST_SKIP_INSTALL_WIDGET=true

  ${KCOV} ./coverage ./lets-fiware.sh example.com

  down_keyrock_for_multi_server

  fibb_down

  export FIBB_TEST_SKIP_INSTALL_WIDGET=

  reset_env

  sleep 5
}

error_test() {
  logging "user.info" "${FUNCNAME[0]}"

  sleep 5

  reset_env

  touch .install
  touch docker-compose.yml
  mkdir data

  echo "*** aarch64 not supported ***" 1>&2
  echo -e "#!/bin/sh\necho \"aarch64\"" >> "${MOCK_DIR}/uname"
  chmod +x "${MOCK_DIR}/uname"
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  rm -f "${MOCK_DIR}/uname"
  reset_env

  echo "*** Docker engine version error ***" 1>&2
  echo -e "#!/bin/sh\necho \"20.10.1\"" >> "${MOCK_DIR}/docker"
  chmod +x "${MOCK_DIR}/docker"
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  rm -f "${MOCK_DIR}/docker"
  reset_env

  ln -s /usr/bin/docker "${MOCK_DIR}/docker"

  echo "*** host command ***" 1>&2
  echo -e "#!/bin/sh" >> "${MOCK_DIR}/host"
  chmod +x "${MOCK_DIR}/host"
  FIBB_TEST_HOST_CMD="${MOCK_DIR}/host"
  ${KCOV} ./coverage ./lets-fiware.sh example.com 0.0.0.0
  reset_env
  unset FIBB_TEST_HOST_CMD

  sudo sed -i -e "/example.com/d" /etc/hosts

  echo "*** IP address error ***" 1>&2
  ${KCOV} ./coverage ./lets-fiware.sh example.com 0.0.0.0
  reset_env

  echo "*** config.sh not found ***" 1>&2
  rm config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** Args error ***" 1>&2
  ${KCOV} ./coverage ./lets-fiware.sh example.com example.com example.com
  reset_env

  echo "*** NGSIPROXY is empty ***" 1>&2
  sed -i -e "s/^\(WIRECLOUD=\).*/\1wirecloud/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** IOTAGENT_UL is empty ***" 1>&2
  sed -i -e "s/^\(IOTAGENT_UL=\).*/\1iotagent/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** Both MQTT_1883 and MQTT_TLS are false ***" 1>&2
  sed -i -e "s/^\(IOTAGENT_UL=\).*/\1iotagent-ul/" config.sh
  sed -i -e "s/^\(MOSQUITTO=\).*/\1mosquitto/" config.sh
  sed -i -e "s/^\(MQTT_1883=\).*/\1false/" config.sh
  sed -i -e "s/^\(MQTT_TLS=\).*/\1false/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** NODE_RED_INSTANCE_NUMBER out of range ***" 1>&2
  sed -i -e "s/^\(NODE_RED_INSTANCE_NUMBER=\).*/\1100/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** Keyrock is empty (Set either KEYROCK or MULTI_SERVER_KEYROCK) ***" 1>&2
  sed -i -e "s/^\(KEYROCK=\).*/\1/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** Orion is empty ***" 1>&2
  sed -i -e "s/^\(ORION=\).*/\1/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** Not Ubuntu ***" 1>&2
  if [ -e /etc/lsb-release ]; then
    sudo mv /etc/lsb-release /etc/_lsb-release
cat <<EOF > /tmp/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=Xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04 LTS"
EOF
    sudo mv /tmp/lsb-release /etc/lsb-release
    ${KCOV} ./coverage ./lets-fiware.sh example.com
    reset_env
    sudo rm /etc/lsb-release
    sudo mv /etc/_lsb-release /etc/lsb-release
  fi
 
  echo "*** Not Ubuntu ***" 1>&2
  if [ -e /etc/lsb-release ]; then
    sudo mv /etc/lsb-release /etc/_lsb-release
    ${KCOV} ./coverage ./lets-fiware.sh example.com
    reset_env
    sudo mv /etc/_lsb-release /etc/lsb-release
  fi
 
  echo "*** Unknown distro ***" 1>&2
  if [ -e /etc/debian_version ]; then
    sudo mv /etc/debian_version /etc/_debian_version
    ${KCOV} ./coverage ./lets-fiware.sh example.com
    reset_env
    sudo mv /etc/_debian_version /etc/debian_version
  fi
 
  echo "*** ELASTICSEARCH is empty ***" 1>&2
  sed -i -e "s/^\(CYGNUS=\).*/\1cygnus/" config.sh
  sed -i -e "s/^\(CYGNUS_ELASTICSEARCH=\).*/\1true/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env
 
  echo "*** Specify one or more Cygnus sinks ***" 1>&2
  sed -i -e "s/^\(CYGNUS=\).*/\1cygnus/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** Specify one or more sinks ***" 1>&2
  sed -i -e "s/^\(DRACO=\).*/\1draco/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "Set either Cygnus or Draco" 1>&2
  sed -i -e "s/^\(CYGNUS=\).*/\1cygnus/" config.sh
  sed -i -e "s/^\(DRACO=\).*/\1draco/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "Set either Orion or Orion-LD" 1>&2
  sed -i -e "s/^\(ORION=\).*/\1orion/" config.sh
  sed -i -e "s/^\(ORION_LD=\).*/\1orion-ld/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** IOTA_HTTP_AUTH is unknwon value ***" 1>&2
  sed -i -e "s/^\(IOTAGENT_UL=\).*/\1iotagent-ul/" config.sh
  sed -i -e "s/^\(IOTAGENT_HTTP=\).*/\1iotagent-http/" config.sh
  sed -i -e "s/^\(IOTA_HTTP_AUTH=\).*/\1error/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** Set either KEYROCK or MULTI_SERVER_KEYROCK ***" 1>&2
  sed -i -e "s/^\(KEYROCK=\).*/\1keyrock/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_KEYROCK=\).*/\1https::\/\/keyrock.example.com/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** Queryroxy is enabled but Orion not found***" 1>&2
  sed -i -e "s/^\(ORION=\).*/\1/" config.sh
  sed -i -e "s/^\(QUERYPROXY=\).*/\1true/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** MULTI_SERVER_KEYROCK not http or https ***" 1>&2
  sed -i -e "s/^\(KEYROCK=\).*/\1/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_KEYROCK=\).*/\1keyrock.example.com/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** MULTI_SERVER_ADMIN_EMAIL or MULTI_SERVER_ADMIN_PASS is empty ***" 1>&2
  sed -i -e "s/^\(KEYROCK=\).*/\1/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_KEYROCK=\).*/\1https:\/\/keyrock.example.com/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** MULTI_SERVER_PEP_PROXY_USERNAME or MULTI_SERVER_PEP_PASSWORD is empty ***" 1>&2
  sed -i -e "s/^\(KEYROCK=\).*/\1/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_KEYROCK=\).*/\1https:\/\/keyrock.example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_EMAIL=\).*/\1admin@example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_PASS=\).*/\11234/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** MULTI_SERVER_CLIENT_ID or MULTI_SERVER_CLIENT_SECRET is empty ***" 1>&2
  sed -i -e "s/^\(KEYROCK=\).*/\1/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_KEYROCK=\).*/\1https:\/\/keyrock.example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_EMAIL=\).*/\1admin@example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_PASS=\).*/\11234/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PROXY_USERNAME=\).*/\1FIBB_PEP_ID/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PASSWORD=\).*/\1FIBB_PEP_PASSWORD/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** MULTI_SERVER_ORION_INTERNAL_IP not found ***" 1>&2
  sed -i -e "s/^\(KEYROCK=\).*/\1/" config.sh
  sed -i -e "s/^\(ORION=\).*/\1/" config.sh
  sed -i -e "s/^\(PERSEO=\).*/\1perseo/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_KEYROCK=\).*/\1https:\/\/keyrock.example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_EMAIL=\).*/\1admin@example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_PASS=\).*/\11234/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PROXY_USERNAME=\).*/\1FIBB_PEP_ID/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PASSWORD=\).*/\1FIBB_PEP_PASSWORD/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_CLIENT_ID=\).*/\1FIBB_AID/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_CLIENT_SECRET=\).*/\1FIBB_SECRET/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env

  echo "*** MULTI_SERVER_ORION_HOST not found ***" 1>&2
  sed -i -e "s/^\(KEYROCK=\).*/\1/" config.sh
  sed -i -e "s/^\(ORION=\).*/\1/" config.sh
  sed -i -e "s/^\(WIRECLOUD=\).*/\1wirecloud/" config.sh
  sed -i -e "s/^\(NGSIPROXY=\).*/\1ngsiproxy/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_KEYROCK=\).*/\1https:\/\/keyrock.example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_EMAIL=\).*/\1admin@example.com/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_ADMIN_PASS=\).*/\11234/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PROXY_USERNAME=\).*/\1FIBB_PEP_ID/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_PEP_PASSWORD=\).*/\1FIBB_PEP_PASSWORD/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_CLIENT_ID=\).*/\1FIBB_AID/" config.sh
  sed -i -e "s/^\(MULTI_SERVER_CLIENT_SECRET=\).*/\1FIBB_SECRET/" config.sh
  ${KCOV} ./coverage ./lets-fiware.sh example.com
  reset_env
}

#
# main
#
main() {
  setup

  error_test

  install_test1

  install_test2

  fibb_down

  install_test3

  fibb_down

  install_test4

  fibb_down

  install_on_centos

  install_test5

  multi_server_test1

  multi_server_test2

  remove_example_com_from_hosts
}

main "$@"
