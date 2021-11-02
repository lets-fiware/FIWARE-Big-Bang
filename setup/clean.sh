#!/bin/sh

for file in docker-compose.yml docker-cert.yml docker-idm.yml
do
  if [ -e ${file} ]; then
    sudo /usr/local/bin/docker-compose -f ${file} down
    sleep 5
    rm -f ${file}
  fi
done

if [ -d ./data ]; then
  sudo rm -fr data
fi

sudo rm -fr ./config
rm -fr ./.work
rm -f ./.env
rm -f ./node-red_users.txt
rm -f .install
