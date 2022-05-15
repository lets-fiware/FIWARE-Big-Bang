#!/bin/sh

for file in docker-compose.yml docker-cert.yml docker-idm.yml
do
  if [ -e ${file} ]; then
    /usr/bin/docker compose -f ${file} down --remove-orphans
    sleep 5
    rm -f ${file}
  fi
done

if [ -d ./data ]; then
  sudo rm -fr data
fi

if [ -e setup_ngsi_go.sh ]; then
  sudo rm -f setup_ngsi_go.sh
fi

sudo rm -fr ./config
rm -fr ./.work
rm -f ./.env
rm -f ./node-red_users.txt
rm -f .install
