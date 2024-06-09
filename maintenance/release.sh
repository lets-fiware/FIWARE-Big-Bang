#!/bin/bash

# MIT License
#
# Copyright (c) 2023 Kazuhito Suda
#
# This file is part of FIWARE Small Bang
#
# https://github.com/lets-fiware/FIWARE-Small-Bang
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

set -ue

cd "$(dirname "$0")"
cd ..

TAG=$(cat VERSION)
TAG="v${TAG##*=}"
VER=${TAG//v/}
echo "TAG: ${TAG}"
echo "VER: ${VER}"

if echo "${TAG}" | grep -q "-next"
then
  exit 0
fi

if git tag | grep -q "${TAG}"
then
  exit 0
fi

AUTHOR_NAME=$(jq -r '.pull_request.merged_by.login' "$GITHUB_EVENT_PATH")
AUTHOR_EMAIL=$(jq -r '.pull_request.merged_by.email' "$GITHUB_EVENT_PATH")

git config user.name "${AUTHOR_NAME}"
git config user.email "${AUTHOR_EMAIL}"
git tag "${TAG}"
git push origin "${TAG}"

NAME=${REPO##*/}

echo "NAME: ${NAME}"
echo "REPO: ${REPO}"

FILE=CHANGELOG.md
LINES=$(grep -n "^##" -m 2 "${FILE}" | sed -e 's/:.*//g'| sed -z "s/\n/,/g" | sed "s/,$//")
CHANGE_LOG=$(sed -n "${LINES}p" "${FILE}" | sed -e "/^$/d" -e "/^##/d" | sed -z "s/\n/\\\\n/g")
echo "${CHANGE_LOG}"

RES=$(curl -X POST \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     -d "{ \"tag_name\": \"${TAG}\", \"name\": \"${NAME//-/ } ${TAG}\", \"body\": \"${CHANGE_LOG}\"}" \
     "https://api.github.com/repos/${REPO}/releases")

# Create tar.gz file

DIR="${NAME}-${TAG//v/}"
mkdir "${DIR}"

for FILE in LICENSE README.md config.sh .config.sh lets-fiware.sh
do
  cp -a "${FILE}" "${DIR}/"
done

for FILE in CONTRIB extras examples setup
do
  cp -ar "${FILE}" "${DIR}/"
done

FILE="${DIR}.tar.gz"

tar czvf "${FILE}" "${DIR}"

rm -fr "${DIR}"

## Upload tar.gz file

UPLOAD_URL=$(echo "${RES}" | jq '. | .upload_url' | tr -d '"')
UPLOAD_URL="${UPLOAD_URL%%\{*}?name=${FILE}"
echo "UPLOAD URL: ${UPLOAD_URL}"

curl -L -X POST "${UPLOAD_URL}" -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H 'Accept: application/vnd.github+json' \
     -H 'Content-Type: application/gzip' \
     --data-binary "@${FILE}"

rm -f "${FILE}"

## Create -next branch

git switch -c "${TAG}-next"
git push origin "${TAG}-next"

## Create branch
git switch -c "release/${VER}_next"

VER_SED=${VER//\./\\.}

for FILE in VERSION lets-fiware.sh
do
  sed -i -e "s/${VER_SED}/${VER_SED}-next/" "${FILE}"
done

sed -i "1i ## FIWARE Big Bang v${VER_SED}-next\n" CHANGELOG.md

sed -i -e "s/node-red:${VER_SED}/node-red:${VER_SED}-next/" config.sh
sed -i -e "s/tokenproxy:${VER_SED}/tokenproxy:${VER_SED}-next/" config.sh
sed -i -e "s/queryproxy:${VER_SED}/queryproxy:${VER_SED}-next/" config.sh
sed -i -e "s/regproxy:${VER_SED}/regproxy:${VER_SED}-next/" config.sh
sed -i -e "s/postfix:${VER_SED}/postfix:${VER_SED}-next/" config.sh
sed -i -e "s/zeppelin:${VER_SED}/zeppelin:${VER_SED}-next/" config.sh
sed -i -e "s/pwgen:${VER_SED}/pwgen:${VER_SED}-next/" config.sh

git add .
git commit -m "Bump: ${VER} -> ${VER}-next"
git push origin "release/${VER}_next"

## Create PR

gh pr create --base "${TAG}-next" --head "release/${VER}_next" --title "Bump: ${VER} -> ${VER}-next" --body "This PR is a preparation for the next release."
