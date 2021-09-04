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

# Set a name of e-mail of an admin user for Keyrock. Default: admin
IDM_ADMIN_EMAIL_NAME=

# Set a password of an admin user for Keyrock. Default: automatically generated
IDM_ADMIN_PASS=

# Set a e-mail address for certbot. Defaul: a e-mail address of an admin user for Keyrock.
CERT_EMAIL=

# Whether to revoke and reacquire the certificate. Default: false
CERT_REVOKE=
