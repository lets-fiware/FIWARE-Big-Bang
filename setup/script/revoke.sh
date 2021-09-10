#!/bin/sh
set -ue

if [ ${EUID:-${UID}} != 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

cd $(dirname $0)
cd ../..

logging() {
  echo $2
  /usr/bin/logger -is -p $1 -t "FI-BB" $2
}

logging "user.info" "cert revoke"

if [ ! -e ./.env ]; then
  logging "user.err" "./env not found"
  exit 1
fi

. ./.env

if [ -n "${CERT_TEST}" ] && "${CERT_TEST}"; then
  CERT_TEST=--test-cert
fi

/usr/local/bin/docker-compose down

for NAME in KEYROCK ORION COMET WIRECLOUD NGSIPROXY NODE_RED GRAFANA QUANTUMLEAP
do
  eval VAL=\"\$$NAME\"
  if [ -n "$VAL" ] && [ -d ${CERT_DIR}/live/${VAL} ]; then
    logging "user.info" "revoke ${VAL}"
    docker run --rm -v ${CERT_DIR}:/etc/letsencrypt ${CERTBOT} revoke -n -v --cert-path ${CERT_DIR}/live/${VAL}/cert.pem ${CERT_TEST}
  fi
done
