# MIT License
# 
# Copyright (c) 2021-2022 Kazuhito Suda
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

FROM openjdk:8 as pac4j

COPY pom.xml /

# hadolint ignore=DL3008
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install maven git && \
    mvn dependency:copy-dependencies && \
    git clone -b pac4j-4.0.1 https://github.com/pac4j/pac4j.git && \
    sed -i -e "100,103d" /pac4j/pac4j-oidc/src/main/java/org/pac4j/oidc/credentials/extractor/OidcExtractor.java

COPY KeyrockOidcClient.java /pac4j/pac4j-oidc/src/main/java/org/pac4j/oidc/client/
COPY KeyrockRolesAuthorizationGenerator.java /pac4j/pac4j-oidc/src/main/java/org/pac4j/oidc/authorization/generator/
COPY KeyrockOidcProfile.java /pac4j/pac4j-oidc/src/main/java/org/pac4j/oidc/profile/keyrock/
COPY CustomCallbackLogic.java /jp/letsfiware/pac4j/

# hadolint ignore=DL3003
RUN \
    cd pac4j/pac4j-core && \
    mvn compile && \
    mvn package && \
    cd ../pac4j-oidc && \
    mvn compile && \
    mvn package && \
    cd ../.. && \
    cp /pac4j/pac4j-oidc/target/pac4j-oidc-4.0.1.jar /target/dependency/ && \
    cp /pac4j/pac4j-core/target/pac4j-core-4.0.1.jar /target/dependency/ && \
    javac -cp "./target/dependency/pac4j-core-4.0.1.jar" jp/letsfiware/pac4j/CustomCallbackLogic.java && \
    jar cvf customCallbackLogic.jar jp/letsfiware/pac4j/ && \
    cp customCallbackLogic.jar /target/dependency/

FROM ubuntu:20.04 as cmd

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install curl gnupg curl gpg-agent ca-certificates && \
    curl -sL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list && \
    apt-get update && \
    apt-get -y --no-install-recommends install mongodb-org-shell && \
    curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.11.0/ngsi-v0.11.0-linux-amd64.tar.gz && \
    tar zxvf ngsi-v0.11.0-linux-amd64.tar.gz -C /usr/local/bin

FROM apache/zeppelin:0.9.0

COPY --from=pac4j /target/dependency/ /opt/zeppelin/lib/
COPY --from=cmd /usr/bin/mongo /usr/bin/
COPY --from=cmd /usr/lib/x86_64-linux-gnu/ /usr/lib/x86_64-linux-gnu/
COPY --from=cmd /usr/local/bin/ngsi /usr/local/bin/

# debug: COPY pac4j-core-4.0.1.jar /opt/zeppelin/lib/
# debug: COPY pac4j-oidc-4.0.1.jar /opt/zeppelin/lib/
