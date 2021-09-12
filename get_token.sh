#!/bin/bash

. ./.env
curl -sS "${CB_HOST}/token" --data "username=${IDM_ADMIN_EMAIL}" --data "password=${IDM_ADMIN_PASS}" | jq -r .access_token
