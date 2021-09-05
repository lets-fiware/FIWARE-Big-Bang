#!/bin/bash

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

set -ue

DISTRO=

get_distro() {
  if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
    if [ -e /etc/lsb-release ]; then
      ver="$(sed -n -e "/DISTRIB_RELEASE=/s/DISTRIB_RELEASE=\(.*\)/\1/p" /etc/lsb-release | awk -F. '{printf "%2d%02d", $1,$2}')"
      if [ "${ver}" -ge 1804 ]; then
        DISTRO="Ubuntu"
      else
        echo "Error: Ubuntu ${ver} not supported"
        exit 1
      fi
    else
      echo "Error: not Ubuntu"
      exit 1
    fi
  elif [ -e /etc/redhat-release ]; then
    DISTRO="CentOS"
  else
    echo "Unknown distro" 
    exit 1
  fi

  echo "DISTRO=${DISTRO}" >> .env
  echo -e -n "\n" >> .env
}

check_machine() {
  machine=$(uname -m)
  if [ "${machine}" = "x86_64" ]; then
    return
  fi

  echo "Error: ${machine} not supported"
  exit 1

}

install_commands_ubuntu() {
  sudo apt-get update
  sudo apt-get install -y curl pwgen jq
}

install_commands_centos() {
  sudo yum install -y epel-release
  sudo yum install -y curl pwgen jq
}

install_commands() {
  update=false
  for cmd in curl pwgen jq
  do
    if ! type "${cmd}" >/dev/null 2>&1; then
        update=true
    fi
  done

  if "${update}"; then
    case "${DISTRO}" in
      "Ubuntu" ) install_commands_ubuntu ;;
      "CentOS" ) install_commands_centos ;;
    esac
  fi
}

setup_firewall() {
  if "${FIREWALL}"; then
    case "${DISTRO}" in
      "Ubuntu" ) sudo apt install -y firewalld ;;
      "CentOS" ) sudo yum -y install firewalld ;;
      *) return ;;
    esac
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
    sudo firewall-cmd --zone=public --add-service=http --permanent
    sudo firewall-cmd --zone=public --add-service=https --permanent
    sudo firewall-cmd --reload
  fi
}

install_docker_ubuntu() {
  sudo cp -p /etc/apt/sources.list{,.bak}
  sudo apt-get update
  sudo apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
  sudo apt-get install -y docker-ce
 sudo systemctl start docker
 sudo systemctl enable docker
}

install_docker_centos() {
 sudo yum install -y yum-utils
 sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
 sudo yum install -y docker-ce docker-ce-cli containerd.io
 sudo systemctl start docker
 sudo systemctl enable docker
}

check_docker() {
  if ! type docker >/dev/null 2>&1; then
    case "${DISTRO}" in
       "Ubuntu" ) install_docker_ubuntu ;;
       "CentOS" ) install_docker_centos ;;
    esac
    return
  fi

  ver=$(sudo docker version -f "{{.Server.Version}}" | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
  if [ "${ver}" -ge 201006 ]; then
      return
  fi

  echo "Docker engine requires equal or higher version than 20.10.6"
  exit 1
}

check_docker_compose() {
  if [ -e /usr/local/bin/docker-compose ]; then
    ver=$(sudo /usr/local/bin/docker-compose version --short | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
    if [ "${ver}" -ge 11700 ]; then
      return
    fi
  fi

  curl -sOL https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64
  sudo mv docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

check_ngsi_go() {
  if [ -e /usr/local/bin/ngsi ]; then
    ver=$(/usr/local/bin/ngsi --version | sed -e "s/ngsi version \([^ ]*\) .*/\1/" | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
    if [ "${ver}" -ge 900 ]; then
        return
    fi
  fi

  curl -sOL https://github.com/lets-fiware/ngsi-go/releases/download/v0.9.0/ngsi-v0.9.0-linux-amd64.tar.gz
  sudo tar zxf ngsi-v0.9.0-linux-amd64.tar.gz -C /usr/local/bin
  rm -f ngsi-v0.9.0-linux-amd64.tar.gz
}

check_machine
get_distro
install_commands

setup_firewall

check_docker
check_docker_compose
check_ngsi_go
