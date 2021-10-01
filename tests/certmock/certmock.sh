#!/bin/sh

# MIT License
#
# Copyright (c) 2021 Kazuhito Suda
#
# This file is part of FIWARE Big Bang
#
# https://github.com/lets-fiware/FIWARE-Big-Bang
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#
# create root CA
#
craete_root_ca() {

  ROOT_CA_DIR=/root_ca

  if [ -e "${ROOT_CA_DIR}/root-ca.key" ]; then
    return
  fi

  cat <<EOF > "${ROOT_CA_DIR}/root-ca.cnf"
[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash
EOF

  openssl genrsa -out "${ROOT_CA_DIR}/root-ca.key" 4096

  openssl req -new -key "${ROOT_CA_DIR}/root-ca.key" -out "${ROOT_CA_DIR}/root-ca.csr" \
    -sha256 -subj "/C=JP/ST=Tokyo/L=Smart City/O=FIWARE/CN=FI-BB Secret Example CA"

  openssl x509 -req  -days 3650  -in "${ROOT_CA_DIR}/root-ca.csr" \
    -signkey "${ROOT_CA_DIR}/root-ca.key" -sha256 -out "${ROOT_CA_DIR}/root-ca.crt" \
    -extfile "${ROOT_CA_DIR}/root-ca.cnf" -extensions root_ca
}

#
# create cert
#
create_cert() {
  echo "create cert: ${DOMAIN}"

  if [ -z "${DOMAIN}" ]; then
    echo "domain not found"
    exit 1
  fi

  if [ -z "${IP_ADDRESS}" ]; then
    echo "IP address not found"
    exit 1
  fi

  craete_root_ca

  dir="/etc/letsencrypt/live/${DOMAIN}"

  echo "${dir}";
  mkdir -p "${dir}"

cat <<EOF > "${dir}/server.cnf"
[server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = DNS:${DOMAIN}, IP:${IP_ADDRESS}
subjectKeyIdentifier=hash
EOF

  openssl genrsa -out "${dir}/server.key" 4096

  openssl req -new -key "${dir}/server.key" -out "${dir}/server.csr" \
    -sha256 -subj "/C=JP/ST=Tokyo/L=Smart City/O=FIWARE/CN=${DOMAIN}"

  openssl x509 -req -days 3650 -in "${dir}/server.csr" -sha256 \
    -CA "${ROOT_CA_DIR}/root-ca.crt" -CAkey "${ROOT_CA_DIR}/root-ca.key" -CAcreateserial \
    -out "${dir}/server.crt" -extfile "${dir}/server.cnf" -extensions server

  mv "${dir}/server.crt" "${dir}/fullchain.pem"
  mv "${dir}/server.key" "${dir}/privkey.pem"
}

#
# revoke cert
#
revoke_cert() {
  echo "revoke cert: ${CERT_PATH}"

  CERT_PATH=$(dirname "${CERT_PATH}")

  if [ -d "${CERT_PATH}" ]; then 
    rm -fr "${CERT_PATH}"
  fi
}

#
# main
#
main() {
  echo "certmock $1"

  CMD=$1

  shift

  while [ "$1" ]
  do
    case $1 in
      "--agree-tos" ) ;;
      "-m" ) shift; EMAIL=$1 ;;
      "--webroot") ;;
      "-w" ) shift; CERT_DIR=$1 ;;
      "-d" ) shift; DOMAIN=$1 ;;
      "--cert-path" ) shift; CERT_PATH=$1 ;;
      "-n" ) ;;
      "-v" ) ;;
      *) echo "unknown option: $1"; exit 1 ;;
    esac
    shift
  done

  echo "CERT_PATH=${CERT_PATH}"
  case "$CMD" in
    "certonly" ) create_cert ;;
    "revoke" ) revoke_cert ;;
    * ) echo "$CMD not found"; exit 1 ;;
  esac
}

main "$@"
