#!/bin/bash
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

logging "user.info" "cert renew"

if [ ! -e ./.env ]; then
  logging "user.err" "./env not found"
  exit 1
fi

. ./.env

if [ -n "${CERT_TEST}" ] && "${CERT_TEST}"; then
  CERT_TEST=--test-cert
fi

if [ -n "${CERT_FORCE_RENEWAL}" ] && "${CERT_FORCE_RENEWAL}"; then
  CERT_FORCE_RENEWAL=--force-renewal
fi

result=$(sudo docker run --rm -v ${CERTBOT_DIR}:/var/www/html -v ${CERT_DIR}:/etc/letsencrypt certbot/certbot:v1.18.0 renew --webroot -w /var/www/html ${CERT_TEST} --post-hook='echo FI-BB' $CERT_FORCE_RENEWAL)

logging "user.info" "${result}"

if echo "${result}" | grep -q "FI-BB"; then
  logging "user.info" "nginx reload"
  /usr/local/bin/docker-compose exec nginx nginx -s reload
fi
