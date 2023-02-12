#!/bin/bash

#
# Keyrock
#
# Set a sub-domain name of Keyrock
KEYROCK=keyrock

# Set a name of an admin user for Keyrock. Default: admin
IDM_ADMIN_USER=

# Set an e-mail address of an admin user for Keyrock. Default: IDM_ADMIN_NAME @ DOMAIN_NAME
IDM_ADMIN_EMAIL=

# Set a password of an admin user for Keyrock. Default: automatically generated
IDM_ADMIN_PASS=

# Use Postfix (local delivery). (true or false) Default: false
POSTFIX=

# Use PostgreSQL as back-end database for Keyrock. (true or false) Default: false
KEYROCK_POSTGRES=

# Logging level for Keyrock
#   https://github.com/ging/fiware-idm/blob/master/doc/installation_and_administration_guide/environment_variables.md
#   true and false
IDM_DEBUG=false

# Docker image for Keyrock
IMAGE_KEYROCK=letsfiware/idm:8.1.0

# Docker image for Postfix
IMAGE_POSTFIX=letsfiware/postfix:0.23.0

#
# Wilma
#
# Docker image for Wilma
IMAGE_WILMA=letsfiware/pep-proxy:8.1.0

#
# Orion
#
# Set a sub-domain name of Orion
ORION=orion

# Expose port 1026 (none, local, all) Default: none
ORION_EXPOSE_PORT=

# Docker image for Orion
IMAGE_ORION=telefonicaiot/fiware-orion:3.8.0

#
# Orion-LD
#
# Set a sub-domain name of Orion-LD
ORION_LD=

# Expose port 1026 (none, local, all) Default: none
ORION_LD_EXPOSE_PORT=

# Docker image for Orion
IMAGE_ORION_LD=fiware/orion-ld:1.1.2

#
# Mintaka
#
# Enable Mintaka (false, true) Default: true
MINTAKA=

# Expose port 8080 (none, local, all) Default: none
MINTAKA_EXPOSE_PORT=

# Docker image for Mintaka
IMAGE_MINTAKA=fiware/mintaka:0.5.31

# Set a password for Timescale DB. Default: automatically generated
TIMESCALE_PASS=

# Expose port 5432 (none, local, all) Default: none
TIMESCALE_EXPOSE_PORT=

# Docker image for Timescale DB
IMAGE_TIMESCALE=timescale/timescaledb-postgis:1.7.5-pg12

#
# Cygnus
#
# Set a sub-domain name of Cygnus
CYGNUS=

# Use Cygnus sink (true or false) Default: false
CYGNUS_MONGO=
CYGNUS_MYSQL=
CYGNUS_POSTGRES=
CYGNUS_ELASTICSEARCH=

# Expose port (none, local, all) Default: none
CYGNUS_EXPOSE_PORT=

# Logging level for Cygnus
#   https://github.com/telefonicaid/fiware-cygnus/blob/master/doc/cygnus-common/installation_and_administration_guide/install_with_docker.md
#   INFO, DEBUG
CYGNUS_LOG_LEVEL=INFO

# Docker image for Cygnus
IMAGE_CYGNUS=telefonicaiot/fiware-cygnus:2.20.0

# Set a sub-domain name of Elasticsearch
ELASTICSEARCH=

# Elasticsearch Java options
ELASTICSEARCH_JAVA_OPTS="-Xmx256m -Xms256m"

# Expose port (none, local, all) Default: none
ELASTICSEARCH_EXPOSE_PORT=

# Docker image for Elasticsearch
IMAGE_ELASTICSEARCH_DB=elasticsearch:7.6.2

#
# Comet
#
# Set a sub-domain name of Comet
COMET=

# Expose port (none, local, all) Default: none
COMET_EXPOSE_PORT=

# Comet
#   https://github.com/telefonicaid/fiware-sth-comet/blob/master/doc/manuals/running.md
#   Possible values are: "DEBUG", "INFO", "WARN", "ERROR" and "FATAL"
COMET_LOGOPS_LEVEL=INFO

# Docker image for Comet
IMAGE_COMET=telefonicaiot/fiware-sth-comet:2.10.0

#
# Perseo
#
PERSEO=

# Perseo Max age (default: 6000)
PERSEO_MAX_AGE=

# Perseo SMTP host
PERSEO_SMTP_HOST=

# Perseo SMTP port
PERSEO_SMTP_PORT=

# Perseo SMTP secure
PERSEO_SMTP_SECURE=

# Perseo LOG LEVEL
PERSEO_LOG_LEVEL=

# Docker images for Perseo
IMAGE_PERSEO_CORE=telefonicaiot/perseo-core:1.13.0
IMAGE_PERSEO_FE=telefonicaiot/perseo-fe:1.26.0

#
# Draco
#
DRACO=

# Use Draco sink (true or false) Default: false
DRACO_MONGO=
DRACO_MYSQL=
DRACO_POSTGRES=

# Expose port (none, local, all) Default: none
DRACO_EXPOSE_PORT=

# Disable /nifi-docs/ url
DRACO_DISABLE_NIFI_DOCS=

# Docker image for Draco
IMAGE_DRACO=ging/fiware-draco:2.1.0

#
# Quantumleap
#
# Set a sub-domain name of Quantumleap
QUANTUMLEAP=

# Expose port (none, local, all) Default: none
QUANTUMLEAP_EXPOSE_PORT=

# Quantumleap
#   INFO, DEBUG
QUANTUMLEAP_LOGLEVEL=INFO

# Docker image for Quantumleap
IMAGE_QUANTUMLEAP=orchestracities/quantumleap:0.8.3

# Docker image for Crate DB
IMAGE_CRATE=crate:4.6.6

#
# WireCloud
#
# Set a sub-domain name of WireCloud
WIRECLOUD=

# Set a sub-domain name of Ngsiproxy
NGSIPROXY=

# WireCloud
#   https://github.com/Wirecloud/docker-wirecloud/blob/master/README.md
WIRECLOUD_LOGLEVEL=INFO

# Docker image for WireCloud
IMAGE_WIRECLOUD=fiware/wirecloud:1.3.1

# Docker image for Ngsiproxy
IMAGE_NGSIPROXY=fiware/ngsiproxy:1.2.2

# Docker image for Redis
IMAGE_REDIS=redis:6

# Docker image for Elasticsearch
IMAGE_ELASTICSEARCH=elasticsearch:2.4

# Docker image for Memcached
IMAGE_MEMCACHED=memcached:1

#
# IoT Agent over Mosquitto
#
# Set a sub-domain name of Mosquitto
MOSQUITTO=

# Use MQTT (Port 1883). (true or false) Default: false
MQTT_1883=

# Use MQTT TLS (Port 8883). (true or false) Default: true
MQTT_TLS=

# Set username for MQTT. Defaut: fiware
MQTT_USERNAME=

# Set password for MQTT. Defaut: automatically generated
MQTT_PASSWORD=

#   https://mosquitto.org/man/mosquitto-conf-5.html
#   debug, error, warning, notice, information, subscribe, unsubscribe, websockets, none, all
MOSQUITTO_LOG_TYPE=error,warning,notice,information

# Docker image for Mosquitto
IMAGE_MOSQUITTO=eclipse-mosquitto:1.6

#
# IoT Agent over HTTP
#
# Set a sub-domain name to use IoT Agent over HTTP.
IOTAGENT_HTTP=

# Authorization for IoT Agent over HTTP. (none, basic or bearer) Default: bearer
IOTA_HTTP_AUTH=

# User for Basic authorization for IoT Agent over HTTP. Default: fiware
IOTA_HTTP_BASIC_USER=

# Pasword for Basic authorization for IoT Agent over HTTP. Default: automatically generated
IOTA_HTTP_BASIC_PASS=

#
# IoT Agent for UltraLight 2.0
#
# Set a sub-domain name of IoT Agent for UltraLight 2.0
IOTAGENT_UL=

IOTA_UL_DEFAULT_RESOURCE=/iot/ul
IOTA_UL_TIMESTAMP=true
IOTA_UL_AUTOCAST=true

# Iot Agent for UltraLight 2.0
IOTA_UL_LOG_LEVEL=INFO

# Docker image for IoT Agent for UltraLight 2.0
IMAGE_IOTAGENT_UL=telefonicaiot/iotagent-ul:1.24.0

#
# IoT Agent for JSON
#
# Set a sub-domain name of IoT Agent for JSON
IOTAGENT_JSON=

IOTA_JSON_DEFAULT_RESOURCE=/iot/json
IOTA_JSON_TIMESTAMP=true
IOTA_JSON_AUTOCAST=true

# Iot Agent for JSON
IOTA_JSON_LOG_LEVEL=INFO

# Docker image for IoT Agent for JSON
IMAGE_IOTAGENT_JSON=telefonicaiot/iotagent-json:1.25.0

#
# Node-RED
#
# Set a sub-domain name of Node-RED
NODE_RED=

# Node-RED multi instance
# Number of Node-RED instance. default: 1
NODE_RED_INSTANCE_NUMBER=

# username for Node-RED instance. default: node-red
NODE_RED_INSTANCE_USERNAME=

# httpNodeRoot for Node-RED instance. default: / or /node-red???
#   Must be a path starting with '/'
NODE_RED_INSTANCE_HTTP_NODE_ROOT=

# httpAdminRoot for Node-RED instance. default: / or /node-red???
#   Must be a path starting with '/'
NODE_RED_INSTANCE_HTTP_ADMIN_ROOT=

# Logging level for Node-RED
#   https://nodered.org/docs/user-guide/runtime/logging
NODE_RED_LOGGING_LEVEL=info
NODE_RED_LOGGING_METRICS=
NODE_RED_LOGGING_AUDIT=

# Docker image for Node-RED
IMAGE_NODE_RED=letsfiware/node-red:0.23.0

#
# Grafana
#
# Set a sub-domain name of Grafana
GRAFANA=

# Logging level for Grafana
#   https://grafana.com/docs/grafana/latest/administration/configuration/#configure-with-environment-variables
#   https://github.com/grafana/grafana/blob/main/conf/defaults.ini
#   "debug", "info", "warn", "error", "critical"
GF_LOG_LEVEL=info

IMAGE_GRAFANA=grafana/grafana:6.1.6

#
# Zeppelin
#
# Set a sub-domain name of Zeppelin
ZEPPELIN=

# Logging level for Zeppelin
ZEPPELIN_DEBUG=

# Docker image for Zeppelin
IMAGE_ZEPPELIN=letsfiware/zeppelin:0.23.0

#
# Queryproxy
#
# Use queryproxy. (true or false) Default: false
QUERYPROXY=

# Logging level for Queryproxy
QUERYPROXY_LOGLEVEL=info

# Docker image for Queryproxy
IMAGE_QUERYPROXY=letsfiware/queryproxy:0.23.0

#
# Tokenproxy
#
# Logging level for Tokenproxy
TOKENPROXY_LOGLEVEL=info

# Use verbose mode
TOKENPROXY_VERBOSE=

# Docker image for Tokenproxy
IMAGE_TOKENPROXY=letsfiware/tokenproxy:0.23.0

#
# Regproxy
#
# Use regproxy. (true or false) Default: false
REGPROXY=

# NgsiType for remote broker. (v2 or ld) Default: v2
REGPROXY_NGSITYPE=

# Host for remote broker.
REGPROXY_HOST=

# IdM type for remote broker.
REGPROXY_IDMTYPE=

# IdM host for remote broker.
REGPROXY_IDMHOST=

# username for remote broker.
REGPROXY_USERNAME=

# password for remote broker.
REGPROXY_PASSWORD=

# client id for remote broker.
REGPROXY_CLIENT_ID=

# client secret for remote broker.
REGPROXY_CLIENT_SECRET=

# Regproxy log level
REGPROXY_LOGLEVEL=info

# Regproxy verbose
REGPROXY_VERBOSE=false

# Docker image for Regproxy
IMAGE_REGPROXY=letsfiware/regproxy:0.23.0

#
# MongoDB
#
# Expose port (none, local, all) Default: none
MONGO_EXPOSE_PORT=

# Docker images for MongoDB
IMAGE_MONGO=mongo:4.4

#
# MySQL
#
# Expose port (none, local, all) Default: none
MYSQL_EXPOSE_PORT=

# Docker images for MySQL
IMAGE_MYSQL=mysql:5.7

#
# PostgreSQL
#
# Expose port (none, local, all) Default: none
POSTGRES_EXPOSE_PORT=

# Docker images for PostgreSQL
IMAGE_POSTGRES=postgres:15

#
# Nginx
#
# Docker images for Nginx
IMAGE_NGINX=nginx:1.21

#
# Firewall (firewalld)
#
# Enable firewall. (true or false) Default: false
FIREWALL=

#
# Certbot options
#
# Set a e-mail address for certbot. Defaul: a e-mail address of an admin user for Keyrock.
CERT_EMAIL=

# Revoke and reacquire the certificate. (true or false) Default: false
CERT_REVOKE=

# Use --test-cert option.
# CERT_TEST=--test-cert
CERT_TEST=

# Use --force-renewal option. (true or false) Default: false
CERT_FORCE_RENEWAL=

# Docker image for Certbot
IMAGE_CERTBOT=certbot/certbot:v1.18.0

#
# Multi-server mode
#
MULTI_SERVER_KEYROCK=
MULTI_SERVER_ADMIN_EMAIL=
MULTI_SERVER_ADMIN_PASS=

MULTI_SERVER_PEP_PROXY_USERNAME=
MULTI_SERVER_PEP_PASSWORD=

MULTI_SERVER_CLIENT_ID=
MULTI_SERVER_CLIENT_SECRET=

MULTI_SERVER_ORION_HOST=
MULTI_SERVER_QUANTUMLEAP_HOST=

MULTI_SERVER_ORION_INTERNAL_IP=
