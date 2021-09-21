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
NODE_RED=
GRAFANA=

# Set a name of an admin user for Keyrock. Default: admin
IDM_ADMIN_USER=

# Set an e-mail address of an admin user for Keyrock. Default: IDM_ADMIN_NAME @ DOMAIN_NAME
IDM_ADMIN_EMAIL=

# Set a password of an admin user for Keyrock. Default: automatically generated
IDM_ADMIN_PASS=

# Enable firewall. (true or false) Default: false
FIREWALL=

#
# Certbot options
#
# Set a e-mail address for certbot. Defaul: a e-mail address of an admin user for Keyrock.
CERT_EMAIL=

# Revoke and reacquire the certificate. (true or false) Default: false
CERT_REVOKE=

# Use --test-cert option. (true or false) Default: false
CERT_TEST=

# Use --force-renewal option. (true or false) Default: false
CERT_FORCE_RENEWAL=

# Docker images
IMAGE_KEYROCK=fiware/idm:8.0.0
IMAGE_WILMA=fiware/pep-proxy:8.0.0
IMAGE_ORION=fiware/orion:3.2.0
IMAGE_CYGNUS=fiware/cygnus-ngsi:2.10.0
IMAGE_COMET=fiware/sth-comet:2.8.0
IMAGE_WIRECLOUD=fiware/wirecloud:1.3.1
IMAGE_NGSIPROXY=fiware/ngsiproxy:1.2.2
IMAGE_QUANTUMLEAP=orchestracities/quantumleap:0.8.1

IMAGE_MONGO=mongo:4.4
IMAGE_MYSQL=mysql:5.7
IMAGE_POSTGRES=postgres:11
IMAGE_CRATE=crate:4.1.4

IMAGE_NGINX=nginx:1.21
IMAGE_REDIS=redis:6
IMAGE_ELASTICSEARCH=elasticsearch:2.4
IMAGE_MEMCACHED=memcached:1
IMAGE_GRAFANA=grafana/grafana:6.1.6
