#!/bin/sh

#
# create cert
#
create_cert() {
  echo "create cert: ${DOMAIN}"

  if [ -z "${DOMAIN}" ]; then
    echo "domain not found"
    exit 1
  fi

  DIR="/etc/letsencrypt/live/${DOMAIN}"

  echo "${DIR}";
  mkdir -p "${DIR}"

  openssl genrsa 2048 > "${DIR}/server.key"
  openssl req -new -key "${DIR}/server.key" << EOF > "${DIR}/server.csr"
JP
Tokyo
Smart city
Let's FIWARE
FI-BB
${DOMAIN}
fiware@example.com
fiware

EOF

  openssl x509 -days 3650 -req -signkey "${DIR}/server.key" < "${DIR}/server.csr" > "${DIR}/server.crt"
  openssl rsa -in "${DIR}/server.key" -out "${DIR}/server.key" << EOF
fiware
EOF

  mv "${DIR}/server.crt" "${DIR}/fullchain.pem"
  mv "${DIR}/server.key" "${DIR}/privkey.pem"
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
