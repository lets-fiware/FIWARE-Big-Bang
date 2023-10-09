#!/bin/sh
set -ue

LANG=C
LC_TIME=C

version_up() {
  FIBB_HOME=$PWD
  OLD=$1
  NEW=$(echo "${OLD}" | awk -F \. -v 'OFS=.' '{print $1, $2+1,$3 }')

  BRANCH="release/${NEW}"
  DATE=$(date "+%d %B, %Y")
  
  git switch -c "${BRANCH}"
  
  sed -i "1s/${OLD}-next/${NEW} - ${DATE}/" "${FIBB_HOME}/CHANGELOG.md"
  
  for file in README.md README.ja.md VERSION docs/en/installation/index.md docs/ja/installation/index.md lets-fiware.sh
  do
    file="${FIBB_HOME}/${file}"
    ls -l "${file}"
    sed -i -e "s/v${OLD}/v${NEW}/" "${file}"
    sed -i -e "s/FIWARE-Big-Bang-${OLD}/FIWARE-Big-Bang-${NEW}/" "${file}"
    sed -i -e "s/${OLD}-next/${NEW}/" "${file}"
  done
  
  sed -i -e "s/${OLD}-next/${NEW}/" "${FIBB_HOME}/config.sh"
  
  sed -i -e "s/${OLD}-next/${NEW}-next/" "${FIBB_HOME}/.github/pull_request_template.md"
  sed -i -e "s/${OLD}-next/${NEW}-next/" "${FIBB_HOME}/CONTRIBUTING.md"
  sed -i -e "s/${OLD}/${NEW}/" "${FIBB_HOME}/SECURITY.md"
  
  git add .
  git commit -m "Bump: ${OLD}-next -> ${NEW}"
  git push origin "${BRANCH}"
}

next_version() {
  FIBB_HOME=$PWD
  VER=$1
  
  BRANCH="release/${VER}_next"
  
  git switch -c "${BRANCH}"
  
  for file in VERSION lets-fiware.sh
  do
    file="${FIBB_HOME}/${file}"
    ls -l "${file}"
    sed -i -e "s/${VER}/${VER}-next/" "${file}"
  done
  
  sed -i "1i ## FIWARE Big Bang v${VER}-next\n" "${FIBB_HOME}/CHANGELOG.md"
  
  sed -i -e "s/node-red:${VER}/node-red:${VER}-next/" "${FIBB_HOME}/config.sh"
  sed -i -e "s/tokenproxy:${VER}/tokenproxy:${VER}-next/" "${FIBB_HOME}/config.sh"
  sed -i -e "s/queryproxy:${VER}/queryproxy:${VER}-next/" "${FIBB_HOME}/config.sh"
  sed -i -e "s/regproxy:${VER}/regproxy:${VER}-next/" "${FIBB_HOME}/config.sh"
  sed -i -e "s/postfix:${VER}/postfix:${VER}-next/" "${FIBB_HOME}/config.sh"
  sed -i -e "s/zeppelin:${VER}/zeppelin:${VER}-next/" "${FIBB_HOME}/config.sh"
  sed -i -e "s/pwgen:${VER}/pwgen:${VER}-next/" "${FIBB_HOME}/config.sh"
  
  git add .
  git commit -m "Bump: ${VER} -> ${VER}-next"
  git push origin "${BRANCH}"
}

main() {
  if ! [ -e VERSION ]; then
    echo "VERSION file not found"
    exit 1
  fi

  VERSION=$(sed "s/VERSION=//" VERSION | sed "s/-next//" | awk -F \. -v 'OFS=.' '{print $1, $2,$3 }')

  set +e
  RESULT=$(grep -ic -next VERSION)
  set -e

  if [ "${RESULT}" -eq 1 ]; then
    version_up "${VERSION}"
  else
    echo "next version"
    next_version "${VERSION}"
  fi
}

main "$@"
