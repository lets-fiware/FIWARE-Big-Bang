#!/bin/sh

# Nifi patch

if [ -z "${OIDC_DISCOVERY_URL}" ] || [ -z "${OIDC_CLIENT_ID}" ] || [ -z "${OIDC_CLIENT_SECRET}" ]; then
  echo "OIDC config does not exist."  
  exit 1
fi

prop_replace 'nifi.security.user.oidc.discovery.url'   "${OIDC_DISCOVERY_URL}"
prop_replace 'nifi.security.user.oidc.client.id'       "${OIDC_CLIENT_ID}"
prop_replace 'nifi.security.user.oidc.client.secret'   "${OIDC_CLIENT_SECRET}"
prop_replace 'nifi.security.user.oidc.additional.scopes'   "openid"
prop_replace 'nifi.security.user.oidc.claim.identifying.user'   "email"
prop_replace 'nifi.security.user.oidc.fallback.claims.identifying.user'   "upn"
prop_replace 'nifi.security.user.oidc.preferred.jwsalgorithm'   "${OIDC_PREFERRED_JWSALGORITHM:-RS256}"

if [ -n "${WEB_PROXY_HOST}" ]; then
  prop_replace 'nifi.web.proxy.host'   "${WEB_PROXY_HOST}"
fi

if [ -z "${INITIAL_ADMIN_IDENTITY}" ]; then
  echo "INITIAL_ADMIN_IDENTITY does not exist."
  exit 1
fi

for file in nifi-app.log nifi-bootstrap.log nifi-user.log
do
  file=/opt/nifi/nifi-current/logs/"${file}"
  if [ -e "${file}" ]; then
    rm "${file}"
  fi
  ln -snf /dev/stdout "${file}"
done
