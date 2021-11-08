#!/bin/bash

. ./.env
curl -sS "https://${KEYROCK}/token" --data "username=${IDM_ADMIN_EMAIL}" --data "password=${IDM_ADMIN_PASS}" | jq -r .access_token
