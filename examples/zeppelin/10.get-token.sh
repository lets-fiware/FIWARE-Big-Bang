#!/bin/sh
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

curl -sS "https://${KEYROCK}/oauth2/token" \
  --user "${ZEPPELIN_CLIENT_ID}:${ZEPPELIN_CLIENT_SECRET}" \
  --data "grant_type=password" \
  --data "scope=jwt" \
  --data "username=${IDM_ADMIN_EMAIL}" \
  --data "password=${IDM_ADMIN_PASS}"
