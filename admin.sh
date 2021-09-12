#!/bin/sh

. ./.env

echo "IDM: https://${KEYROCK}"
echo "User: ${IDM_ADMIN_EMAIL}"
echo "Password: ${IDM_ADMIN_PASS}"
