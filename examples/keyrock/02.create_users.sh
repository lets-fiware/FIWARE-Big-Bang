#!/bin/sh
set -ue

HOST=keyrock
DOMAIN=example.com

for id in $(seq 10)
do
 USER=$(printf "user%03d" $id)
 PASS=$(pwgen -s 16 1)
 ngsi users create --host "${HOST}.${DOMAIN}" --username "${USER}" --email "${USER}@${DOMAIN}" --password "${PASS}" > /dev/null
 echo "${USER}@${DOMAIN} ${PASS}"
done
