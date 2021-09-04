#!/bin/sh

if [ -d ./data ]; then
  sudo rm -fr data
fi

for file in docker-compose.yml docker-cert.yml docker-keyrock.yml
do
  if [ -e ${file} ]; then
    sudo /usr/local/bin/docker-compose -f ${file} down
    sleep 5
    rm -f ${file}
  fi
done

rm -fr ./config
rm -fr ./.work
rm -f ./.env
