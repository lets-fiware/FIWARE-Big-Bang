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
COMET=comet
QUANTUMLEAP=quantumleap
WIRECLOUD=wirecloud
NGSIPROXY=ngsiproxy
NODE_RED=node-red
GRAFANA=grafana

# Set a name of e-mail of an admin user for Keyrock. Default: admin
IDM_ADMIN_EMAIL_NAME=

# Set a password of an admin user for Keyrock. Default: automatically generated
IDM_ADMIN_PASS=

# Enable firewall. (true or false) Default: false
FIREWALL=

# Enable log file creation in /var/log/fiware. (true of false) Default: true
LOGGING=

# Set a e-mail address for certbot. Defaul: a e-mail address of an admin user for Keyrock.
CERT_EMAIL=

# Revoke and reacquire the certificate. (true or false) Default: false
CERT_REVOKE=
