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

# Enable log file creation in /var/log/fiware. (true of false) Default: true
LOGGING=

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
