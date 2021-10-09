#!/bin/bash

#
# Required parameters
#
KEYROCK=keyrock
ORION=orion

#
# Optional parameters
#

# Set a sub-domain name of the FIWARE GE you want to set.
COMET=
QUANTUMLEAP=
WIRECLOUD=
NGSIPROXY=
IOTAGENT=

NODE_RED=
GRAFANA=
MOSQUITTO=

# Use queryproxy. (true or false) Default: false
QUERYPROXY=

# Use MQTT (Port 1883). (true or false) Default: false
MQTT_1883=

# Use MQTT TLS (Port 8883). (true or false) Default: true
MQTT_TLS=

# Use PostgreSQL as back-end database for Keyrock. (true or false) Default: false
KEYROCK_POSTGRES=

# Set username for MQTT. Defaut: fiware
MQTT_USERNAME=

# Set password for MQTT. Defaut: automatically generated
MQTT_PASSWORD=

# Set a name of an admin user for Keyrock. Default: admin
IDM_ADMIN_USER=

# Set an e-mail address of an admin user for Keyrock. Default: IDM_ADMIN_NAME @ DOMAIN_NAME
IDM_ADMIN_EMAIL=

# Set a password of an admin user for Keyrock. Default: automatically generated
IDM_ADMIN_PASS=

# Enable firewall. (true or false) Default: false
FIREWALL=

# Node-RED multi instance
# Number of Node-RED instance. default: 1
NODE_RED_INSTANCE_NUMBER=

# username for Node-RED instance. default: node-red
NODE_RED_INSTANCE_USERNAME=

# httpNodeRoot for Node-RED instance. default: / or /node-red???
NODE_RED_INSTANCE_HTTP_NODE_ROOT=

# httpAdminRoot for Node-RED instance. default: / or /node-red???
NODE_RED_INSTANCE_HTTP_ADMIN_ROOT=

#
# Regproxy options
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

# Docker images
IMAGE_KEYROCK=fiware/idm:8.1.0
IMAGE_WILMA=fiware/pep-proxy:8.1.0
IMAGE_ORION=fiware/orion:3.2.0
IMAGE_CYGNUS=fiware/cygnus-ngsi:2.10.0
IMAGE_COMET=fiware/sth-comet:2.8.0
IMAGE_WIRECLOUD=fiware/wirecloud:1.3.1
IMAGE_NGSIPROXY=fiware/ngsiproxy:1.2.2
IMAGE_QUANTUMLEAP=orchestracities/quantumleap:0.8.1
IMAGE_IOTAGENT=fiware/iotagent-ul:1.16.2

IMAGE_MONGO=mongo:4.4
IMAGE_MYSQL=mysql:5.7
IMAGE_POSTGRES=postgres:11
IMAGE_CRATE=crate:4.1.4

IMAGE_TOKENPROXY=letsfiware/tokenproxy:0.5.0-next
IMAGE_QUERYPROXY=letsfiware/queryproxy:0.5.0-next
IMAGE_REGPROXY=letsfiware/regproxy:0.5.0-next

IMAGE_NGINX=nginx:1.21
IMAGE_REDIS=redis:6
IMAGE_ELASTICSEARCH=elasticsearch:2.4
IMAGE_MEMCACHED=memcached:1
IMAGE_GRAFANA=grafana/grafana:6.1.6
IMAGE_MOSQUITTO=eclipse-mosquitto:1.6
IMAGE_NODE_RED=letsfiware/node-red:0.5.0-next

IMAGE_CERTBOT=certbot/certbot:v1.18.0

# Logging option

# Keyrock
#   https://github.com/ging/fiware-idm/blob/master/doc/installation_and_administration_guide/environment_variables.md
#   true and false
IDM_DEBUG=false

# Cygnus
#   https://github.com/telefonicaid/fiware-cygnus/blob/master/doc/cygnus-common/installation_and_administration_guide/install_with_docker.md
#   INFO, DEBUG
CYGNUS_LOG_LEVEL=INFO

# Comet
#   https://github.com/telefonicaid/fiware-sth-comet/blob/master/doc/manuals/running.md
#   Possible values are: "DEBUG", "INFO", "WARN", "ERROR" and "FATAL" 
LOGOPS_LEVEL=INFO

# Quantumleap
#   INFO, DEBUG
QUANTUMLEAP_LOGLEVEL=INFO

# WireCloud
#   https://github.com/Wirecloud/docker-wirecloud/blob/master/README.md
WIRECLOUD_LOGLEVEL=INFO

# Tokenproxy
TOKENPROXY_LOGLEVEL=info
TOKENPROXY_VERBOSE=

# Queryproxy
QUERYPROXY_LOGLEVEL=info

# Regproxy log level
REGPROXY_LOGLEVEL=info

# Regproxy verbose
REGPROXY_VERBOSE=false

# Node-RED
#   https://nodered.org/docs/user-guide/runtime/logging
NODE_RED_LOGGING_LEVEL=info
NODE_RED_LOGGING_METRICS=
NODE_RED_LOGGING_AUDIT=

# Grafana
#   https://grafana.com/docs/grafana/latest/administration/configuration/#configure-with-environment-variables
#   https://github.com/grafana/grafana/blob/main/conf/defaults.ini
#   "debug", "info", "warn", "error", "critical"
GF_LOG_LEVEL=info

#   https://mosquitto.org/man/mosquitto-conf-5.html
#   debug, error, warning, notice, information, subscribe, unsubscribe, websockets, none, all
MOSQUITTO_LOG_TYPE=error,warning,notice,information
