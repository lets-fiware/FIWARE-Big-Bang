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

cd "$(dirname "$0")"
cd ../..

logging() {
  /usr/bin/logger -is -p "$1" -t "FI-BB" "$2"
}

logging "user.info" "install widgets"

if [ ! -e ./.env ]; then
  logging "user.err" "./env not found"
  exit 1
fi

. ./.env

if [ -z "${WIRECLOUD}" ]; then
  exit 1
fi

mkdir -p "${WORK_DIR}/widgets/"

while read -r line
do
  name="$(basename "${line}")"
   logging "user.info" "Installing ${name}"
  fullpath="${WORK_DIR}/widgets/${name}"

  curl -sL "${line}" -o "${fullpath}"
  ngsi macs --host "${WIRECLOUD}" install --file "${fullpath}" --overwrite
done < "${SETUP_DIR}/widgets_list.txt"

rm -fr "${WORK_DIR}"
